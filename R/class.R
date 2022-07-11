
#' Create An 'a11ytable' Object
#'
#' Create a new a11ytable-class object, which is a data.frame that contains all
#' the information needed in your publication. In turn, this will be used to
#' populate an 'openxlsx' Workbook-class object with the function
#' \code{\link{create_a11y_wb}}.
#'
#' @param tab_titles Required character vector, one value per sheet. Each title
#'     will appear on each tab of the final spreadsheet output. Keep brief.
#'     For example: 'Cover', 'Contents', 'Notes', 'Table 1'.
#' @param sheet_types Required character vector, one value per sheet. Sheets
#'     that don't contain publication tables ('meta' sheets) should be of type
#'     'contents', 'cover' or 'notes'. Sheets that contain statistical tables of
#'     data are type 'tables'.
#' @param sheet_titles Required character vector, one value per sheet. The main
#'     title for each sheet, which will appear in cell A1 (top-left corner).
#' @param blank_cells Optional character vector, one value per sheet. A short
#'     sentence to explain the reason for any blank cells in the sheet. Most
#'     likely to be used with sheet type 'tables'.
#' @param sources Optional character vector, one value per sheet. The origin of the data for a given sheet. Supply as
#'     \code{NA_character_} if empty. To be used with sheet type 'tables'.
#' @param tables Required list of data.frames, one per sheet. See details.
#'
#' @details Formats for data.frames in the 'tables' argument, depending on the
#'     sheet type.
#' \itemize{
#'     \item Sheet type 'cover': one row per subsection, with columns for
#'         'Subsection title' and 'Subsection text'. For example, a section with
#'         contact details might have 'Contact details' as the subsection title
#'         and a telephone number and email address in the body-text column. Use
#'         linebreaks (i.e. '\\n') to put multiple rows in the same body text.
#'         Don't break information into separate spreadsheet rows if they belong
#'         in the same subsection).
#'     \item Sheet type 'contents': one row per sheet, two columns suggested at
#'         least ('Tab title' and 'Worksheet title').
#'     \item Sheet type 'notes': one row per note, two columns suggested ('Note
#'         number', 'Note text').
#'     \item Sheet type 'tables': a tidy, rectangular data.frame containing the
#'         data to be published.
#' }
#'
#' @return An a11ytable-class object.
#'
#' @examples
#' \dontrun{
#' x <- new_a11ytable(
#'     tab_titles   = mtcars_df$tab_title,
#'     sheet_types  = mtcars_df$sheet_type,
#'     sheet_titles = mtcars_df$sheet_title,
#'     blank_cells  = mtcars_df$blank_cells,
#'     sources      = mtcars_df$source,
#      tables       = mtcars_df$table
#' )
#' is_a11ytable(x)
#' }
#'
#' @export
new_a11ytable <- function(
  tab_titles,
  sheet_types = c("cover", "contents", "notes", "tables"),
  sheet_titles,
  blank_cells = NA_character_,
  sources = NA_character_,
  tables
) {

  if (!any(sheet_types %in% c("cover", "contents", "notes", "tables"))) {
    stop("'sheet_type' must be one of 'cover', 'contents', 'notes', 'tables'.")
  }

  if (length(tab_titles) != length(unique(tolower(tab_titles)))) {
    stop("Elements in 'tab_titles' must be unique (case-insensitive).")
  }

  tab_titles_cleaned <- .clean_tab_titles(tab_titles)

  x <- data.frame(
    tab_title = unlist(tab_titles_cleaned),
    sheet_type = unlist(sheet_types),
    sheet_title = unlist(sheet_titles),
    blank_cells = unlist(blank_cells),
    source = unlist(sources)
  )

  x[["table"]] <- tables

  class(x) <- c("a11ytable", "tbl", "data.frame")

  .validate_a11ytable(x)
  .warn_a11ytable(x)

  return(x)

}

#' Summarise An 'a11ytable' Object
#'
#' A concise result summary of an a11ytable-class object to see information about
#' the sheet content.
#'
#' @param object An a11ytable-class object to get a summary for.
#' @param ... Other arguments to pass.
#'
#' @examples
#' \dontrun{
#' x <- as_a11ytable(mtcars_df)
#' summary(x)
#' }
#'
#' @export
summary.a11ytable <- function(object, ...) {

  x_dims <- lapply(
    lapply(object$table, dim),
    function(object) paste(object, collapse = " x ")
  )

  out_tab_title <- paste0("\n", paste("  -", object$tab_title,   collapse = "\n"))
  out_sh_type   <- paste0("\n", paste("  -", object$sheet_type,  collapse = "\n"))
  out_sh_title  <- paste0("\n", paste("  -", object$sheet_title, collapse = "\n"))
  out_tbl_dims  <- paste0("\n", paste("  -", unlist(x_dims),     collapse = "\n"))

  cat(
    "# An a11ytable with", nrow(object), "sheets\n",
    "* Tab titles:",   out_tab_title, "\n",
    "* Sheet types:",  out_sh_type,   "\n",
    "* Sheet titles:", out_sh_title,  "\n",
    "* Table sizes:",  out_tbl_dims,  "\n"
  )

  invisible(object)

}

#' Coerce To An 'a11ytable' Object
#'
#' Functions to check if an object is an a11ytable, or coerce it if possible.
#'
#' @param x A data.frame object to coerce.
#'
#' @return \code{as_a11ytable} returns an object of class a11ytable if possible.
#'     \code{is_a11ytable} returns \code{TRUE} if the object has class
#'     a11ytable, otherwise \code{FALSE}.
#'
#' @examples
#' \dontrun{
#' x <- as_a11ytable(mtcars_df)
#' is_a11ytable(x)
#' }
#'
#' @export
as_a11ytable <- function(x) {

  class(x) <- c("a11ytable", "tbl", "data.frame")
  .validate_a11ytable(x)
  .warn_a11ytable(x)
  return(x)

}

#' @rdname as_a11ytable
#' @export
is_a11ytable <- function(x) {

  inherits(x, "a11ytable")

}

#' @importFrom pillar tbl_sum
NULL

#' Provide A Succinct Summary Of An 'a11ytable' Object
#'
#' A brief textual description of an a11ytable-class object.
#'
#' @param x An a11ytable-class object to summarise.
#' @param ... Other arguments to pass.
#'
#' @return Named character vector.
#'
#' @examples
#' \dontrun{
#' x <- as_a11ytable(mtcars_df)
#' tbl_sum(x)  # description only
#' print(x)  # print with description
#' }
#' @export
tbl_sum.a11ytable <- function(x, ...) {

  header <- sprintf(
    "%s x %s",
    formatC(nrow(x), big.mark = ","),
    formatC(ncol(x), big.mark = ",")
  )

  c("a11ytables" = header)

}
