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

# Ask for credentials
$Message = "Enter the username and password that will run the task"
$Credential = Get-Credential -Message $Message -UserName "$env:userdomain\$env:username"

$scheduledScriptsPath = "$env:USERPROFILE\.config\scripts-scheduled"

$paramsStartup = @{
    TaskName   = "CustomStartup"
    Trigger    = New-ScheduledTaskTrigger -AtLogOn
    ScriptPath = "$scheduledScriptsPath\startup.ps1"
    RunLevel   = 'Limited'
}

$paramsStartupElevated = @{
    TaskName   = "CustomStartupElevated"
    Trigger    = New-ScheduledTaskTrigger -AtLogOn
    ScriptPath = "$scheduledScriptsPath\startup-elevated.ps1"
    RunLevel   = 'Highest'
}

$paramsPolling = @{
    TaskName   = "CustomPolling"
    Trigger    = New-ScheduledTaskTrigger -Once -At (Get-Date).Date -RepetitionInterval (New-TimeSpan -Minutes 5)
    ScriptPath = "$scheduledScriptsPath\polling.ps1"
    Credential = $Credential
    RunLevel   = 'Highest'
}

Register-ScheduledPSScriptTask @paramsStartup
Register-ScheduledPSScriptTask @paramsStartupElevated
Register-ScheduledPSScriptTask @paramsPolling