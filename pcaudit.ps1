Function QuerySQL
{
    param (
        [string]$query = $(throw "-query is required")
    )
    $ServerInstance = "SQLSERVERINSTANCE"
    $Database = "useraudit"
    $ConnectionTimeout = 10
    $QueryTimeout = 5
    $conn = New-Object System.Data.SqlClient.SQLConnection
    $connString = "Server={0};Database={1};User ID=USERID;Password=PASSWORD;;Connect Timeout={2}" -f $ServerInstance,$Database,$ConnectionTimeout
    $conn.ConnectionString = $connString
    $conn.Open()
    $cmd = New-Object System.Data.SqlClient.SqlCommand($query,$conn)
    $cmd.CommandTimeout = $QueryTimeout
    $ds = New-Object System.Data.DataSet
    $da = New-Object System.Data.SqlClient.SqlDataAdapter($cmd)
    [void]$da.Fill($ds)
    $conn.Close()
    return $ds.Tables
}

$namespace = "root\cimv2"
$disk = Get-WmiObject -Namespace $namespace -Class "win32_diskdrive"
$cpu = Get-WmiObject -Namespace $namespace -Class "win32_processor"
$computersystem = Get-WmiObject -Namespace $namespace -Class "win32_computersystem"

$sysdrive = ""
if($disk.Count -gt 1)
{
    $partmax = 0;
    foreach($drive in $disk)
    {
        if($drive.Partitions -gt $partmax)
        {
            $partmax = $drive.Partitions
            $sysdrive = $drive
        }
    }

}
else
{
    $sysdrive = $disk
}

$query = "INSERT INTO [UserAudit].[dbo].[pc_audit]
           ([name]
           ,[mfg]
           ,[model]
           ,[memory]
           ,[disksize]
           ,[cpu])
     VALUES
           ('" + $computersystem.Name + "'
           ,'" + $computersystem.Manufacturer + "'
           ,'" + $computersystem.Model + "'
           ," + $computersystem.TotalPhysicalMemory + "
           ," + $sysdrive.Size + "
           ,'" + $cpu.Name + "' )"

#Write-Host $query
$deleteQuery = "DELETE FROM [UserAudit].[dbo].[pc_audit] where name = '" + $computersystem.Name + "'"
QuerySQL -query $deleteQuery
QuerySQL -query $query
