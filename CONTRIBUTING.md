---

# Contributing to vmware-automation

Thanks for your interest in contributing! 🎉
This repository is meant to be a practical toolbox for VMware automation engineers and architects.

---

## How to Contribute

1. **Fork** the repository.

2. Create a new **branch** for your change:

   ```bash
   git checkout -b feature/my-new-script
   ```

3. **Add or update**:

   * Scripts under the appropriate `powershell/` or `python/` folder.
   * A short README in that folder describing:

     * What it does
     * Inputs/parameters
     * Example usage

4. Run any tests or validation that make sense for your change.

5. **Commit and push your changes**:

   ```bash
   git commit -m "Add <short-description>"
   git push origin feature/my-new-script
   ```

6. **Open a Pull Request** against `main`.

---

## Coding Guidelines

### PowerShell

* Use descriptive function names (Verb-Noun style where possible).
* Include comment-based help (`.SYNOPSIS`, `.DESCRIPTION`, `.EXAMPLE`).
* Prefer advanced functions and typed parameters.
* Validate code with:

  * **PSScriptAnalyzer** for style and best practices.
* Avoid hardcoding credentials or secrets.

### Python

* Follow **PEP 8** style guidelines.
* Use virtual environments for dependencies.
* Include a `requirements.txt` or `pyproject.toml` where needed.
* Add docstrings for public functions and classes.

---

## Script Expectations

Scripts should be **idempotent** where possible (safe to run multiple times).

Include:

* Clear logging/output (e.g., what action is happening, target vCenter/vROps, etc.)
* Error handling and meaningful messages.

Avoid:

* Embedding production credentials.
* Including environment-specific secrets or private endpoints.

---

## Reporting Issues

If you find a bug:

1. Search existing issues first.
2. Open a new issue with:

   * Description of the problem
   * Steps to reproduce
   * Environment details (vSphere/vROps version, OS, PowerShell/Python version)

For security-related issues, please follow the process in **SECURITY.md**.

---
