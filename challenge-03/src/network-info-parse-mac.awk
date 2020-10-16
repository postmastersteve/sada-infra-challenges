#!/usr/bin/awk -f

# Reports network info in JSON format

BEGIN{c=0}
NF {
  if($0 ~ /^    [a-zA-Z]/) {  # we're at the indentation level of the name
    c++;
    devices[c]=$1;
  }
  # Capture the first "Type" 
  if (desc[c]=="" && index($0,"Type:")) {
    desc[c]=$2;
  }
  if (index($0,"IPv4 Addresses:")) {
    ip4[c]=$3;
  }
  if (index($0,"Subnet Masks:")) {
    netmask[c]=$3;
  }  
}
END{
  for (i=1; i<=c; i++) {
    if(length(desc[i])>0 && length(ip4[i])>0 && length(netmask[i])>0) {
      printf("{");
      printf("\n        \"Description\": \"%s\",", desc[i]);
      printf("\n        \"IP\": \"%s\",", ip4[i]);
      printf("\n        \"Netmask\": \"%s\"", netmask[i]);
      printf("\n      }");
      if(i<c)
        print ","
    }
  }
}