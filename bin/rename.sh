#!/bin/bash

# $Id: rename.sh 4 2010-10-24 17:30:25Z jollis $

for d in brkr  fgen  inst  krnl  mods  orms  pash  pmsh  push  secu
do
  cd ../src/${d}
  for r in *.m
  do
    sed -f ../../bin/rename.sed < ${r} > ${r}.new
  done
  cd -
done
