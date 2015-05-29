#!/bin/bash

echo 'What word do you want to search for?'

# Read in the word
read WORD

# Look for the word in the file and count how many times it occurs
for i in $( ls *.txt); do
  echo $i Counts for the word \'$WORD\':
  grep $WORD $i | wc -l

done