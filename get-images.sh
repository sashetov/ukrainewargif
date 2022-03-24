#!/bin/bash
. venv/bin/activate
python3 scrape.py || {
  rm -f uk;
  exit 1;
}
echo "* got table HTML"
mkdir -p svg/t
cd svg
cat ../uk | grep 'invasion_of_Ukraine.svg' | sed -r 's/^.+href="\/\///g' | sed -r 's/svg.+/svg/g' | while read u; do
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
done;
echo "* downloaded all SVGs"
