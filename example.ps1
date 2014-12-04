# License: (MIT), Copyright (C) 2014 win_usagewatch Author Phil Chen

#EXAMPLE 

$example = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. ($example + '.\win_usagewatch.ps1')

write-host "CPU USED" $loadclasscpu.cpuused"%"

write-host "MEMORY USED" $loadclassmem.memused"%"

write-host "DISK USED" $loadclassdisk.diskused

write-host "TCP CONNECTIONS" $loadclasstcp.tcpused

write-host "UDP CONNECTIONS" $loadclassudp.udpused

write-host "BANDWIDTH SENT / SEC" $loadclassbandout.bandout

write-host "BANDWIDTH REC / SEC" $loadclassbandin.bandin

write-host "DISK I/O" $loadclassdiskio.diskio

write-host "DISK READS / SEC" $loadclassdiskreads.diskreads

write-host "DISK WRITES / SEC" $loadclassdiskwrites.diskwrites
