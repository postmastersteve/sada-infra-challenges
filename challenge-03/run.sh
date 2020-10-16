#!/usr/bin/env bash
# Author: Steve Post <postmastersteve@gmail.com>
# Date: October 2020

clear;

printf "\n\n"
printf "\t\t┏━━━━━━━━━━━━━━━━  SADA CHALLENGE 01  ━━━━━━━━━━━━━━━━┓\n"
printf "\t\t┃                                                     ┃\n"
printf "\t\t┃ Check IP of devices connected in a network          ┃\n"
printf "\t\t┃                                                     ┃\n"
printf "\t\t┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛\n"
printf "\t\t  Submitted by Steve Post\n"
printf "\t\t  October 2020\n\n"

# required=(
#   "sysctl"
#   "ping"
# )
# install_cmd=(
#   "apt-get install net-tools"
#   "apt-get install iputils-ping"
# )
# for (( i=0; i<${#required[@]}; i++ ))
# do
#   if ! command -v ${required[$i]} &> /dev/null; 
#   then 
#     printf "\e[31mError:\e[m Required command \e[1m${required[$i]}\e[m not found.\n\
#   Try installing it with \e[90m\e[1m${install_cmd[$i]}\e[0m and run this script again.\n"
#     exit 1
#   fi
# done

# Get the operating system name
uname=$(uname -s)

printf "\n\n\n\e[4m\e[33m\
1) Create a JSON data structure containing the information from your system.\e[m\e[m\n\n"
SYS_JSON_FORMAT='[
  {
    "CPUs": [
      {
        "Description": "%s",
        "NumberOfCores": %d
        }
    ],
    "Memory": [
      {
        "InstalledGB": %d,
        "AvailableGB": %d
      }
    ],
    "Storage": [
      %s
    ],
    "Network": [
      %s
    ]
  }
]\n'
DISK_JSON_FORMAT='{
        "Description":"%s",
        "CapacityGB":%d,
        "AvailableGB":%d,
        "Type":"%s"
      },'
NETWORK_JSON_FORMAT='{
        "Description":"%s",
        "IP":"%s",
        "Netmask":"%s"
      },'

case $uname in
  "Darwin")
    CPU_DESC=$(sysctl -n machdep.cpu.brand_string)
    CPU_CORES=$(sysctl -n hw.physicalcpu)
    MEM_INSTALLED=$[$(sysctl -n hw.memsize)/1073741824] # divide by 1GiB
    MEM_AVAILABLE=$[$MEM_INSTALLED - $(top -l 1 \
      | grep "PhysMem:" \
      | awk '{print $2}' \
      | cut -f1 -d'G')]
    STORAGE=$(system_profiler SPStorageDataType \
        | awk -f ./src/disk-info-parse-mac.awk)
    NETWORK=$(system_profiler SPNetworkDataType \
        | awk -f ./src/network-info-parse-mac.awk)
    ;;
  "Linux")
    CPU_DESC=$(awk -F':' '/^model name/ {print $2}' /proc/cpuinfo \
      | uniq \
      | sed -e 's/^[ \t]*//')
    CPU_CORES=$(awk -F':' '/^cpu cores/ {print $2}' /proc/cpuinfo \
      | uniq \
      | sed -e 's/^[ \t]*//')
    MEM_INSTALLED=$[$(grep MemTotal: /proc/meminfo | awk '{print $2+0}')/1048576]
    MEM_AVAILABLE=$[$(grep MemFree: /proc/meminfo | awk '{print $2+0}')/1048576]
    # STORAGE=$(lsblk -n --output NAME,MODEL,SIZE,TYPE \
    #   | grep disk \
    #   | awk -f ./src/disk-info-parse-linux.awk)
    # NETWORK=$(system_profiler SPNetworkDataType \
    #     | awk -f ./src/network-info-parse-mac.awk)
    ;;
  *)
    exit 1
    ;;
esac

# OUTPUT JSON:
printf "$SYS_JSON_FORMAT\n" \
  "$CPU_DESC" \
  "$CPU_CORES" \
  "$MEM_INSTALLED" \
  "$MEM_AVAILABLE" \
  "${STORAGE}" \
  "${NETWORK}"

echo "Finished."

exit
