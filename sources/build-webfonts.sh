#!/bin/bash
. misc/init.sh

if [[ ! -d ../fonts/webfonts ]]; then
    mkdir ../fonts/webfonts
fi

for font in ../fonts/ttf/*; do
    FA=`basename "$font"`
    FN=${FA::-4}
    fonttools ttLib.woff2 compress "$font" --output-file "../fonts/webfonts/"$FN".woff2"
done

for font in ../fonts/variable/*; do
    FA=`basename "$font"`
    FN=${FA::-4}
    fonttools ttLib.woff2 compress "$font" --output-file "../fonts/webfonts/"$FN".woff2"
done
