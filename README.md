---

# Windows Defender Security Center Removal Script

## Overview
This PowerShell script is designed to permanently remove the Windows Defender Security Center (SecHealthUI) application from Windows and prevent it from being reinstalled during updates.

---

## Usage
1. Save the script as `Defender.ps1`.
2. Open PowerShell as **Administrator**.
3. Run the script using the following command:
   ```powershell
   .\Defender.ps1
   ```
---

## How It Works
- Removes **SecHealthUI** for all users on the system.
- Creates registry entries to prevent the app from being reinstalled.
- Uses **DISM** to mark the app as removable.

---
## Requirements

- **Operating System**: Windows 10 or Windows 11  
- **Permissions**: Must be run with administrative privileges  
---

## Customization
To remove additional apps, modify the `$removeappx` array in the script to include the names of other applications you want to target.

---
