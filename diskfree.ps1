$free = get-WmiObject win32_logicaldisk | Where-Object -Property DeviceID -EQ -Value "C:" | Select-Object -Property FreeSpace
$free = [math]::Round($free.FreeSpace / 1024 / 1024 / 1024)
Write-Host  $env:COMPUTERNAME ": " $free "G"