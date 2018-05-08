#!/bin/bash

# usage: pattr.sh path-to-corpus src-lang tgt-lang
#
# Extracts parallel files divided into in- and out-of-domain data
# in the directory where the script is run.
#
# Curently supported languages are en de (English-German) and fr en (French-English)
#
# Files created:
#
# .tsv parallel files for sections abstract, claims and title

path=$1
if [ ! -d "$path" ] ; then
  echo "Directory not exists" 1>&2	
  echo "Usage: pattr.sh path-to-corpus language-pair" 1>&2
  exit 1
fi

src=$2
tgt=$3
pair=$src-$tgt
if  [ "$pair" != "en-fr" ] && [ "$pair" != "de-en" ] ; then
  echo "Set languages to \"en\" \"de\" or \"fr\" \"en\"" 1>&2	
  echo "Usage: pattr.sh path-to-corpus language-pair" 1>&2
  exit 1
fi

# produces .tsv files of in/out-domain text for sections
# abstract, claims and title
for section in abstract claims title ; do
  paste $path/$section/pattr.$pair.$section.$tgt \
    $path/$section/pattr.$pair.$section.$src \
    $path/$section/pattr.$pair.$section.meta \
    | egrep '(A61|C12N|C12P)[^   ]*$' \
    | cut -f1,2 > pattr-medical.$section.$pair.tsv

  paste $path/$section/pattr.$pair.$section.$tgt \
    $path/$section/pattr.$pair.$section.$src \
    $path/$section/pattr.$pair.$section.meta \
    | egrep -v '(A61|C12N|C12P)[^   ]*$' \
    | cut -f1,2 > pattr-other.$section.$pair.tsv
done
