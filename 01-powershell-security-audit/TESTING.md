
# Windows Endpoint Security Audit — Testing

## Test Environment

- Operating System: To be recorded
- PowerShell Version: To be recorded
- Device: Personal lab computer
- Test Date: To be recorded

## Test Cases

| ID | Security Check | Expected Behaviour | Result |
|---|---|---|---|
| T01 | Microsoft Defender | Reports antivirus and real-time protection status | Not tested |
| T02 | Windows Firewall | Reports Domain, Private and Public firewall profiles | Not tested |
| T03 | Secure Boot | Reports whether Secure Boot is enabled | Not tested |
| T04 | BitLocker | Reports operating system drive protection status | Not tested |
| T05 | Windows Updates | Reports latest available hotfix record | Not tested |

## Validation

For each test:
1. Run the audit script.
2. Record the returned status.
3. Compare the result with the Windows security configuration.
4. Document any differences or errors.
5. Record possible improvements.

## Known Limitations

- Microsoft Defender may be inactive when third-party antivirus software is installed.
- Some security checks require administrator permissions.
- Get-HotFix does not provide complete Windows Update compliance information.
- A PASS result does not establish overall endpoint security.

## Test Summary

Pending first execution on a personal lab device.
