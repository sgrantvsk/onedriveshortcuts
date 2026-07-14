function Connect-ODS {
    [CmdletBinding(DefaultParameterSetName = 'ClientSecret')]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'ClientSecret')]
        [Parameter(Mandatory = $true, ParameterSetName = 'ClientCertificate')]
        [guid] $TenantId,

        [Parameter(Mandatory = $true, ParameterSetName = 'ClientSecret')]
        [Parameter(Mandatory = $true, ParameterSetName = 'ClientCertificate')]
        [guid] $ClientId,

        [Parameter(Mandatory = $true, ParameterSetName = 'ClientSecret')]
        [securestring] $ClientSecret,

        [Parameter(Mandatory = $true, ParameterSetName = 'ClientCertificate')]
        [System.Security.Cryptography.X509Certificates.X509Certificate2] $ClientCertificate,

        [Parameter(Mandatory = $false, ParameterSetName = 'ClientSecret')]
        [Parameter(Mandatory = $false, ParameterSetName = 'ClientCertificate')]
        [ValidateSet('AzurePublic', 'AzureChina', 'AzureUsGovernment', 'AzureGermany')]
        [string] $AzureCloudInstance = 'AzurePublic'
    )

    begin {
        $Token = $null
    }

    process {
        switch ($PsCmdlet.ParameterSetName) {
            'ClientSecret' {
                try {
                    # PSMSALNet's -ClientSecret takes a plain string, not a SecureString,
                    # so we decrypt it in memory just before the call.
                    $PlainClientSecret = ConvertFrom-SecureString -SecureString $ClientSecret -AsPlainText

                    $Token = Get-EntraToken `
                        -ClientCredentialFlowWithSecret `
                        -ClientId $ClientId `
                        -TenantId $TenantId `
                        -ClientSecret $PlainClientSecret `
                        -AzureCloudInstance $AzureCloudInstance `
                        -Resource GraphAPI

                    $PsCmdlet.SessionState.PSVariable.Set('_ODSToken', $Token)
                } catch {
                    Write-Verbose $_
                    Write-Error "Token request using ClientSecret failed." -ErrorAction Stop
                } finally {
                    Remove-Variable -Name PlainClientSecret -ErrorAction SilentlyContinue
                }
            }
            'ClientCertificate' {
                try {
                    $Token = Get-EntraToken `
                        -ClientCredentialFlowWithCertificate `
                        -ClientId $ClientId `
                        -TenantId $TenantId `
                        -ClientCertificate $ClientCertificate `
                        -AzureCloudInstance $AzureCloudInstance `
                        -Resource GraphAPI

                    $PsCmdlet.SessionState.PSVariable.Set('_ODSToken', $Token)
                } catch {
                    Write-Verbose $_
                    Write-Error "Token request using ClientCertificate failed." -ErrorAction Stop
                }
            }
        }
    }

    end {
        if ($Token) {
            Write-Host "Connected!"
        }
    }
}
