MODULE = $(notdir $(CURDIR))
TODAY = $(shell date +%d%m%y)

.PHONY: all
all: book

book:
	$(MAKE) -C book
	
pdf: $(MODULE)_$(TODAY).pdf
$(MODULE)_$(TODAY).pdf: book/$(MODULE).pdf
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook \
		-dNOPAUSE -dQUIET -dBATCH \
		-sOutputFile=$@ $<
# /screen /ebook /prepress

release:
	$(MAKE) all && $(MAKE) pdf
	git tag $(TODAY) && git push --tags

update:
	git submodule update --init --recursive

test:
	py.test --cov=metaL test_metaL.py
	coverage html
