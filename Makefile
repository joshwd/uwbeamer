SUBMAKES_REQUIRED=logo/uw theme/uw
SUBMAKES_EXTRA=guide/uw example/uw
SUBMAKES_TEST=test/uw
SUBMAKES=$(SUBMAKES_REQUIRED) $(SUBMAKES_EXTRA) $(SUBMAKES_TEST)
.PHONY: all base complete docs clean dist dist-implode implode \
	install install-base install-docs uninstall tests $(SUBMAKES)

BASETHEMEFILE=beamerthemeuwbeamer.sty
OTHERTHEMEFILES=theme/uw/*.sty
THEMEFILES=$(BASETHEMEFILE) $(OTHERTHEMEFILES)
LOGOSOURCES=logo/uw/*.pdf
LOGOS=logo/uw/*.eps
DTXFILES=*.dtx theme/uw/*.dtx
INSFILES=*.ins theme/uw/*.ins
TESTS=test/uw/*.pdf
MAKES=guide/uw/Makefile theme/uw/Makefile logo/uw/Makefile Makefile \
	test/uw/Makefile
USEREXAMPLE_SOURCES=example/uw/Makefile example/uw/example.dtx \
	example/uw/*.ins
USEREXAMPLES=example/uw/econ-lualatex.pdf \
	example/uw/econ-pdflatex.pdf example/uw/fi-lualatex.pdf \
	example/uw/fi-pdflatex.pdf example/uw/fsps-lualatex.pdf \
	example/uw/fsps-pdflatex.pdf example/uw/fss-lualatex.pdf \
	example/uw/fss-pdflatex.pdf example/uw/law-lualatex.pdf \
	example/uw/law-pdflatex.pdf example/uw/med-lualatex.pdf \
	example/uw/med-pdflatex.pdf example/uw/ped-lualatex.pdf \
	example/uw/ped-pdflatex.pdf example/uw/phil-lualatex.pdf \
	example/uw/phil-pdflatex.pdf example/uw/sci-lualatex.pdf \
	example/uw/sci-pdflatex.pdf
DEVEXAMPLES=logo/DESCRIPTION logo/EXAMPLE/DESCRIPTION \
	logo/uw/DESCRIPTION theme/EXAMPLE/DESCRIPTION \
	theme/uw/DESCRIPTION theme/DESCRIPTION example/DESCRIPTION \
	example/EXAMPLE/DESCRIPTION example/uw/DESCRIPTION \
	example/uw/resources/DESCRIPTION guide/DESCRIPTION \
	guide/EXAMPLE/DESCRIPTION guide/uw/DESCRIPTION \
	guide/uw/resources/DESCRIPTION test/DESCRIPTION \
	test/EXAMPLE/DESCRIPTION test/uw/DESCRIPTION
EXAMPLES=$(USEREXAMPLES) $(DEVEXAMPLES)
MISCELLANEOUS=guide/uw/guide.bib \
	guide/uw/guide.dtx guide/uw/*.ins guide/uw/resources/cog.pdf \
  guide/uw/resources/vader.pdf guide/uw/resources/yoda.pdf \
	$(USEREXAMPLES:.pdf=.tex) \
	example/uw/resources/jabberwocky-dark.pdf \
	example/uw/resources/jabberwocky-light.pdf README.md
RESOURCES=$(THEMEFILES) $(LOGOS) $(LOGOSOURCES)
SOURCES=$(DTXFILES) $(INSFILES) LICENSE.tex
AUXFILES=uwbeamer.aux uwbeamer.log uwbeamer.toc uwbeamer.ind \
	uwbeamer.idx uwbeamer.out uwbeamer.ilg uwbeamer.gls \
	uwbeamer.glo uwbeamer.hd
MANUAL=uwbeamer.pdf
PDFSOURCES=uwbeamer.dtx
GUIDES=guide/uw/econ.pdf guide/uw/fi.pdf guide/uw/fsps.pdf \
	guide/uw/fss.pdf guide/uw/law.pdf guide/uw/med.pdf \
	guide/uw/ped.pdf guide/uw/phil.pdf guide/uw/sci.pdf
PDFS=$(MANUAL) $(GUIDES) $(USEREXAMPLES)
DOCS=$(MANUAL) $(GUIDES)
VERSION=VERSION.tex
TDSARCHIVE=uwbeamer.tds.zip
CTANARCHIVE=uwbeamer.ctan.zip
DISTARCHIVE=uwbeamer.zip
ARCHIVES=$(TDSARCHIVE) $(CTANARCHIVE) $(DISTARCHIVE)
MAKEABLES=$(MANUAL) $(BASETHEMEFILE) $(ARCHIVES) $(VERSION)

TEXLIVEDIR=$(shell kpsewhich -var-value TEXMFLOCAL)

# This is the default pseudo-target.
all: base

# This pseudo-target expands all the docstrip files, converts the
# logos and creates the theme files.
base: $(SUBMAKES_REQUIRED)
	make $(BASETHEMEFILE)

# This pseudo-target creates the class files and typesets the
# technical documentation, the user guides, and the user examples.
complete: base
	make $(PDFS) clean

# This pseudo-target typesets the technical documentation and the
# user guides.
docs:
	make $(DOCS) clean

# This pseudo-target calls a submakefile.
$(SUBMAKES):
	make -C $@ all

# This pseudo-target performs the tests.
tests: base $(SUBMAKES_TEST)

# This pseudo-target creates the distribution archive.
dist: dist-implode complete
	make $(TDSARCHIVE) $(DISTARCHIVE) $(CTANARCHIVE)

# This target creates the theme files.
$(BASETHEMEFILE): uwbeamer.ins uwbeamer.dtx
	xetex $<

# This target typesets the guides and user examples.
$(GUIDES) $(USEREXAMPLES): $(RESOURCES)
	make -BC $(dir $@)

# This target typesets the technical documentation.
$(MANUAL): $(DTXFILES)
	pdflatex $<
	pdflatex $<
	makeindex -s gind.ist                       $(basename $@)
	makeindex -s gglo.ist -o $(basename $@).gls $(basename $@).glo
	pdflatex $<
	pdflatex $<

# This target generates a TeX directory structure file.
$(TDSARCHIVE):
	DIR=`mktemp -d` && \
	make install to="$$DIR" nohash=true && \
	(cd "$$DIR" && zip -r -v -nw $@ *) && \
	mv "$$DIR"/$@ $@ && rm -rf "$$DIR"

# This target generates a distribution file.
$(DISTARCHIVE): $(SOURCES) $(RESOURCES) $(MAKES) $(TESTS) \
	$(USEREXAMPLE_SOURCES) $(DOCS) $(PDFSOURCES) $(MISCELLANEOUS) \
	$(EXAMPLES) $(VERSION)
	DIR=`mktemp -d` && \
	cp --verbose $(TDSARCHIVE) "$$DIR" && \
	cp --parents --verbose $^ "$$DIR" && \
	(cd "$$DIR" && zip -r -v -nw $@ *) && \
	mv "$$DIR"/$@ . && rm -rf "$$DIR"

# This target generates a CTAN distribution file.
$(CTANARCHIVE): $(SOURCES) $(MAKES) $(TESTS) $(EXAMPLES) \
	$(MISCELLANEOUS) $(DOCS) $(VERSION) $(LOGOSOURCES)
	DIR=`mktemp -d` && mkdir -p "$$DIR/uwbeamer" && \
	cp --verbose $(TDSARCHIVE) "$$DIR" && \
	cp --parents --verbose $^ "$$DIR/uwbeamer" && \
	printf '.PHONY: implode\nimplode:\n' > \
		"$$DIR/uwbeamer/example/uw/Makefile" && \
	(cd "$$DIR" && zip -r -v -nw $@ *) && \
	mv "$$DIR"/$@ . && rm -rf "$$DIR"

# This pseudo-target installs the logo and theme files - as well as
# the technical documentation and user guides - into the TeX
# directory structure, whose root directory is specified within the
# "to" argument.  Specify "nohash=true", if you wish to forgo the
# reindexing of the package database.
install: install-base install-docs

# This pseudo-target installs the logo and theme files into the TeX
# directory structure, whose root directory is specified within the
# "to" argument.  Specify "nohash=true", if you wish to forgo the
# reindexing of the package database.
install-base:
	@if [ -z "$(to)" ]; then \
		printf "Usage: make install-base to=DIRECTORY\n"; \
		printf "Detected TeXLive directory: %s\n" $(TEXLIVEDIR); \
		exit 1; \
	fi

	@# Theme and logo files
	mkdir -p "$(to)/tex/latex/uwbeamer"
	cp --parents --verbose $(RESOURCES) "$(to)/tex/latex/uwbeamer"

	@# Source files
	mkdir -p "$(to)/source/latex/uwbeamer"
	cp --parents --verbose $(SOURCES) "$(to)/source/latex/uwbeamer"

	@# Rebuild the hash
	[ "$(nohash)" = "true" ] || texhash

# This pseudo-target installs the technical documentation and user
# guides into the TeX directory structure, whose root directory is
# specified within the "to" argument.  Specify "nohash=true", if
# you wish to forgo the reindexing of the package database.
install-docs:
	@if [ -z "$(to)" ]; then \
		printf "Usage: make install-docs to=DIRECTORY\n"; \
		printf "Detected TeXLive directory: %s\n" $(TEXLIVEDIR); \
		exit 1; \
	fi

	@# Documentation
	mkdir -p "$(to)/doc/latex/uwbeamer"
	cp --parents --verbose $(DOCS) "$(to)/doc/latex/uwbeamer"

	@# Rebuild the hash
	[ "$(nohash)" = "true" ] || texhash

# This pseudo-target uninstalls the logo and theme files - as well
# as the technical documentation and user guides - into the TeX
# directory structure, whose root directory is specified within the
# "from" argument.  Specify "nohash=true", if you wish to forgo the
# reindexing of the package database.
uninstall:
	@if [ -z "$(from)" ]; then \
		printf "Usage: make uninstall from=DIRECTORY\n"; \
		printf "Detected TeXLive directory: %s\n" $(TEXLIVEDIR); \
		exit 1; \
	fi

	@# Theme and logo files
	rm -rf "$(from)/tex/latex/uwbeamer"

	@# Source files
	rm -rf "$(from)/source/latex/uwbeamer"

	@# Documentation
	rm -rf "$(from)/doc/latex/uwbeamer"

	@# Rebuild the hash
	[ "$(nohash)" = "true" ] || texhash

# This pseudo-target removes any existing auxiliary files.
clean:
	rm -f $(AUXFILES)

# This pseudo-target removes the distribution archives.
dist-implode:
	rm -f $(ARCHIVES)

# This pseudo-target removes any makeable files.
implode: clean
	rm -f $(MAKEABLES)
	for dir in $(SUBMAKES); do make implode -C "$$dir"; done
