# Contributing to vmware-automation

Thank you for your interest in contributing!  
This repository is meant to help VMware automation engineers and architects share production-grade scripts.

## How to Contribute

### 1. Fork the repository
Click **Fork** at the top right.

### 2. Clone your fork

```bash
git clone https://github.com/<your-username>/vmware-automation.git
```

### 3. Create a feature branch

```bash
git checkout -b feature/new-script
```

### 4. Add your scripts

Place PowerShell scripts under:
```text
powershell/<category>/
```

Place Python scripts under:
```text
python/<category>/
```

### 5. Follow naming standards
- Use descriptive names  
- Include comment-based help (PowerShell)  
- Include docstrings (Python)  
- Add examples whenever possible  

### 6. Submit a Pull Request

Describe:
- Purpose  
- Requirements  
- What problem the script solves  

We will review and merge.

## Code Style

### PowerShell
- Follow PowerShell best practices  
- Use comment-based help  
- Include `try/catch` error handling  

### Python
- Use functions, not long scripts  
- Follow PEP8 formatting  
- Include docstrings  

## Thank You!

Your contributions make the VMware automation community stronger.
