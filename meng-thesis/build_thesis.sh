#!/bin/bash
# This script downloads the Makefile and runs it to generate the MEng Thesis PDF.

# Download Makefile
MAKEFILE_NAME=Makefile
MAKEFILE_URL='https://docs.google.com/document/d/12RkeHSbaqjDOeQyN1Tlz9FmYQa-t7R2RVskQ5FJjj-g/export?format=txt'

curl --insecure -O Makefile.wrongencoding $MAKEFILE_URL
wget -OMakefile.wrongencoding $MAKEFILE_URL --no-check-certificate
iconv -c -t ASCII//TRANSLIT Makefile.wrongencoding | sed -e 's/\[[a-z]*]//g' -e '#end makefile, do not remove or change this line, it is used by build_paper.sh/q' > Makefile.notabs

awk '{gsub("        ","\t");print}' Makefile.notabs > Makefile

if [ -e main.pdf ]; then
  rm main.pdf
fi

make clean all

OS=`uname`
if [ "$OS" == "Darwin" ]; then
  open main.pdf
fi

if [ -e main.pdf ]; then
  echo
  echo RESULT: main.pdf built successfully! If you are using OS X, it should have opened for you. You can open it yourself with the command: open main.pdf
fi