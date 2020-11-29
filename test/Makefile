DIFF := diff --strip-trailing-cr -u

.PHONY: pdf pdf-all pdf-column pdf-ruby pdf-index
.PHONY: tex tex-all tex-column tex-ruby tex-index

pdf: pdf-sample-all pdf-column pdf-ruby pdf-index
pdf-sample-all: sample-all.pdf
pdf-column: sample-column.pdf
pdf-column2: sample-column2.pdf
pdf-ruby: sample-ruby.pdf
pdf-index: sample-index.pdf

tex: sample-all column ruby index
sample-all: sample-all.tex
column: sample-column.tex
column2: sample-column2.tex
ruby: sample-ruby.tex
index: sample-index.tex

sample-all.tex: sample-all.md
	pandoc $< -s -o $@ -d defaults-latex.yaml

sample-column.tex: sample-column.md
	pandoc $< -s -o $@ -d defaults-latex.yaml -L tcolorbox-column.lua

sample-column2.tex: sample-column2.md
	pandoc $< -s -o $@ -d defaults-latex.yaml -L tcolorbox-column.lua

sample-ruby.tex: sample-ruby.md
	pandoc $< -s -o $@ -d defaults-latex.yaml -L pxrubrica-ruby.lua

sample-index.tex: sample-index.md
	pandoc $< -s -o $@ -d defaults-latex.yaml -L latex-index.lua -H header-index.tex

%.pdf: %.tex
	rm -rf tmp
	latexmk $< -outdir=tmp
	mv tmp/$@ .

clean-%:
	# echo $(patsubst clean-%,%,$@)
	rm -f sample-$(patsubst clean-%,%,$@).tex sample-$(patsubst clean-%,%,$@).pdf

clean:
	rm -rf tmp
	rm -f *.ltjruby

clean-all:
	make clean
	rm -f sample-*.tex