SPEC=spec.txt
SITE=_site
SPECVERSION=$(shell perl -ne 'print $$1 if /^version: *([0-9.]+)/' $(SPEC))

.PHONY: spec update-site upload-site

spec: spec.html # spec.pdf

spec.md: $(SPEC)
	python3 tools/makespec.py markdown > $@

spec.html: spec.txt tools/template.html
	python3 tools/makespec.py html > $@

spec.pdf: spec.md tools/template.tex tools/specfilter.hs
	pandoc -s $< --template tools/template.tex \
	   --filter tools/specfilter.hs -o $@ --latex-engine=xelatex --toc \
	   --number-sections --toc-depth=2 --no-highlight \
	   -V documentclass=report \
	   -V classoption=twosides

