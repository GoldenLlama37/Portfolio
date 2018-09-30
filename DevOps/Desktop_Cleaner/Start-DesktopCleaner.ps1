start-process PowerShell.exe -arg "C:\Users\codyy\Desktop\Desktop Cleaner\removescript.ps1" -WindowStyle Hidden
$trigger = New-JobTrigger -AtStartup -RandomDelay 00:01:30
Register-ScheduledJob -Trigger $trigger -FilePath "C:\Users\codyy\Desktop\Desktop Cleaner\removescript.ps1" -Name DesktopCleaner