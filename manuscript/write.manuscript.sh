R CMD Sweave results.Rnw
R CMD Sweave priors.Rnw
pdflatex manuscript.tex
bibtex manuscript
pdflatex manuscript.tex
pdflatex manuscript.tex