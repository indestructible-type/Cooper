#!/bin/bash
. misc/init.sh

echo ".
GENERATING UFO SOURCES
."
cp -r fontforge fontforge2
SOURCE_DIR=fontforge2
UFO_DIR=ufo
rm -rf $UFO_DIR
mkdir -p $UFO_DIR
sfds=$(ls $SOURCE_DIR/*.sfd)
for source in $sfds
do
	base=${source##*/}
	python3 -m sfdnormalize -k Copyright ./"$source" "$source"_out
	mv ./"$source"_out ./"$source"
	python3 -m sfdLib --ufo-kerning --ufo-anchors $source $UFO_DIR/${base%.*}.ufo
done

rm -r fontforge2
