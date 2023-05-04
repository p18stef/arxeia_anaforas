#!/bin/sh
#assemble and preprocess all the sources files
rm -rf html
mkdir html
 
pandoc text/pre.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to html > html/pre.html
pandoc text/intro.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to html > html/intro.html

for filename in text/ch*.txt; do
   [ -e "$filename" ] || continue
   pandoc --lua-filter=extras.lua "$filename" --to markdown | pandoc --lua-filter=extras.lua --to markdown | pandoc --lua-filter=epigraph.lua --to markdown | pandoc --lua-filter=arduinomemory.lua --to markdown | pandoc --lua-filter=figure.lua --to markdown | pandoc --lua-filter=footnote.lua --to markdown | pandoc --filter pandoc-fignos --to markdown | pandoc --metadata-file=meta.yml --top-level-division=chapter --citeproc --bibliography=bibliography/"$(basename "$filename" .txt).bib" --reference-location=section --wrap=none --to html > html/"$(basename "$filename" .txt).html"
done

pandoc text/epi.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to html > html/epi.html

for filename in text/apx*.txt; do
   [ -e "$filename" ] || continue
   pandoc --lua-filter=extras.lua "$filename" --to markdown | pandoc --lua-filter=extras.lua --to markdown | pandoc --lua-filter=epigraph.lua --to markdown | pandoc --lua-filter=figure.lua --to markdown | pandoc --filter pandoc-fignos --to markdown | pandoc --metadata-file=meta.yml --top-level-division=chapter --citeproc --bibliography=bibliography/"$(basename "$filename" .txt).bib" --reference-location=section --to html > html/"$(basename "$filename" .txt).html"
done


#sed -i '' 's+Figure+Εικόνα+g' ./latex/ch0*
pandoc -s html/*.html -o html/index.html --metadata title="My book"
pandoc -N --quiet --variable "geometry=margin=1.2in" --variable mainfont="MesloLGS NF" --variable sansfont="MesloLGS NF" --variable monofont="MesloLGS NF" --variable fontsize=12pt --variable version=2.0 book.tex --pdf-engine=xelatex --toc -o book.pdf

pandoc -o book.epub html/index.html --metadata title="My book"
mv book.epub book/book.epub
cp book.tex book/book.tex
mv book.pdf book/book.pdf
echo "#lang pollen" >> html/book.html.pmd
cat html/index.html >> html/book.html.pmd
raco pollen render html/index.html.pmd
rm -rf html/compiled
rm -rf html/book.html.pmd
