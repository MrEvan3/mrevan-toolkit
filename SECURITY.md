# SECURITY POLICY

## Supported Versions

We actively maintain and release updates for the **Mr Evan Intelligent Repair System (IRS)**.

Security-related patches, internal hardening improvements, and new SOC/EDR integrations are applied exclusively to the current main branch (**v2.0 Elite**).

| Version      | Supported |
|-------------|-----------|
| v2.0 Elite  | ✅ Yes    |
| v1.0 / v1.3 | ❌ No     |

Older versions are considered deprecated and will not receive security updates.

---

## Reporting a Vulnerability

If you believe you have identified a security vulnerability, privilege escalation path, bypass of safeguards, or design flaw:

- **Do NOT open a public issue.**
- Submit a private report via:
  - GitHub Security Advisories (preferred), or
  - The official contact method listed in the repository.

Please include:

- A clear description of the issue
- Steps to reproduce
- Potential impact
- Environment details (Windows version, PowerShell version)

We request a reasonable disclosure window before any public release of details.

We are committed to responsible disclosure and will respond as quickly as possible.

Thank you for helping strengthen this project.

---

## Scope, Telemetry, and Privacy

The Mr Evan Intelligent Repair System is a **local-first PowerShell-based maintenance and SOC auditing framework**.

### No Phoning Home

This project:

- Does NOT collect personal data
- Does NOT transmit system telemetry
- Does NOT include hidden tracking
- Does NOT send analytics to developer-controlled servers

All operations execute locally on the host machine.

---

### Third-Party APIs (Threat Intelligence Modules)

Optional modules (e.g., Network Radar, EDR Analysis) may interact with third-party APIs strictly for:

- IP geolocation and ASN resolution (e.g., ipinfo.io)
- Threat intelligence lookup (e.g., VirusTotal)
- SHA-256 hash cross-referencing

These requests:

- Are initiated locally by the user
- Transmit only the queried IP address or file hash
- Do not include personal identifiers
- Are not stored by this project

Users are responsible for reviewing third-party API terms and privacy policies.

---

## Local Auditing and Storage

The toolkit may generate local artifacts such as:

- Plain text logs
- HTML dashboards
- JSON baseline snapshots

These are stored locally in:

C:\ProgramData\MrEvanIRS

and optionally on the user's Desktop.

No automatic data transmission occurs.

---

## Built-in Security Measures (v2.0 Elite+)

To prevent misuse or weaponization, version 2.0 Elite includes internal defensive safeguards.

### Anti-Remote Execution (Killswitch)

The script blocks execution from:

- Remote PowerShell sessions
- SSH sessions
- WinRM
- Non-interactive shells

If remote execution is detected, the script automatically terminates.

This measure reduces the risk of abuse for lateral movement across networks.

---

### Access Control – Danger Zone Lock

High-impact modules (including kernel-level and boot modifications) are protected by:

- PIN-based execution lock
- Explicit warning prompts
- Manual confirmation requirements

This prevents accidental or unauthorized execution.

---

### Auto-Rollback Safeguards

Before applying critical system modifications, the script automatically creates backups when applicable, including:

- Registry snapshots (.reg)
- Boot configuration backups (.bcd)
- Group Policy exports

These backups allow recovery in case of unintended consequences.

---

## Warning – Advanced & Recovery Modes

Advanced Technical Mode and Offline Recovery Mode (WinPE) may perform deep system modifications, including:

- Boot record manipulation (MBR / BCD)
- Network stack resets (Winsock / TCP-IP)
- Group Policy injection for system recovery
- Authentication binary modification for administrative recovery scenarios

These functions are intended strictly for legitimate system repair and authorized environments.

---

## Responsible Use Disclaimer

This toolkit is designed for:

- System administrators
- IT technicians
- Security analysts
- Authorized repair environments

You must use this tool only on systems:

- You own, or
- You have explicit authorization to service

The developer assumes no responsibility for:

- Unauthorized access attempts
- Ethical misconduct
- Policy violations
- Illegal use of password recovery or forensic features

Use responsibly.