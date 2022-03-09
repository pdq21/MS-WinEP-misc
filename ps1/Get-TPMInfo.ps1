<#
    .SYNOPSIS
    Collect local TPM information.
    .NOTES
    Elevation needed.
#>
if(
    ([System.Security.Principal.WindowsPrincipal] `
    [System.Security.Principal.WindowsIdentity]::GetCurrent()). `
    IsInRole("Administrators") -ne $true
) {
    Write-Host "Attempted TPM-read without elevation. Exiting..." -f Red
}
else {
    $tpm = @{}
    $val = {
        try {
            Invoke-Expression $_.Value | ConvertTo-Json
        }
        catch {
            Write-Host $_.FullyQualifiedErrorId -f Red
        }
    }
    @{
        info = "Get-Tpm"
        feature = "Get-TpmSupportedFeature"
        endorKey = "Get-TpmEndorsementKeyInfo"
    }.GetEnumerator().foreach({
        $tpm.Add($_.Name, (&$val))   
    })
    $tpm
}