#!/usr/bin/awk -f

# Reports successful results of ping command
# Incoming format:

# PING 10.0.15.1 (10.0.15.1): 56 data bytes
# 
# --- 10.0.15.1 ping statistics ---
# 1 packets transmitted, 1 packets received, 0.0% packet loss
# round-trip min/avg/max/stddev = 1.936/1.936/1.936/0.000 ms
BEGIN{printf("%s...", ip)}
{if (index($0, "packets received")) received=$4}
END{
  if (received) {
    printf("\r%s responded\n", ip)
  }
  else {
    printf("\r")
  }
}