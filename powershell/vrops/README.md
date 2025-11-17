# VMware Aria Operations (vROps) PowerShell Scripts

This folder contains **PowerShell automation scripts** that integrate with  
**VMware Aria Operations (formerly vROps)** using the Suite API.

These scripts help automation engineers and architects collect metrics,  
build reports, and build backend automation pipelines for vSphere environments.

---

## 📌 Scripts in this folder

### **Get-VROpsClusterStats.ps1**
Collects **180-day CPU and Memory statistics for all vSphere clusters** from vROps  
and exports the results to CSV.

*(More scripts will be added over time.)*

---

## 🧰 Requirements

- PowerShell 7+ or Windows PowerShell 5.1  
- API access to VMware Aria Operations (vROps)  
- A global credential object:

```powershell
$Global:SharedCred = Get-Credential



▶️ Example Usage
cd powershell/vrops/

.\Get-VROpsClusterStats.ps1 -OutputFolder "C:\Reports"


To see the full help for any script:

Get-Help .\Get-VROpsClusterStats.ps1 -Full

🧩 Naming Standards

All vROps scripts follow:

Get-VROps<Name>.ps1
New-VROps<Name>.ps1
Invoke-VROps<Name>.ps1


This keeps the automation library consistent and easy to navigate.

🤝 Contributing

When adding new vROps scripts:

Place them in this folder

Include comment-based help

Add a one-line description above to keep this list updated