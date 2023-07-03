#!/bin/bash
. misc/init.sh
set -e
#source ../env/bin/activate

fontName="Cooper*"

##########################################

echo ".
CHECKING FOR SOURCE FILES
."
if [ -e ufo ]
then
    echo ".
USING EXISTING UFO SOURCE FILES
."
    UFO_SOURCES=true
else
    UFO_SOURCES=false
fi

##########################################

if [ $UFO_SOURCES = false ]; then
	source ./gen-sources.sh
fi

##########################################

echo ".
GENERATING OTF
."
TT_DIR=../fonts/otf
rm -rf $TT_DIR
mkdir -p $TT_DIR

fontmake -m designspace/$fontName.designspace -i -o otf --output-dir $TT_DIR

##########################################

echo ".
POST-PROCESSING OTF
."
otfs=$(ls $TT_DIR/*.otf)
for font in $otfs
do
	gftools fix-hinting $font
	[ -f $font.fix ] && mv $font.fix $font
done


##########################################

rm -rf instance_ufo/ master_ufo/

find . | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf

echo ".
COMPLETE!
."
