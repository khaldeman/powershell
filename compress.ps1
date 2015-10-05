function CompressDir($directory)
{
    $directory_escaped = $directory.Replace("\", "\\");
    Write-Host "Compressing: " $directory_escaped
    $result = (Get-WmiObject -Class win32_directory -ComputerName .   -Filter "Name='$directory_escaped'").CompressEx("",$true)
  
}


$disk = Get-WmiObject win32_logicaldisk -Filter "deviceID='c:'"
$freespace = $disk.FreeSpace / 1024 / 1024 / 1024
Write-Host $env:COMPUTERNAME $freespace 
if($freespace -lt 20)
{
    Write-Host $env:COMPUTERNAME "Compressing" 
    CompressDir -directory "c:\Skoolbo Common Core"
    CompressDir -directory "c:\windows\installer"

    $disk = Get-WmiObject win32_logicaldisk -Filter "deviceID='c:'"
    $freespace = $disk.FreeSpace / 1024 / 1024
    Write-Host $env:COMPUTERNAME $freespace "M"
}
