#!/bin/bash
function is_numeric() {
  CODE=$1;
  IS_NUMERIC=1
  if [[ -z $CODE ]]; then
    return 1;
  fi;
  NUM_CHARS_NON_NUMERIC=$( printf -- '%b' "${CODE}" | sed -r 's/^-?[0-9]+//g' | wc -c );
  [[ $NUM_CHARS_NON_NUMERIC -eq 0 && -n $NUM_CHARS_NON_NUMERIC ]]
  return $?
}
export VIDNAME
export FRAMERATE=10 # default
if [ $# -lt 1 ]; then
  echo "USAGE: $0 [VIDEO_OUTPUT.FMT] (FRAMERATE)"
  exit 1;
fi
VIDNAME=$1;
if [ $# -gt 1 ]; then
  is_numeric $2 || {
    echo "ERR: framerate must be a number";
    exit 1;
  }
  FRAMERATE=$2;
fi;
function cleanup(){
  rm -f uk;
}
./get-images.sh || {
  echo "ERR: downloading map svgs failed"
  cleanup
  exit 2;
}
cd svg/;
let j=0;
let l=0;
for i in *.svg; do
  k=$(printf "%03d\n" $j);
  F="t/invasion-$k.png"
  if ! [ -f "${F}" ]; then
    ffmpeg -i "$i" "${F}" > /dev/null 2>&1 || {
      echo "ERR: writing ${F} failed";
      rm -f $F;
      cd ../ && cleanup;
      exit 3;
    };
    if [ $(( $l % 10 )) -eq 0 ]; then
      printf "\n";
    fi;
    printf '.';
    let l++;
  fi;
  let j++;
done;
cd t/
printf "\n* finished converting svgs to pngs\n"
ffmpeg -framerate $FRAMERATE -i invasion-%03d.png -loop -1 $VIDNAME  > /dev/null 2>&1 || {
    echo "ERR: writing GIF failed";
    cd ../../ && cleanup;
    exit 3;
};
mv $VIDNAME ../../ && cd ../../ && cleanup;
echo "* finished writing gif to $VIDNAME"
