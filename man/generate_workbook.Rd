% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/workbook.R
\name{generate_workbook}
\alias{generate_workbook}
\title{Generate A Workbook Object From An 'a11ytable'}
\usage{
generate_workbook(a11ytable)
}
\arguments{
\item{a11ytable}{An a11ytable-class object created using
\code{\link{create_a11ytable}} (or \code{\link{as_a11ytable}}), which
contains the data and information needed to create a workbook.}
}
\value{
A Workbook-class object.
}
\description{
Populate an 'openxlsx' Workbook-class object with content from an
a11ytable-class object. In turn, the output can be passed to
\code{\link[openxlsx]{saveWorkbook}} from 'openxlsx'
}
\examples{
# Convert an a11ytable to a Workbook-class object
x <- generate_workbook(demo_a11ytable)
class(x)

# As above, using a compliant data.frame and the base pipe
y <- demo_df |>
  as_a11ytable() |>
  generate_workbook()

}
