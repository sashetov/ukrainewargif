#!/usr/bin/env python3
import csv
import sys
from urllib.request import urlopen
from bs4 import BeautifulSoup
import collections
collections.Callable = collections.abc.Callable


def get_table_html():
  """
  pulls
  /html/body/div[2]/div[1]/div[2]/div/div[5]/div[5]/table/tbody
  from
  https://en.wikipedia.org/w/index.php?title=File:2022_Russian_invasion_of_Ukraine.svg&offset=&limit=5000#filehistory
  and writes to file
  """
  table = []
  url = "https://en.wikipedia.org/w/index.php?title=File:2022_Russian_invasion_of_Ukraine.svg&offset=&limit=5000#filehistory"
  i = 1
  soup = BeautifulSoup(urlopen(url).read(), features="html.parser")
  return str(soup.html.body.findAll("table")[4])


def main():
  with open('uk', "w") as fd:
    fd.write(get_table_html())


if __name__ == "__main__":
  main()
