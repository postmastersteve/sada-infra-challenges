#!/usr/bin/env bash
# Author: Steve Post <postmastersteve@gmail.com>
# Date: October 2020

clear;

source="./data/loomings.txt"
target="./data/loomings-clean.txt"
out_dir="./out"

printf "\n\n"
printf "\t\t┏━━━━━━━━━━━━━━━━  SADA CHALLENGE 02  ━━━━━━━━━━━━━━━━┓\n"
printf "\t\t┃                                                     ┃\n"
printf "\t\t┃ Read file and create files and sort.                ┃\n"
printf "\t\t┃                                                     ┃\n"
printf "\t\t┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛\n"
printf "\t\t  Submitted by Steve Post\n"
printf "\t\t  October 2020\n\n"


printf "\n\n\n\e[4m\e[33m\
1) Read each non-blank line of text from the file loomings.txt \
and the total number of non-blank lines.\e[m\e[m\n\n"
printf "File %s contains \033[1;36m%d\033[0m non-blank lines of content." \
  "$source" \
  "$(grep -c -e'\S' $source)"


printf "\n\n\n\e[4m\e[33m\
2) Create a file with a unique name containing each non-blank line \
of text read from the file.\e[m\e[m\n\n"
printf "Clean output directory..."
rm -Rf $out_dir && mkdir -p $out_dir && printf "done\n"
printf "Outputting files..."
grep -e'\S' $source | split -a1 -l1 - "$out_dir/File-" && printf "done"


printf "\n\n\n\e[4m\e[33m\
3) Create a companion file for each file. Each companion file will be \
a hash digest of the content of the file.\e[m\e[m\n\n"
printf "Set hashing command to: \n\e[35m"
if ! command -v md5 &> /dev/null; 
then 
  hash_cmd='md5sum "{}" | cut -f1 -d" "> "{}".hash'
else
  hash_cmd='md5 -q "{}" > "{}".hash'
fi
printf "  %s\e[m\n" "$hash_cmd"
printf "Hashing files..."
find $out_dir -type f ! -iname '*.hash' -execdir sh -c "$hash_cmd" \; && printf "done"


printf "\n\n\n\e[4m\e[33m\
4) List the files sorted based on the size of the file, in order, \
from smallest to largest based on the size (total bytes)\n\
of the content within the file. Print the name and size of each file on each line of the output.\e[m\e[m\n\n"
ls -Srl $out_dir | awk -f ./src/filesize_table.awk


printf "\n\n\n\e[4m\e[33m\
5) Print the name of the two files that have identical content. \
Print the original text line which is duplicated in loomings.txt.\e[m\e[m\n\n"
DUPES="$(for file in $out_dir/*.hash
do
  grep -Fr --exclude="$(basename $file)" $out_dir/*.hash --file=$file \
    | awk 'BEGIN{FS=".hash:"}{print $2,$1}'
done)";
printf "$DUPES" | sort -u | awk -f ./src/report_dupes.awk


printf "\n\n\e[4m\e[33m\
6a) Remove the duplicate (second occurance) line from loomings.txt and \
create a new version of the file and call it loomings-clean.txt.\e[m\e[m\n\n"
grep -e'\S' $source \
  | awk 'BEGIN{ORS="\n\n"}!u[$0]++' \
  > $target
perl -pi -e 'chomp if eof' $target
perl -pi -e 'chomp if eof' $target
printf "Deduped file exported to:\n  \e[1;35m%s\e[m" \
  "$target"


printf "\n\n\n\e[4m\e[33m\
6b) Perform diff loomings*txt and produce output.\e[m\e[m\n\n"
printf "\e[1;36m%s\e[m%s\e[m" \
  "$(diff --text ./data/loomings*.txt)"


printf "\n\n\nFinished!\nThanks for your consideration --Steve Post\n\n"
exit