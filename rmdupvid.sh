#!/bin/bash

# Generate image
# ------------------------------------------------------------------------------------------
SAVEIFS=$IFS 	# save IFS
IFS=$'\n'	# change IFS to new line

# ary=( $(find -maxdepth 1 -type f -exec file -N -i -- {} + | sed -n 's!: video/[^:]*$!!p') )

# for vid in "${ary[@]}"
# do
# 	newFile=$(echo "$vid" | rev | cut -f 2- -d '.' | rev)
# 	mpv $vid --no-audio --vo=image --start=00:03:17 --frames=1 --o=${newFile}.jpg
# done


# Get list of duplicate images
# ------------------------------------------------------------------------------------------
# findimagedupes *.jpg > dup.txt

# format dup.txt to add new lines for each file
text=$(cat dup.txt)
files=$(echo $text | sed 's+/++')	# remove the first occurance of '/'
files=$(echo $files | sed 's+ /+\n+g')	# then remove the rest and make new lines for each file
files=($files)	# convert newline string to array

IFS=$SAVEIFS	# restore original IFS

for (( c=0; c<${#files[@]}; c=c+2 ))
do
	echo ${files[$c+1]}
done