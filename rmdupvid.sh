#!/bin/bash

# # helper function
find_match () {
	for vid in "${ary[@]}"
	do
		matchFile=$(echo "$vid" | rev | cut -f 2- -d '.' | rev)	# remove ext
		matchFile=$(echo $matchFile | sed 's+.++')	# remove first .
		matchFile=$(pwd)$matchFile	# append current path in front (to match with delFile)

		if [[ "$1" == "$matchFile" ]]; then
			matchFile=$(echo "$vid" | sed 's+.++')
			function_return=$(pwd)"$matchFile"
			return 0
		fi
	done
}
# ------------------------------------------------------------------------------------------

# Optional ramdisk location
ramdisk=""

# Generate image
SAVEIFS=$IFS 	# save IFS
IFS=$'\n'	# change IFS to new line
function_return=''

ary=( $(find -maxdepth 1 -type f -exec file -N -i -- {} + | sed -n 's!: video/[^:]*$!!p') )

for vid in "${ary[@]}"
do
	newFile=$(echo "$vid" | rev | cut -f 2- -d '.' | rev)
	if [ -z "${ramdisk}" ]; then
		mpv $vid --no-audio --vo=image --start=00:03:17 --frames=1 --o=${newFile}.jpg
	else
		mpv $vid --no-audio --vo=image --start=00:03:17 --frames=1 --o=${ramdisk}${newFile}.jpg
	fi
done


# Get list of duplicate images
Dup_img_list=$(findimagedupes *.jpg)

# format text to add new lines for each file location in list:
Dup_img_list=$(echo $Dup_img_list | sed 's+/++')	# remove the first occurance of '/'
Dup_img_list=$(echo $Dup_img_list | sed 's+ /+\n+g')	# then remove the rest and make new lines for each file
Dup_img_list=($Dup_img_list)	# convert newline string to array

mkdir remove

for (( c=0; c<${#Dup_img_list[@]}; c=c+2 ))
do
	delFile1=$(echo "/${Dup_img_list[$c]}" | rev | cut -f 2- -d '.' | rev)
	delFile2=$(echo "/${Dup_img_list[$c+1]}" | rev | cut -f 2- -d '.' | rev)

	find_match "$delFile1"
	matchFile1="$function_return"
	
	find_match "$delFile2"
	matchFile2="$function_return"

	# find original video (older)
	if [ matchFile1 -ot matchFile2 ]
	then
		delFile=$matchFile1
	else
		delFile=$matchFile2
	fi

	# move dup file to remove/
	mv -v "$delFile" remove/

	# remove the image files no longer needed
	rm ${delFile1}.jpg
	rm ${delFile2}.jpg
done

IFS=$SAVEIFS	# restore original IFS