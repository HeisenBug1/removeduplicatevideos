# Remove Duplicate Videos

Inspired by https://github.com/0x90d/videoduplicatefinder but needed something which will work in ARM architecture, but this will work in any linux as long as dependencies are met

Used ideas from https://openwritings.net/pg/linux/linux-find-duplicate-video

## How it works
It basically takes a screenshot of all the video files at 3 min 17 sec mark and compares them with eachother. If two screenshots match, then the corresponding video files are duplicate.

***Right now it does not remove the video files, but moves them to a directory called 'remove'. You can manually delete them from there.***

## Features
- Simple and works in a shell

## Drawbacks
- Kinda slow

## Dependencies 
- mpv
- findimagedupes

`sudo apt install mpv findimagedupes`

`sudo apt install ffmpeg` for good measure

## How To
*Note: it's a work in progress. Feel free to make improvements*

Put the script in any directory with video files you suspect has duplicates.
Then run `bash rmdupvid.sh` or `./rmdupvid.sh` if script is executable.
