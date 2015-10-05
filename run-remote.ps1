[CmdletBinding()]
Param (
    
     [Parameter(ParameterSetName="computerlist")]
     [Parameter(ParameterSetName="computerlist-script")]
     [ValidateNotNullOrEmpty()]
        [String]$computerlist,
    # [Parameter(ParameterSetName="leaselist")][Parameter(ParameterSetName="leaselist-script")][String]$leasefile,
     [Parameter(ParameterSetName="leaselist")]
     [Parameter(ParameterSetName="leaselist-script")]
     [ValidateNotNullOrEmpty()]
        [int]$school_id,
     [Parameter(ParameterSetName="single")]
     [Parameter(ParameterSetName="single-script")]
     [ValidateNotNullOrEmpty()]
        [String]$computer,
     [Parameter(ParameterSetName="single")]
     [Parameter(ParameterSetName="leaselist")]
     [Parameter(ParameterSetName="computerlist")]
     [ValidateNotNullOrEmpty()]
        [String]$remotecode,
     [Parameter(ParameterSetName="single-script")]
     [Parameter(ParameterSetName="leaselist-script")]
     [Parameter(ParameterSetName="computerlist-script")]
     [ValidateNotNullOrEmpty()]
        [String]$scriptname
     
) 

if($cred -eq $null)
{
    $cred = Get-Credential -Credential domain\user
}

if($computer)
{
    if($scriptname.Length -gt 0)
    {
        Invoke-Command -ComputerName $computer  -Credential $cred -Filepath $scriptname
    }
    elseif($remotecode.Length -gt 0)
    {
        $scriptblock = [Scriptblock]::Create($remotecode)
        Invoke-Command -ComputerName $computer  -Credential $cred -ScriptBlock $scriptblock
    }
}
elseif($computerlist)
{
    $onlinefile = $computerlist
    $computers = Get-Content($onlinefile)
    if($scriptname.Length -gt 0)
    {
            
        Invoke-Command -ComputerName (cat $onlinefile)  -Credential $cred -Filepath $scriptname -ErrorAction SilentlyContinue
    }
    elseif($remotecode.Length -gt 0)
    {
        $scriptblock = [Scriptblock]::Create($remotecode) 
        Invoke-Command -ComputerName (cat $onlinefile)  -Credential $cred -ScriptBlock $scriptblock -ErrorAction SilentlyContinue
    }
    
}
#elseif($leasefile)
#{
#    $leases = Import-Csv -Path $leasefile 
#    $onlinefile = "C:\scripts\temp.txt"
#    Remove-Item -Path $onlinefile -Force -ErrorAction SilentlyContinue
#    foreach($lease in $leases)
#    {
#        $computer = $lease.Name
#    
#        if($connected = Test-Connection -ComputerName $computer -ErrorAction SilentlyContinue -Count 1 -BufferSize 16)
#        {
#            Write-Host "$computer ... Online"
#            Add-Content $onlinefile "$computer"
#        }
#        else
#        {
#            Write-Host "$computer ..."
#        }
#    }
#    Invoke-Command -ComputerName (cat $onlinefile)  -Credential $cred -FilePath $scriptname -ErrorAction SilentlyContinue
#}
elseif($school_id)
{
    $leasefile = "c:\scripts\lease.xml"
    Remove-Item -Path $leasefile -Force -ErrorAction SilentlyContinue
    switch($school_id)
    {
        1 { Export-DhcpServer -ComputerName 10.9.0.254 -file $leasefile -ScopeId 10.9.0.0 -Leases -Force }
        2 { Export-DhcpServer -ComputerName 10.2.0.254 -file $leasefile -ScopeId 10.2.0.0 -Leases -Force }
        3 { Export-DhcpServer -ComputerName 10.3.0.254 -file $leasefile -ScopeId 10.3.0.0 -Leases -Force }
        5 { Export-DhcpServer -ComputerName 10.5.0.254 -file $leasefile -ScopeId 10.5.0.0 -Leases -Force } 
        9 { Export-DhcpServer -ComputerName 10.9.0.254 -file $leasefile -ScopeId 10.9.0.0 -Leases -Force } 
        default {}
    }
    [xml]$leasesxml = Get-Content $leasefile
    $leases = $leasesxml.DHCPServer.IPv4.scopes.scope.Leases
    $onlinefile = "C:\scripts\temp.txt"
    Remove-Item -Path $onlinefile -Force -ErrorAction SilentlyContinue
    foreach($lease in $leases.Lease)
    {
        if($lease.HostName -ne $null)
        {
            $computer = $lease.HostName
            $ipv4 = $lease.IPAddress
        
            if($connected = Test-Connection -ComputerName $ipv4 -ErrorAction SilentlyContinue -Count 1 -BufferSize 16)
            {
                Write-Host "$computer ... Online"
                Add-Content $onlinefile "$computer"
            }
            else
            {
                Write-Host "$computer ..."
            }
        }
    }
    if($scriptname.Length -gt 0)
    {
        Invoke-Command -ComputerName (cat $onlinefile)  -Credential $cred -Filepath $scriptname -ErrorAction SilentlyContinue
    }
    elseif($remotecode.Length -gt 0)
    {
        $scriptblock = [Scriptblock]::Create($remotecode) 
        Invoke-Command -ComputerName (cat $onlinefile)  -Credential $cred -ScriptBlock $scriptblock -ErrorAction SilentlyContinue
    }
}

