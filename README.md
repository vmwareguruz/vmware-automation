# Get-VROpsClusterStats

PowerShell function to collect **180-day CPU and memory statistics for all VMware clusters** from a vRealize Operations (vROps / Aria Operations) instance and export the results to CSV.

This is useful for capacity planning, performance analysis, and cluster health reviews.

---

## Features

- ✅ Authenticates to vROps using cached global credentials  
- ✅ Automatically retries authentication if the token request fails  
- ✅ Discovers all `ClusterComputeResource` objects from the vROps API  
- ✅ Collects 180-day daily averages for key CPU & memory metrics  
- ✅ Normalizes/aggregates the data and exports to CSV for reporting  

---

## Collected Metrics

The function pulls these vROps stat keys for each cluster:

- `cpu|capacity_contentionPct`
- `cpu|capacity_usagepct_average`
- `cpu|vcpus_allocated_on_all_vms`
- `cpu|vcpus_to_cores_allocation_ratio`
- `mem|memory_allocated_on_all_vms`
- `mem|reservedCapacity_average`
- `mem|usage_average`
- `mem|virtual_to_physical_memory_allocation_ratio`

In the CSV output, these are exposed as:

- `ClusterName`
- `cpu_capacity_contentionPct`
- `cpu_capacity_usagepct_average`
- `cpu_vcpus_allocated_on_all_vms`
- `cpu_vcpus_to_cores_allocation_ratio`
- `mem_memory_allocated_on_all_vms`
- `mem_reservedCapacity_average`
- `mem_usage_average`
- `mem_virtual_to_physical_memory_allocation_ratio`

> Note: Large memory values are converted from MB to GB when they exceed 1024.

---

## Prerequisites

- **PowerShell** 5.x or later (Core also works if `Invoke-RestMethod` is available).
- Network connectivity to your vROps/Aria Operations instance.
- A vROps user with API access to:
  - Acquire an auth token
  - Read resource and stats data for VMware clusters
- A global credential object available as:

  ```powershell
  $Global:SharedCred  # [System.Management.Automation.PSCredential]
# vmware-automation
Useful Scripts for any VMware Engineer/Architect
