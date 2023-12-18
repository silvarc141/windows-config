# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
        Exit
    }
}

# ask for credentials
$Message = "Enter the username and password that will run the task"
$Credential = Get-Credential -Message $Message -UserName "$env:userdomain\$env:username"

function Register-ScheduledPSScriptTask {
    param(
        [string]$TaskName,
        $Trigger,
        [string]$ScriptPath,
        [pscredential]$Credential,
        [Microsoft.PowerShell.Cmdletization.GeneratedTypes.ScheduledTask.RunLevelEnum]$RunLevel = 'Limited'
    )

    if (Get-ScheduledTask -TaskName "$TaskName" -ErrorAction SilentlyContinue) {
        Unregister-ScheduledTask -TaskName "$TaskName" -Confirm:$false
        Write-Output "Removed already registered task named: $TaskName"
    }

    $params = @{
        TaskName = $TaskName
        Action   = (New-ScheduledTaskAction -Execute 'powershell' -Argument ('-NonInteractive -NoLogo -NoProfile -File "' + $ScriptPath + '"'))
        Trigger  = $Trigger
        RunLevel = $RunLevel
        Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RunOnlyIfNetworkAvailable -DontStopOnIdleEnd
    }

    if ( $PSBoundParameters.ContainsKey('Credential') ) {
        $params['User'] = $Credential.UserName
        $params['Password'] = $Credential.GetNetworkCredential().Password
    }

    Register-ScheduledTask @params > $null
    Write-Output "Added task named: $TaskName"
}

$paramsStartup = @{
    TaskName   = "CustomStartup"
    Trigger    = New-ScheduledTaskTrigger -AtLogOn
    ScriptPath = "$env:USERPROFILE\scripts\scheduled\startup.ps1"
    RunLevel   = 'Limited'
}

$paramsStartupElevated = @{
    TaskName   = "CustomStartupElevated"
    Trigger    = New-ScheduledTaskTrigger -AtLogOn
    ScriptPath = "$env:USERPROFILE\scripts\scheduled\startup-elevated.ps1"
    RunLevel   = 'Highest'
}

$paramsPolling = @{
    TaskName   = "CustomPolling"
    Trigger    = New-ScheduledTaskTrigger -Once -At (Get-Date).Date -RepetitionInterval (New-TimeSpan -Minutes 5)
    ScriptPath = "$env:USERPROFILE\scripts\scheduled\polling.ps1"
    Credential = $Credential
    RunLevel   = 'Highest'
}

Register-ScheduledPSScriptTask @paramsStartup
Register-ScheduledPSScriptTask @paramsStartupElevated
Register-ScheduledPSScriptTask @paramsPolling
