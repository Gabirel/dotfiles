$Params = @{
 "Daily" = $True
 "At"    = (Get-Date '8 PM').AddDays(1)
}
$Trigger = New-ScheduledTaskTrigger @Params

$Params = @{
 "Execute"  = "C:\Users\youzh\Documents\update-v2raydat.vbs"
 "WorkingDirectory" = "C:\Users\youzh\Documents\"
}
 
$Action = New-ScheduledTaskAction @Params

$Params = @{
 "ExecutionTimeLimit"         = (New-TimeSpan -Minutes 30)
 "AllowStartIfOnBatteries"    = $True
 "DontStopIfGoingOnBatteries" = $True
 "RestartCount"               = 2
 "RestartInterval"            = (New-TimeSpan -Minutes 5)
}
 
$Settings = New-ScheduledTaskSettingsSet @Params

$Params = @{
 "Action"    = $Action
 "Trigger"   = $Trigger
 "Setting"   = $Settings
}
 
$Task = New-ScheduledTask @Params
$Task | Register-ScheduledTask -TaskName 'update-v2raydat'