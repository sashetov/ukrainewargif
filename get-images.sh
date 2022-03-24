#!/bin/bash
. venv/bin/activate
python3 scrape.py
mkdir -p svg/t
cd svg
cat ../uk | grep 'invasion_of_Ukraine.svg' | sed -r 's/^.+href="\/\///g' | sed -r 's/svg.+/svg/g' | while read u; do wget "https://$u"; done;
