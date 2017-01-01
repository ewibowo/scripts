#!/bin/bash

# Check params
if [ $# -le 1 ]
then
  echo -e "\nUsage:\n INPUT OUTPUT -- program to prettify a directory of json into a specified output directory"
  exit 1
fi

# Create output directory
mkdir -p "$2"

# Iterate input directory
for f in $1/*
do
  # Prettify using Python
  PRETTY=$(python -m json.tool "$f")

  # File basename
  FILENAME=$(basename "$f")

  # Write prettified json to output directory with new name
  echo "$PRETTY" >> "$2/$FILENAME"
done
