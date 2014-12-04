# License: (MIT), Copyright (C) 2014 win_usagewatch Author Phil Chen


$loadclasscpu = New-Object -TypeName PSobject

$cpu = (gwmi -class Win32_Processor).LoadPercentage

	Add-Member -InputObject $loadclasscpu -MemberType NoteProperty -Name cpuused -Value $cpu

	#Example Call
	#$loadclasscpu.cpuused

$loadclassmem = New-Object -TypeName PSobject

$mem = (Get-WmiObject win32_operatingsystem -ComputerName localhost | Foreach {"{0:N2}" -f ((($_.TotalVisibleMemorySize - $_.FreePhysicalMemory)*100)/ $_.TotalVisibleMemorySize)})
$mem_whole = [System.Math]::Round($mem)

	Add-Member -InputObject $loadclassmem -MemberType NoteProperty -Name memused -Value $mem_whole

	#Example Call
	#$loadclassmem.memused


$loadclassdisk = New-Object -TypeName PSobject

$disk = Get-WmiObject Win32_LogicalDisk -ComputerName localhost -Filter "DeviceID='C:'" | Select-Object Size,FreeSpace
$disk_used = (($disk.Size - $disk.FreeSpace) / 1024 / 1024 / 1024)
$disk_used_whole = "{0:N2}" -f $disk_used

	Add-Member -InputObject $loadclassdisk -MemberType NoteProperty -Name diskused -Value $disk_used_whole

	#Example Call
	#$loadclassdisk.diskused


$loadclasstcp = New-Object -TypeName PSobject

$TcpCount = Invoke-Command -ScriptBlock {(netstat -an | ? {($_ -match '^  TCP')}).Count}

	Add-Member -InputObject $loadclasstcp -MemberType NoteProperty -Name tcpused -Value $TcpCount

	#Example Call
	#$loadclasstcp.tcpused


$loadclassudp = New-Object -TypeName PSobject

$UdpCount = Invoke-Command -ScriptBlock {(netstat -an | ? {($_ -match '^  UDP')}).Count}

	Add-Member -InputObject $loadclassudp -MemberType NoteProperty -Name udpused -Value $UdpCount

	#Example Call
	#$loadclassudp.udpused

$loadclassbandout = New-Object -TypeName PSobject

$net = Get-WmiObject -class Win32_PerfFormattedData_Tcpip_NetworkInterface

$sent = $net | select BytesSentPersec | measure-object BytesSentPersec -sum
$sent_whole = "{0:N2}" -f ($sent.sum / 1024)

	Add-Member -InputObject $loadclassbandout -MemberType NoteProperty -Name bandout -Value $sent_whole

	#Example Call
	#$loadclassbandout.bandout

$loadclassbandin = New-Object -TypeName PSobject

$rec = $net | select BytesReceivedPersec | measure-object BytesReceivedPersec -sum
$rec_whole = "{0:N2}" -f ($rec.sum / 1024)

	Add-Member -InputObject $loadclassbandin -MemberType NoteProperty -Name bandin -Value $rec_whole

	#Example Call
	#$loadclassbandin.bandin


$loadclassdiskio = New-Object -TypeName PSobject
$loadclassdiskreads = New-Object -TypeName PSobject
$loadclassdiskwrites = New-Object -TypeName PSobject

$Disk1 = Get-WmiObject -class Win32_PerfRawData_PerfDisk_LogicalDisk `
	-filter "name= '_Total' "
		Start-Sleep -s 2
$Disk2 = Get-WmiObject -class Win32_PerfRawData_PerfDisk_LogicalDisk `
	-filter "name= '_Total' "

$DiskTransfer1 = $Disk1.DiskTransfersPersec;

$DiskTransfer2 = $Disk2.DiskTransfersPersec;

$disktransfers = ($DiskTransfer2 - $DiskTransfer1)

$DiskReads1 = $Disk1.DiskReadsPersec;
$DiskReads2 = $Disk2.DiskReadsPersec;

$diskreads = ($DiskReads2 - $DiskReads1)

$DiskWrites1 = $Disk1.DiskWritesPersec;
$DiskWrites2 = $Disk2.DiskWritesPersec;

$diskwrites = ($DiskWrites2 - $DiskWrites1)

$diskio = ($diskwrites + $diskreads)

	Add-Member -InputObject $loadclassdiskio -MemberType NoteProperty -Name disktransfers -Value $diskio

	#Example Call
	#$loadclassdiskio.diskio

	Add-Member -InputObject $loadclassdiskreads -MemberType NoteProperty -Name diskreads -Value $diskreads

	#Example Call
	#$loadclassdiskreads.diskreads

	Add-Member -InputObject $loadclassdiskwrites -MemberType NoteProperty -Name diskwrites -Value $diskwrites

	#Example Call
	#$loadclassdiskwrites.diskwrites
