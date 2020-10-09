# SADA Infra Challenges

See [https://gitlab.com/-/snippets/2011945](https://gitlab.com/-/snippets/2011945 "infra challenges | bob bae sada")

## Installation

This repository makes use of **submodules**, so if you check out the repo be sure to initialize submodules with `git submodule init` such as like this:

```
git clone https://github.com/postmastersteve/sada-infra-challenges.git && git submodule init
```

## [Challenge 2: Read file and create files and sort](https://gitlab.com/-/snippets/2011945#challenge-2-read-file-and-create-files-and-sort)

My bash script solution to this second challenge can be found as the [challenge-02/run.sh](../blob/main/challenge-02/run.sh) file. It has been tested in a bash shell on Ubuntu 18.04 LTS "Bionic Beaver" and macOS 10.14.6.

### Requirements

This script was written to make use of bash shell and relies on these commands:

- awk
- find
- grep
- ls
- md5
- mkdir
- perl
- rm
- sort

It also relies on a file located in the project at `data/loomings.txt` which can be placed manually, but is part of a git submodule originating from Bob Bae's gist on GitHub. See **Installation** above for initializing git submodules.

### Usage

From the command line, navigate into folder `challenge-02` and execute the `run.sh` script:

```
cd challenge-02
./run.sh
```

The script will present each challenge item with a heading and results as one output to the console.

### Outputs

This script makes a subfolder at `challenge-02/out` relative to the project location which contains the output files like `File-a` and `File-a.hash` and `loomings-clean.txt` per the challenge requirements. This folder is not a part of the repository and will only be created upon execution for review. This folder and its contents are deleted and recreated on each execution of the script.

## Troubleshooting

**The script creates a 'command not found' error.**
Make sure that you are not executing as `run.sh` - you must begin with `./` before the script name, such as this:

```
./run.sh
```

**The script will not execute - I'm seeing a permissions warning.**
Script should be executable within the project but if you're having trouble running one, try this command in the directory with the script:

```
chmod +x run.sh
```
