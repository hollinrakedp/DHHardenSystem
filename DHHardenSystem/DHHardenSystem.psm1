$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
$Mitigation = @( Get-ChildItem -Path $PSScriptRoot\Mitigations\*.ps1 -ErrorAction SilentlyContinue )

Foreach($script in @($Public + $Private + $Mitigation)) {
    Try
    {
        . $script.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($script.fullname): $_"
    }
}

$LGPOPath = "$PSScriptRoot\LGPO"
$EnvPath = $Env:Path -split ';'
if (!($EnvPath -contains "$LGPOPath")) {
    $Env:Path += ";$LGPOPath"
}

#region Tab Completion
$MitigationTabComplete = {Get-ChildItem -Path $(Join-Path "$($(Get-Module $($(Get-Command Invoke-HardenSystem).Source)).ModuleBase)" -ChildPath "Mitigations") -File | Select-Object -ExpandProperty BaseName}
Register-ArgumentCompleter -CommandName Invoke-HardenSystem -ParameterName Mitigation -ScriptBlock $MitigationTabComplete
Register-ArgumentCompleter -CommandName Export-HardenSystemConfig -ParameterName Mitigation -ScriptBlock $MitigationTabComplete
#endregion Tab Completion

Export-ModuleMember -Function $Public.Basename