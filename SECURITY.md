# Security Policy

## Supported

This repository contains **example and production-tested scripts** that may be used in sensitive environments (vSphere, vROps, etc.).  
Security is important, and reports are appreciated.

## Reporting a Vulnerability

If you discover a potential security issue:

1. **Do not** post sensitive details in a public GitHub issue.
2. Contact the repository owner privately via GitHub (e.g. direct message or email if listed).
3. Provide:
   - A description of the issue
   - Steps to reproduce (if possible)
   - Any relevant environment information (sanitized)

You will receive an acknowledgment as soon as the report is reviewed.

## Best Practices

When using scripts from this repo:

- Review scripts before running them in production.
- Use least-privilege service accounts where possible.
- Never commit credentials, tokens, or sensitive certificates to your own forks.
- Consider starting in a **lab environment** before rolling out to production.
