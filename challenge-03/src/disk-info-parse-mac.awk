#!/usr/bin/awk -f

# Reports disk info in JSON format

BEGIN{c=0}
NF {
  if($0 ~ /^    [a-zA-Z]/) {  # we're at the indentation level of the name
    c++;
    devices[c]=$1;
  }
  if (index($0,"Device Name:")) {
    split($0, name, "Device Name: ");
    desc[c]=name[2];
  }
  if (index($0,"Capacity:")) {
    capacity[c]=$2; 
  }
  if (index($0,"Available:")) {
    available[c]=$2
  }
  if (index($0,"Medium Type:")) {
    type[c]=$3;
  }
  
}
END{
  for (i=1; i<=c; i++) {
    if(length(desc[i])>0 && length(capacity[i])>0 && length(available[i])>0 && length(type[i])>0) {
      printf("{");
      printf("\n        \"Description\": \"%s\",", desc[i]);
      printf("\n        \"CapacityGB\": %d,", int(capacity[i]+0));
      printf("\n        \"AvailableGB\": %d,", int(available[i]+0));
      printf("\n        \"Type\": \"%s\"", type[i]);
      printf("\n      }");
      if(i<c)
        print ","
    }
  }
}