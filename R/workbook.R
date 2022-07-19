
#' Generate A Workbook Object From An 'a11ytable'
#'
#' Populate an 'openxlsx' Workbook-class object with content from an
#' a11ytable-class object. In turn, the output can be passed to
#' \code{\link[openxlsx]{saveWorkbook}} from 'openxlsx'
#'
#' @param a11ytable An a11ytable-class object created using
#'     \code{\link{create_a11ytable}} (or \code{\link{as_a11ytable}}), which
#'     contains the data and information needed to create a workbook.
#'
#' @return A Workbook-class object.
#'
#' @examples
#' \dontrun{
#' # Create an a11ytable with in-built demo dataframe, mtcars_df
#' x <- as_a11ytable(mtcars_df)
#'
#' # Convert to a Workbook-class object
#' generate_workbook(x)
#'
#' # As above, using a base pipe
#' mtcars_df |>
#'   as_a11ytable() |>
#'   generate_workbook()
#'
#' # You can also use the RStudio Addin installed with the package to insert a
#' # an example skeleton containing this function.
#' }
#'
#' @export
generate_workbook <- function(a11ytable) {

  if (!is_a11ytable(a11ytable)) {
    stop("The object passed to argument 'content' must have class 'a11ytable'.")
  }

  # Create a table_name from tab_title (unqiue, no spaces, no punctuation)
  a11ytable[["table_name"]] <-
    gsub(" ", "_", tolower(trimws(a11ytable[["tab_title"]])))
  a11ytable[["table_name"]] <-
    gsub("(?!_)[[:punct:]]", "", a11ytable[["table_name"]], perl = TRUE)

  # Create workbook, add tabs, cover, contents (required for all workbooks)
  wb <- openxlsx::createWorkbook()
  wb <- .add_tabs(wb, a11ytable)
  wb <- .add_cover(wb, a11ytable)
  wb <- .add_contents(wb, a11ytable)

  # There won't always be a notes tab
  if (any(a11ytable$sheet_type %in% "notes")) {
    wb <- .add_notes(wb, a11ytable)
  }

  # Iterable titles for tabs containing tables
  table_sheets <- a11ytable[a11ytable$sheet_type == "tables", ][["table_name"]]

  for (i in table_sheets) {
    wb <- .add_tables(wb, a11ytable, table_name = i)
  }

  return(wb)

}
