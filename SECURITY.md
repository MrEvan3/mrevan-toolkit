# Security Policy

## Supported Versions

We release updates for the **Mr Evan Intelligent Repair System** script. Security-related fixes are applied to the current main branch.

| Version | Supported          |
| ------- | ------------------ |
| main    | :white_check_mark: |
| older   | :x:                |

## Reporting a Vulnerability

If you believe you have found a security vulnerability in this project:

1. **Do not** open a public issue.
2. Send a private report to the repository maintainers (e.g. via GitHub Security Advisories or the contact method indicated in the repository).
3. Include a clear description of the issue, steps to reproduce, and impact if possible.
4. Allow a reasonable time for a fix before any public disclosure.

We will do our best to respond and, if applicable, release a fix. Thank you for helping keep this project safe.

## Scope

This project is a PowerShell script for local system maintenance and offline recovery. It does not collect or transmit your data to external servers, except when you explicitly choose options that call external services or download third-party tools (e.g., WinUtil, MAS, AnyDesk). 

**Warning regarding Advanced and Recovery Modes:**
Certain features in the Advanced Technical Mode and Offline Recovery Mode (WinPE) perform deep system modifications. This includes altering boot records (MBR/BCD), changing network stacks, and modifying authentication binaries (such as the `utilman.exe` bypass for administrative access). 

Use this script **only** in environments you trust, on computers you own or have explicit authorization to repair, and with the appropriate administrator privileges.