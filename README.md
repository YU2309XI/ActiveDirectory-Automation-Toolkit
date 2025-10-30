# 🧰 Active Directory Automation Toolkit
[![PowerShell 5.1+](https://img.shields.io/badge/PowerShell-5.1%2B-blue)]()
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)]()
[![Platform](https://img.shields.io/badge/Platform-Windows%20Server%20%7C%20Demo%20Mode-lightgrey)]()
[![Automation Ready](https://img.shields.io/badge/Automation%20Ready-Yes-brightgreen)]()

A modular **PowerShell toolkit** designed to automate common **Active Directory administration** tasks — such as **bulk user creation**, **inactive account detection**, and **report generation** — all within a clean and interactive command-line interface (CLI).

---

## 🚀 Features

| Function | Description |
|-----------|--------------|
| **Bulk Create AD Users** | Create multiple AD accounts from a CSV file with secure random passwords and formatted usernames. |
| **Inactive Account Report** | Identify users inactive for a configurable number of days, or those who have never logged in. |
| **Disable Inactive Accounts** | Automatically disable stale accounts with audit logging and progress feedback. |
| **HTML & CSV Reporting** | Generate detailed and summary reports for IT compliance and license optimization. |
| **Simulation Mode (Demo)** | Run the entire toolkit without an AD environment — perfect for learning and demos. |
| **Interactive CLI** | One-entry PowerShell interface with menu navigation, real-time logging, and colorized output. |

---

## 🧩 Module Overview

| Script | Purpose |
|---------|----------|
| `Invoke-ADToolkit.ps1` | Main entry point. Handles menu UI, user input, and report orchestration. |
| `ADToolkit.psm1` | Core functions for AD operations (bulk creation, reporting, disabling). |
| `Utils.ps1` | Helper functions for logging, validation, and file management. |
| `inactive_users_report.csv` | Example generated report (demo data only). |
| `sample_users.csv` | Sample input data for bulk user creation testing. |

---

## 🧠 Core Functionalities

### 1. Bulk User Creation

```powershell
.\Invoke-ADToolkit.ps1
# Choose option 1 in menu
# Sample CSV input:
# FirstName,LastName,Department,Title,Email
# John,Smith,IT,Support Specialist,jsmith@company.com
```

**Highlights**
- Auto-generate usernames (first initial + last name).
- Create random 12-character passwords with uppercase, lowercase, number, and symbol.
- Supports `-WhatIf` dry-run mode for safe testing.
- Logs all created accounts to a CSV report.

---

### 2. Inactive Account Report

```powershell
.\Invoke-ADToolkit.ps1
# Choose option 2
# Default: 90 days inactivity threshold
```

**Output example (demo mode):**

| Username | Last Logon | Status | Department | Email |
|-----------|-------------|----------|-------------|--------|
| ajones | 2024-06-12 | Inactive 130d | HR | ajones@company.com |
| lwang | Never logged in | Inactive | IT | lwang@company.com |

**Result files:**
```
reports/inactive_users_report_2025-10-30.csv
reports/inactive_users_summary_2025-10-30.html
```

---

### 3. Disable Inactive Accounts

```powershell
.\Invoke-ADToolkit.ps1
# Choose option 3
```

**CLI Output Example:**
```
============================================
 Active Directory Automation Toolkit
============================================
1) Bulk Create AD Users
2) Generate Inactive User Report
3) Disable Inactive Accounts
4) Open Last HTML Report
q) Quit
--------------------------------------------
Select an option: 3

Disabled account: ajones
Disabled account: lwang

✅ Inactive accounts processed: 2
Press Enter to continue...
```

---

## 📁 Directory Structure

```
ActiveDirectory-Automation-Toolkit/
│
├── Invoke-ADToolkit.ps1          # Main launcher with CLI menu
├── ADToolkit.psm1                # Module functions for AD tasks
├── Utils.ps1                     # Helper utilities (logging, cleanup, reporting)
├── sample_users.csv              # Example input data
├── inactive_users_report.csv     # Example report output
├── README.md                     # Documentation (this file)
└── reports/                      # Auto-generated output folder
```

---

## ⚙️ Requirements

**For production:**
- Windows PowerShell 5.1+
- Active Directory RSAT module
- AD admin or delegated permissions

**For demo mode (no AD required):**
- PowerShell 5.1+
- Local execution policy: `RemoteSigned`

---

## 🧾 Example Use Cases

- Automate **onboarding** for new employees.
- Run quarterly **security audits** to identify inactive accounts.
- Perform **license cleanup** in Microsoft 365 environments.
- Learn and demonstrate **AD scripting and automation** in a safe lab setup.

---

## 🧑‍💻 Skills Demonstrated

- PowerShell scripting & modular architecture
- Active Directory administration
- Automation & CLI UX design
- CSV/HTML reporting generation
- Logging, exception handling, and cleanup automation

---

## 🪄 Future Improvements

- GUI dashboard (WinForms/WPF) for non-technical users
- Scheduled task integration for automatic weekly audits
- Email notification for managers before account disabling

---

## 📄 License

MIT License — free for educational and internal IT automation purposes.
