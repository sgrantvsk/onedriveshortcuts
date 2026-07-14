#Requires -Version 7.4
#Requires -Modules PSMSALNet
$Public = @(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath "\public\*.ps1") -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath "\private\*.ps1") -ErrorAction SilentlyContinue)

foreach ($Import in @($Public + $Private)) {
    try {
        Write-Verbose "Importing file: $($Import.FullName)"
        . $Import.FullName
    } catch {
        Write-Error -Message "Failed to import function $($Import.FullName): $_" -ErrorAction Stop
    }
}

foreach ($File in $Public) {
    Export-ModuleMember -Function $File.BaseName
}
