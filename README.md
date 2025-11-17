# vmware-automation

A collection of **production-tested automation scripts** for VMware environments, focused on vSphere and vRealize / Aria Operations.

This repository provides both **PowerShell** and **Python** examples that VMware automation engineers, SREs, and architects can reuse, adapt, and extend for their own infrastructure.

---

## Goals

- Provide **ready-to-run** scripts that solve real operational problems.
- Use **clean, readable** code with comments and examples.
- Share **patterns and ideas**, not just one-off scripts.
- Support both **Windows/PowerShell** and **Python**-based automation.

---

## Tech Stack

- **VMware vSphere**
- **VMware Aria Operations (vROps / vRealize Operations)**
- **PowerShell** (including REST API calls)
- **Python** (for API and SDK-based automation)

---

## Repository Layout

```text
powershell/
  vrops/
    Get-VROpsClusterStats.ps1    # 180-day cluster stats export from vROps
    README.md                    # Details for vROps-related PowerShell scripts

python/
  README.md                      # Python script overview and usage
