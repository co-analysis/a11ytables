
#' Create An Accessible Workbook
#'
#' Populate an {openxlsx} workbook object with content from a a11ytable-class
#' input.
#'
#' @param content An a11ytable-class object containing the data and information
#'     needed to create your workbook.
#'
#' @details You can create an a11ytable object with
#'     \code{\link{new_a11ytable}} (or \code{\link{as_a11ytable}}).
#'
#' @return A Workbook-class object.
#' @export
#'
#' @examples \dontrun{ create_a11y_wb(content) }
create_a11y_wb <- function(content) {

  # Create workbook, add tabs, cover, contents (required for all workbooks)
  wb <- openxlsx::createWorkbook()
  wb <- .add_tabs(wb, content)
  wb <- .add_cover(wb, content)
  wb <- .add_contents(wb, content)

  # There won't always be a notes tab
  if (any(content$tab_title %in% "notes")) {
    wb <- .add_notes(wb, content)
  }

  # Iterable titles for tabs containing tables
  table_sheets <- content[content$sheet_type == "tables", ][["table_name"]]

  for (i in table_sheets) {
    wb <- .add_tables(wb, content, table_name = i)
  }

  return(wb)

}
