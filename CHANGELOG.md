# CHANGELOG

## 0.2.0

*   Swapped the `MSAL.PS` dependency for `PSMSALNet` (`MSAL.PS` has been archived/unsupported)
*   `Connect-ODS`: `-TenantId`/`-ClientId` are now `[guid]` (was `[string]`)
*   `Connect-ODS`: `-AzureCloudInstance` is now a string from `AzurePublic`/`AzureChina`/`AzureUsGovernment`/`AzureGermany` (was an `int` 0-4)
*   Minimum PowerShell version raised to 7.4; Windows PowerShell 5.1 (Desktop edition) is no longer supported

## 0.1.1

*   Fixed issue [#1](https://github.com/derpenstiltskin/onedriveshortcuts/issues/1#issue-1504890237) by adding option to specify AzureCloudInstance when connecting

## 0.1.0

*   Initial release
*   Commands: `Connect-ODS`, `Disconnect-ODS`, `Get-OneDriveShortcut`, `New-OneDriveShortcut`, `Remove-OneDriveShortcut`
