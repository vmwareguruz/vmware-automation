<#
.SYNOPSIS
Collects 180 days of CPU and memory cluster statistics from VMware Aria Operations (vROps).

.DESCRIPTION
This script authenticates to vROps, retrieves all vSphere clusters, and collects
180 days of historical CPU and memory metrics using the vROps Suite API.  
Final averaged results are exported to a CSV file in the specified output folder.

This script is designed for VMware automation engineers and architects who want
production-ready metric extraction for reporting, capacity analysis, and automation workflows.

.PARAMETER OutputFolder
The folder where the CSV file (vROps_Cluster_180DayStats.csv) will be saved.

.EXAMPLE
PS> .\Get-VROpsClusterStats.ps1 -OutputFolder "C:\Reports"

.NOTES
- Requires a global PSCredential: $Global:SharedCred
- Requires the helper function: Initialize-GlobalCredentials
- Tested in production environments
- Uses REST API calls, no PowerCLI dependency

#>

param([Parameter(Mandatory = $true)][string]$OutputFolder)

# ==========================================
# Settings
# ==========================================
$Server     = "https://vrops.domain.com"
$AuthSource = "domain"
$DaysBack   = 180
$OutputCsv  = Join-Path $OutputFolder "vROps_Cluster_${DaysBack}DayStats.csv"

$targetKeys = @(
    "cpu|capacity_contentionPct",
    "cpu|capacity_usagepct_average",
    "cpu|vcpus_allocated_on_all_vms",
    "cpu|vcpus_to_cores_allocation_ratio",
    "mem|memory_allocated_on_all_vms",
    "mem|reservedCapacity_average",
    "mem|usage_average",
    "mem|virtual_to_physical_memory_allocation_ratio"
)

# ==========================================
# Authentication
# ==========================================
$username = $Global:SharedCred.UserName
$plainPassword = $Global:SharedCred.GetNetworkCredential().Password

$authBody = @{
    username   = $username
    password   = $plainPassword
    authSource = $AuthSource
} | ConvertTo-Json

try {
    Write-Host "`n🔐 Authenticating to vROps..."
    $auth = Invoke-RestMethod -Method POST -Uri "$Server/suite-api/api/auth/token/acquire?_no_links=true" `
        -Headers @{ "Content-Type"="application/json"; "Accept"="application/json" } `
        -Body $authBody -SkipCertificateCheck
}
catch {
    Write-Warning "Authentication failed. Trying credential refresh..."
    Initialize-GlobalCredentials -ForceRefresh

    $username = $Global:SharedCred.UserName
    $plainPassword = $Global:SharedCred.GetNetworkCredential().Password

    $authBody = @{
        username   = $username
        password   = $plainPassword
        authSource = $AuthSource
    } | ConvertTo-Json

    try {
        $auth = Invoke-RestMethod -Method POST -Uri "$Server/suite-api/api/auth/token/acquire?_no_links=true" `
            -Headers @{ "Content-Type"="application/json"; "Accept"="application/json" } `
            -Body $authBody -SkipCertificateCheck
    }
    catch {
        throw "❌ Authentication failed even after refresh. Check credentials."
    }
}

$headers = @{
    "Authorization" = "vRealizeOpsToken $($auth.token)"
    "Accept"        = "application/json"
}

# ==========================================
# Fetch Clusters
# ==========================================
Write-Host "`n🔎 Fetching clusters..."
try {
    $resp = Invoke-RestMethod -Method GET -Uri "$Server/suite-api/api/resources?adapterKind=VMWARE&resourceKind=ClusterComputeResource&_no_links=true" -Headers $headers -SkipCertificateCheck
    $clusters = $resp.resourceList
    if (-not $clusters) { throw "No clusters found!" }
    Write-Host "✅ Clusters found: $($clusters.Count)"
}
catch {
    Write-Error "Cluster fetch failed: $_"
    return
}

# ==========================================
# Time Window Setup (180 days)
# ==========================================
$endUtc   = [DateTime]::UtcNow
$beginUtc = $endUtc.AddDays(-$DaysBack)
$epoch    = [DateTime]::UnixEpoch

$beginMs  = [int64](($beginUtc - $epoch).TotalMilliseconds)
$endMs    = [int64](($endUtc   - $epoch).TotalMilliseconds)

$statKeyParams = ($targetKeys | ForEach-Object { "statKey=$_" }) -join "&"

# ==========================================
# Data Collection
# ==========================================
Write-Host "`n⏳ Collecting $DaysBack-day averages..."
$rows = @()

foreach ($cluster in $clusters) {
    $clusterName = $cluster.resourceKey.name
    $clusterId   = $cluster.identifier

    $statsUri = "$Server/suite-api/api/resources/stats?resourceId=$clusterId&$statKeyParams&rollUpType=AVG&intervalType=DAYS&begin=$beginMs&end=$endMs&_no_links=true"

    try {
        $stats = Invoke-RestMethod -Method GET -Uri $statsUri -Headers $headers -SkipCertificateCheck
    }
    catch {
        Write-Warning "⚠️ Failed to fetch stats for cluster: $clusterName"
        continue
    }

    $metrics = @{}

    foreach ($key in $targetKeys) {
        $stat = $stats.values."stat-list".stat | Where-Object { $_.statKey.key -eq $key }

        if ($stat) {
            $points = $stat.data -split '\s+' | ForEach-Object { [double]$_ }
            $avg = ($points | Measure-Object -Average).Average

            if ($key -like "mem*" -and $avg -gt 1024) { 
                $avg = [math]::Round($avg / 1024, 2) # MB → GB
            }

            $metrics[$key] = $avg
        }
        else {
            $metrics[$key] = $null
        }
    }

    $rows += [PSCustomObject]@{
        ClusterName                                         = $clusterName
        cpu_capacity_contentionPct                          = $metrics["cpu|capacity_contentionPct"]
        cpu_capacity_usagepct_average                       = $metrics["cpu|capacity_usagepct_average"]
        cpu_vcpus_allocated_on_all_vms                      = $metrics["cpu|vcpus_allocated_on_all_vms"]
        cpu_vcpus_to_cores_allocation_ratio                 = $metrics["cpu|vcpus_to_cores_allocation_ratio"]
        mem_memory_allocated_on_all_vms                     = $metrics["mem|memory_allocated_on_all_vms"]
        mem_reservedCapacity_average                        = $metrics["mem|reservedCapacity_average"]
        mem_usage_average                                   = $metrics["mem|usage_average"]
        mem_virtual_to_physical_memory_allocation_ratio     = $metrics["mem|virtual_to_physical_memory_allocation_ratio"]
    }
}

# ==========================================
# Export
# ==========================================
Write-Host "`n📝 Exporting results to $OutputCsv..."
$rows | Export-Csv -NoTypeInformation -Path $OutputCsv
Write-Host "✅ Export complete.`n"