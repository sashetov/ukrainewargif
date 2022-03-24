#!/bin/bash
GIFNAME=invasion.gif
function cleanup(){
  rm -rf svg/t uk;
}
./get-images.sh || {
  echo "ERR: downloading map svgs failed"
  cleanup
  exit 2;
}
cd svg/;
let j=0;
for i in *.svg; do
  k=$(printf "%03d\n" $j);
  cp "$i" "t/invasion-$k.svg";
  let j++;
done;
cd t/
ffmpeg -f image2 -framerate 3 -i invasion-%03d.svg -loop -1 $GIFNAME  > /dev/null 2>&1 || {
    echo "ERR: writing GIF failed";
    cd ../../ && cleanup;
    exit 3;
};
mv $GIFNAME ../../ && cd ../../ && cleanup;
echo "* finished writing gif to $GIFNAME"
