#!/bin/bash
. venv/bin/activate
python3 scrape.py || {
  rm -f uk;
  exit 1;
}
printf "* got table HTML"
mkdir -p svg/t
cd svg
let i=0;
cat ../uk | grep 'invasion_of_Ukraine.svg' | sed -r 's/^.+href="\/\///g' | sed -r 's/svg.+/svg/g' | while read u; do
  if ! [ -f $(basename $u) ]; then
    curl --connect-timeout 5 \
      --max-time 10 \
      --retry 5 \
      --retry-delay 0 \
      --retry-max-time 40 \
      "https://$u" \
      -o $(basename $u) > /dev/null 2>&1 || {
      echo ERR: failed to download "https://$u";
      exit 2;
    };
    if [ $(( $i % 10 )) -eq 0 ]; then
      printf "\n";
    fi;
    printf '.';
    let i++;
  fi;
done;
printf "\n* downloaded all SVGs";
