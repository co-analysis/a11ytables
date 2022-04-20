
#' Create An Accessible Workbook
#'
#' Populate an 'openxlsx' Workbook-class object with content from an
#' a11ytable-class object.
#'
#' @param content An a11ytable-class object containing the data and
#'     information needed to create your workbook.
#'
#' @details You can create an a11ytable object with
#'     \code{\link{new_a11ytable}} (or \code{\link{as_a11ytable}}).
#'
#' @return A Workbook-class object.
#'
#' @examples
#' \dontrun{
#' x <- as_a11ytable(mtcars_df)
#' create_a11y_wb(x)
#' }
#'
#' @export
create_a11y_wb <- function(content) {

  if (!is_a11ytable(content)) {
    stop("The object passed to argument 'content' must have class 'a11ytable'.")
  }

  # Create a table_name from tab_title (unqiue, no spaces, no punctuation)
  content[["table_name"]] <-
    gsub(" ", "_", tolower(trimws(content[["tab_title"]])))
  content[["table_name"]] <-
    gsub("(?!_)[[:punct:]]", "", content[["table_name"]], perl = TRUE)

  # Create workbook, add tabs, cover, contents (required for all workbooks)
  wb <- openxlsx::createWorkbook()
  wb <- .add_tabs(wb, content)
  wb <- .add_cover(wb, content)
  wb <- .add_contents(wb, content)

  # There won't always be a notes tab
  if (any(content$sheet_type %in% "notes")) {
    wb <- .add_notes(wb, content)
  }

  # Iterable titles for tabs containing tables
  table_sheets <- content[content$sheet_type == "tables", ][["table_name"]]

  for (i in table_sheets) {
    wb <- .add_tables(wb, content, table_name = i)
  }

  return(wb)

}
