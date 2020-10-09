#!/usr/bin/awk -f

# Reports matching file sets and prints their content

BEGIN{
  set_count=0
}
!unique_hashes[$1]++{  # Runs for each unique hash encountered
  # Print the content from the previously found duplicate set
  if (set_count>0) {
    print_content(set_count)
    printf("\n───────────────────────────\n\n")
  }
  # Now begin a new set of files
  # Increase the set counter
  set_count++
  # Store the first file path for the set
  file_path=$2
  printf("Set #%d of files with duplicate lines of text:\n", set_count)
}
{
  printf("  \033[1;32m%s\033[m\n", $2)
} 
END{
  # Print out the content from the final duplicate set
  print_content(set_count)
}

function print_content(set_c) {
  "cat " file_path | getline content
  close("cat " file_path)
  if (length(content))
    printf( \
      "Content inside all files from set #%d:\n\033[1;32m%s\033[0m\n",
      set_c,
      content)
}