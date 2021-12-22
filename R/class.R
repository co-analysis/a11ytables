
#' Create An a11ytable-class Object
#'
#' Create an object containing all the input data and supporting information
#' for your publication, which will be used to populate a workbook.
#'
#' @param tab_titles Required character vector, one value per sheet. The text
#'     that will appear on the tab interface of the when opened in spreadsheet
#'     software. Provide table sheets as numbers.
#' @param sheet_types Required character vector, one value per sheet. Contents,
#'     cover and notes have type "meta"; publication tables are type "tables".
#' @param sheet_titles Required character vector, one value per sheet. The main
#'     title of the sheet. Will appear in large text in cell A1 (top-left)
#'     corner of each sheet.
#' @param sources Optional character vector, one value per sheet (NA is valid).
#'     The origin of the data for a given sheet.
#' @param subtable_nums Not currently implemented. Character vector. The table
#'     numbers for when a sheet contains more than one table (not recommended).
#' @param subtable_titles Not currently implemented. Character vector. The
#'     table titles for when a sheet contains more than one table (not
#'     recommended).
#' @param table_names Required character vector, one value per sheet. A name to
#'     give the 'named range' of cells that compose the table in the final
#'     spreadsheet output. Makes sheet navigation easier.
#' @param tables Required list of data.frames, one per sheet. See details.
#'
#' @details Formats for data.frames in the 'tables' argument, depending on the
#'     sheet type:
#' \itemize{
#'     \item cover: one column with a pair of rows for each point of information
#'         (a section with contact details should have a row for the title of that
#'         section, like 'Contact details' and one row containing the information;
#'         use line breaks to separate information onto different lines, like a
#'         telephone number and email address in this example)
#'     \item contents: one row per sheet, five columns suggested ('Worksheet
#'         number', 'Worksheet title', 'Data of first publication', 'Date of
#'         next publication', 'Source')
#'     \item notes: one row per note, two columns suggested ('Note number',
#'         'Note text')
#'     \item tables: a tidy, rectangular data.frame containing the data to be
#'         published
#' }
#'
#' @return An a11ytables-class object.
#' @export
#'
#' @examples \dontrun{
#'     new_a11ytable(
#'       tab_titles      = a11ytables::lfs_tables$tab_title,
#'       sheet_types     = a11ytables::lfs_tables$sheet_type,
#'       sheet_titles    = a11ytables::lfs_tables$sheet_title,
#'       sources         = a11ytables::lfs_tables$source,
#'       subtable_nums   = a11ytables::lfs_tables$subtable_num,
#'       subtable_titles = a11ytables::lfs_tables$subtable_title,
#'       table_names     = a11ytables::lfs_tables$table_name,
#        tables          = a11ytables::lfs_tables$table
#'     )
#' }
new_a11ytable <- function(
  tab_titles,
  sheet_types = c("meta", "tables"),
  sheet_titles,
  sources = NULL,
  subtable_nums = NULL,
  subtable_titles = NULL,
  table_names,
  tables
) {

  x <- data.frame(
    tab_title = unlist(tab_titles),
    sheet_type = unlist(sheet_types),
    sheet_title = unlist(sheet_titles),
    source = unlist(sources),
    subtable_num = unlist(subtable_nums),
    subtable_title = unlist(subtable_titles),
    table_name = unlist(table_names)
  )

  x[["table"]] <- tables

  # class(x) <- append(class(x), "a11ytable")
  class(x) <- c("a11ytable", "data.frame")

  .validate_a11ytable(x)

  return(x)

}

#' Print a11ytable Object For Reading
#'
#' Print an a11ytable object to see information about the
#' sheet content.
#'
#' @param x An a11ytable object to print.
#' @param ... Other arguments to pass.
#' @return Nothing.
#' @export
print.a11ytable <- function(x, ...) {

  x_dims <- lapply(
    lapply(x$table, dim),
    function(x) paste(x, collapse = " × ")
  )

  out_tab_title <- paste0("\n", paste("  -", x$tab_title, collapse = "\n"))
  out_sh_type   <- paste0("\n", paste("  -", x$sheet_type, collapse = "\n"))
  out_sh_title  <- paste0("\n", paste("  -", x$sheet_title, collapse = "\n"))
  out_tbl_name  <- paste0("\n", paste("  -", x$table_name, collapse = "\n"))
  out_tbl_dims  <- paste0("\n", paste("  -", unlist(x_dims), collapse = "\n"))

  cat(
    "# An a11ytable with", nrow(x), "sheets\n",
    "* Tab titles:", out_tab_title, "\n",
    "* Sheet types:", out_sh_type, "\n",
    "* Sheet titles:", out_sh_title, "\n",
    "* Table names:", out_tbl_name, "\n",
    "* Table sizes:", out_tbl_dims, "\n"
  )

}

#' Coerce to an a11ytable
#'
#' Coerce a data.frame to an a11ytable-class object
#' if possible.
#'
#' @param x A data.frame object to coerce.
#' @return An object of class a11ytable.
#' @export
as_a11ytable <- function(x) {

  class(x) <- c("a11ytable", "data.frame")
  .validate_a11ytable(x)
  return(x)

}

#' Check for a11ytable class
#'
#' Detect whether a given object has the class
#' a11ytable.
#'
#' @param x An object to assess.
#' @return Logical. \code{TRUE} if the object has class a11ytable,
#'     otherwise \code{FALSE}.
#' @export
is_a11ytable <- function(x) {

  inherits(x, "a11ytable")

}
