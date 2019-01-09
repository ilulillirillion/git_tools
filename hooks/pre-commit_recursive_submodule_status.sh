#!/usr/bin/env bash


# Determine what to use for diffs by checking if this is the initial commit
#if git rev-parse --verify HEAD >/dev/null 2>&1;
#then
#  # Use current HEAD reference for diffs
#  against=HEAD
#else
#  # Initial commit: Use an empty tree object for diffs
#  against=4b825dc642cb6eb9a060e54bf8d69288fbee4904
#fi


# TODO: can this be moved to the top?
# Redirect all output to standard error
#exec 1>&2


git submodule foreach --recursive git status --porcelain=1
while read current_line;
do
  echo "current_line=$current_line";
  submodule_name=$(echo "$current_line" | awk '{ print $NF }' | sed s/\'//g);
  echo "submodule_name=$submodule_name";
  # Check if line is entering a new submodule
  if "$current_line" | grep '^Entering';
  then
    echo "Doing next submodule...";
    continue;
  # Check if line is showing a modified submodule
  elif "$current_line" | grep '^ M ';
  then
    echo "Modified submodule found: <$submodule_name>";
    echo "Refusing to commit with modified submodules!";
    exit 1;
  # Check if line is showing untracked files
  elif "$current_line" | grep '^?? ';
  then
    echo "Untracked files found in submodule <$submodule_name>";
    echo "Refusing to commit with untracked files in submodules!";
    exit 1;
  # Any other (unexpected) lines
  else
    echo "Unexpected line encountered in 'git status' output <$current_line>"
    echo "Refusing to commit with unexpected 'git status' output!"
    exit 1;
  fi
done || exit 1
exit 0





# TODO: remove this
#  submodule_name='unknown';
#  submodule_status='unknown';
#  echo "current_line=$current_line";
#  #if grep '^Entering' <<< "$current_line";
#  if echo "$current_line" | grep '^Entering';
#  then
#    $submodule_name=$(echo $current_line | 
#    awk '{ print $NF }' | 
#    sed s/\'//g
#  elif "$current_line" | grep 
