#!/usr/bin/awk -f

# Create a filesize report

BEGIN {
    format_heading  ="┃ \033[1m%-13s\033[0m ┃ \033[1m%12s\033[0m ┃\n";
    format_rows     ="│ %-13s │ %6s Bytes │\n";
    print ("┏━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━┓")
    printf(format_heading, "File name", "Size");
    print ("┡━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━┩");
}
FNR > 1 { 
    printf(format_rows, $9, $5) 
}
END {
    print ("└───────────────┴──────────────┘")
}