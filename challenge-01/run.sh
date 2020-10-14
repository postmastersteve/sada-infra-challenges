#!/usr/bin/env bash
# Author: Steve Post <postmastersteve@gmail.com>
# Date: October 2020

# Helper routines for IP addresses
. ./src/ip-helpers.sh

clear;

printf "\n\n"
printf "\t\t┏━━━━━━━━━━━━━━━━  SADA CHALLENGE 01  ━━━━━━━━━━━━━━━━┓\n"
printf "\t\t┃                                                     ┃\n"
printf "\t\t┃ Check IP of devices connected in a network          ┃\n"
printf "\t\t┃                                                     ┃\n"
printf "\t\t┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛\n"
printf "\t\t  Submitted by Steve Post\n"
printf "\t\t  October 2020\n\n"

required=(
  "ifconfig"
  "ping"
)
install_cmd=(
  "apt-get install net-tools"
  "apt-get install iputils-ping"
)
for (( i=0; i<${#required[@]}; i++ ))
do
  if ! command -v ${required[$i]} &> /dev/null; 
  then 
    printf "\e[31mError:\e[m Required command \e[1m${required[$i]}\e[m not found.\n\
  Try installing it with \e[90m\e[1m${install_cmd[$i]}\e[0m and run this script again.\n"
    exit 1
  fi
done

printf "\n\n\n\e[4m\e[33m\
1) List information on all network devices on your machine. IP addresses, link-level addresses, \
network masks, etc. per network device on your machine.\e[m\e[m\n\n"
if_results=$(ifconfig)
echo "$if_results"
# echo "$if_results" > if_results

printf "\n\n\n\e[4m\e[33m\
2) Pick the currently active and attached network interface from the list.\e[m\e[m\n\n"
# Get all interface names
for if_name in $(ifconfig | grep -o -E '^(\w+)')
do
  res=$(ifconfig $if_name \
    | grep "inet " \
    | grep -Fv 127.0.0.1)
  if [ "$res" ];
  then
    active_if=$if_name
    this_ip=$(awk '{print $2}' <<< $res)
    subnet=$(awk '{print $4}' <<< $res)
    broadcast=$(awk '{print $6}' <<< $res)
  fi
done
echo $active_if


printf "\n\n\n\e[4m\e[33m\
3) Find the IP range that are possible on that LAN. e.g., 192.168.1.1 through 192.168.1.254.\e[m\e[m\n\n"
# this_ip=$(ip2int $(ifconfig $if_name | grep "inet " \
# | grep -Fv 127.0.0.1 \
# | awk '{print $2}') )
# subnet_mask=$(awk '{print $4}' <<< "$if_results")
# Check if ifconfig provided a hex subnet mask format:
if $(grep -q "0x" <<< "$subnet"); 
then
  # Convert hexidecimal subnet mask to dotted-decimal:
  subnet=$(int2ip $(printf "%d" $subnet) )
fi
this_ip_int=$(ip2int "$this_ip")
subnet_int=$(ip2int "$subnet")
start_ip_int=$[ $[ $this_ip_int & $subnet_int ] + 1 ]
broadcast_int=$(ip2int $broadcast)
printf "%s through %s\n" \
  $(int2ip $start_ip_int) \
  $(int2ip $[$broadcast_int - 1])


printf "\n\n\n\e[4m\e[33m\
4) Iterate through IP address range and ping each once and see if response was received successfully. \
Print out a list of IP addresses of the machines that responded on your local network.\e[m\e[m\n\n"
echo "These network devices responded to ping:"
for (( c=$start_ip_int; c<$broadcast_int; c=$[$c+10] ))
do
  # Ping each of the 5, up to the subnet:
  for (( i=0; i<10 && $[$c+$i]<$broadcast_int; i++ ))
  do
    ip=$(int2ip $[$c+$i])
    # This runs as a background process:
    ping -c1 -q -t1 $ip | awk -v ip="$ip" -f ./src/ping-success-ip.awk &
  done
  # Pause until all background ping processes 
  # receive a response or until they timeout
  wait
done
printf "Finished.\t\n"

exit
