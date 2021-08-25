#!/bin/bash

Architecture=$(uname -a)
CPUPhysical=$(lscpu | grep -m 1 "Socket(s):" | grep -o '[0-9]*')
vCPU=$(lscpu | grep -m 1 "CPU(s):" | grep -o '[0-9]*')
FreeRAM=$(free -m | awk '$1 == "Mem:" {print $2}')
UsedRAM=$(free -m | awk '$1 == "Mem:" {print $3}')
PercentRAM=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')
DiskFree=$(df -Bg | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}')
DiskUsed=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}')
DiskPercent=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft+= $2} END {printf("%d"), ut/ft*100}')
CPULoad=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')
LastBoot=$(who -b | awk '$1 == "system" {print $3 " " $4}')
LVMT=$(lsblk | grep "lvm" | wc -l)
LVMUse=$(if [ $LVMT -eq 0 ]; then echo no; else echo yes; fi)
ConnTCP=$(ss -s | awk '$1 == "TCP" {print $2}')
UserLog=$(users | wc -w)
Network=$(hostname -I)
MAC=$(ip link show | awk '$1 == "link/ether" {print $2}')
Sudo=$(journalctl -q _COMM=sudo | grep COMMAND | wc -l)

wall    "\
        #Architecture: $Architecture
        #CPU physical: $CPUPhysical
        #vCPU: $vCPU
        #Memory Usage: $UsedRAM/${FreeRAM}MB ($PercentRAM%)
        #Disk Usage: $DiskUsed/${DiskFree}Gb ($DiskPercent%)
        #CPU load: $CPULoad
        #Last boot: $LastBoot
        #LVM use: $LVMUse
        #Connexions TCP : $ConnTCP ESTABLISHED
        #User log: $UserLog
        #Network: IP $Network($MAC)
        #Sudo : $Sudo cmd"