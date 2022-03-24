#!/bin/bash
./get-images.sh
cd svg
let j=0;
for i in *.svg; do
  k=$(printf "%03d\n" $j);
  cp "$i" "t/invasion-$k.svg";
  let j++;
done;
cd t/
ffmpeg -f image2 -framerate 3 -i invasion-%03d.svg -loop -1 invasion.gif  > /dev/null 2>&1
mv invasion.gif ../../
cd ../../
rm -rf svg uk
