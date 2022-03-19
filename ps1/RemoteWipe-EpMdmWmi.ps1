<#
    .SYNOPSIS
    Remote wipe EP with CIM/WMI MDM_RemoteWipe class
    .NOTES
    Elevation to SYSTEM needed. Use MDM, Sysinternals, Nirsoft or other tools and techniques.
    Comparison of PS1 to WMIC (params may need adjustment)
    WMIC /namespace:\\%namespaceName% PATH %className% WHERE %filter% CALL %methodName%
    Inspect namespace: WMIC /namespace:[\\]<namespace> path __namespace (abs or rel)
    .LINK
    https://docs.microsoft.com/en-us/windows/win32/dmwmibridgeprov/mdm-remotewipe
    https://docs.microsoft.com/en-us/windows/client-management/mdm/remotewipe-csp
#>
$param = @{
    namespaceName = "root\cimv2\mdm\dmmap"
    className = "MDM_RemoteWipe"
    methodName = "doWipeMethod"
    filter = "ParentID='./Vendor/MSFT' and InstanceID='RemoteWipe'"
    objParam = [Microsoft.Management.Infrastructure.CimMethodParameter]::Create(
        "param", "", "String", "In"
    )
}
try {
    $cim = @{
        session = New-CimSession
        obj = New-Object Microsoft.Management.Infrastructure.CimMethodParametersCollection
        instance = Get-CimInstance -Namespace $param.namespaceName `
            -ClassName $param.className -Filter $param.filter
    }
    $cim.obj.Add($param.objParam)
    $cim.session.InvokeMethod(
        $param.namespaceName, $cim.instance, $param.methodName, $param.objParam
    )
}
catch {
    Write-Host "$($_.FullyQualifiedErrorId) - $($_.Exception)" -f Red
}
