# Makefile to compile Dina Betser's MEng Thesis, 2012.
# Based off work done by Monia Ghobadi and Malte Schwarzkopf
# on Google Docs-to-Latex academic paper downloading scripts.
# NB: By default, this fetches the thesis parts from Google docs every time.
# Use "make recompile" to avoid the extra fetch.


NAME=main


# List of Google doc URLs for the mutable portions of the thesis.
main_tex_URL='https://docs.google.com/document/d/##YOUR_HASH_HERE##/export?format=txt'
contents_tex_URL='https://docs.google.com/document/d/##YOUR_HASH_HERE##/export?format=txt'
cover_tex_URL='https://docs.google.com/document/d/##YOUR_HASH_HERE##/export?format=txt'
appa_tex_URL='https://docs.google.com/document/d/##YOUR_HASH_HERE##/export?format=txt'
appb_tex_URL='https://docs.google.com/document/d/##YOUR_HASH_HERE##/export?format=txt'
abstract_tex_URL='https://docs.google.com/document/d/##YOUR_HASH_HERE##/export?format=txt'
chap1_tex_URL='https://docs.google.com/document/d/##YOUR_HASH_HERE##/export?format=txt'
# For additional chapters, add the URL for the document here, and add the dependency upon it for the target $(NAME).tex.

BIB_NAME=main
BIB_URL='https://docs.google.com/document/d/##YOUR_HASH_HERE##/export?format=txt'


TARGET=$(NAME).pdf


# Location of the zip file that contains the immutable parts of the thesis (such as .sty files, etc.).
static_zip_URL='http://web.mit.edu/dbetser/Public/1122/static/static.zip'


LATEX=pdflatex


.SUFFIXES:
.SUFFIXES: .stamp .tex .pdf


top: all


recompile: $(TARGET)


all: trigger static $(TARGET)


clean:
	rm -f *.aux $(NAME).bbl $(NAME).blg $(NAME).log $(NAME).pdf $(NAME).tmp *.trig $(NAME).dvi $(NAME).ps
	rm -f *.tex  # CAUTION remove if source is moved from Google docs
	rm -f $(BIB_NAME).bib  # CAUTION remove if source is moved from Google docs


trigger $(NAME).trig:
	touch $(NAME).trig


# This fetches the shared main tex doc from Google docs.
$(NAME).tex: $(NAME).trig static.trig contents.tex abstract.tex appa.tex appb.tex biblio.tex cover.tex chap1.tex
	wget -O$(NAME).tmp $(main_tex_URL) --no-check-certificate
	iconv -c -t ASCII//TRANSLIT $(NAME).tmp | sed -e 's/\[[a-z]*]//g' -e '/end{document}/q' > $(NAME).tex


# Fetch the bibliography from Google docs.
$(BIB_NAME).bib:
	wget -O$(BIB_NAME).tmp $(BIB_URL) --no-check-certificate
	iconv -c -t ASCII//TRANSLIT $(BIB_NAME).tmp | sed -e 's/\[[a-z]*]//g' -e '/end{document}/q' > $(BIB_NAME).bib


# Fetch the other shared required latex files from Google Docs.
%.tex:
	wget -O$@.tmp $($(subst .,_,$@)_URL) --no-check-certificate
	iconv -c -t ASCII//TRANSLIT $@.tmp | sed -e 's/\[[a-z]*]//g' -e '/end{document}/q' > $@
	rm $@.tmp


# bibtex approximation (may cause an extra latex run)
$(NAME).bbl: $(BIB_NAME).bib
	$(LATEX) $(NAME)
	bibtex $(NAME)


# This forces an extra latex and bibtex run every time.
$(NAME).bbl: $(NAME).tex


# Iterate on latex until cross references don't change.
%.pdf: %.tex %.bbl
	while ($(LATEX) $(NAME); grep -q "Rerun to get cross" $(NAME).log) do echo "### rerun"; done
	@echo "bibtex warnings:"
	fgrep -i warning $(NAME).blg
	@echo "latex warnings:"
	fgrep -i warning $(NAME).log


spell: $(NAME).tex
	cat $(NAME).tex | aspell list | sort -u | aspell -a


# Download the static files.
static static.trig:
	wget -Ostatic.zip $(static_zip_URL)
	unzip -o static.zip  # Overwrite existing files.
	touch static.trig


#end makefile, do not remove or change this line, it is used by build_thesis.sh
