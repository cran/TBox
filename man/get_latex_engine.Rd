% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/format_code.R
\name{get_latex_engine}
\alias{get_latex_engine}
\title{The latex engine}
\usage{
get_latex_engine()
}
\value{
a character vector of length 1 representing the latex engine.
}
\description{
This function returns the latex engine available to render .tex file into
pdf.
}
\details{
If several latex engine are available, the choice will be done in this order:

\itemize{
\item xelatex;
\item lualatex;
\item pdflatex;
\item tectonic.
}
}
\examples{
get_latex_engine()

}
