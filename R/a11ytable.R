
#' Create An 'a11ytable' Object
#'
#' Create a new a11ytable-class object, which is a dataframe that contains all
#' the information needed in your output spreadsheet. In turn, the object
#' created by  this function can be used to populate an 'openxlsx'
#' Workbook-class object with the function \code{\link{generate_workbook}}.
#'
#' @param tab_titles Required character vector, one value per sheet. Each title
#'     will appear literally on each tab of the final spreadsheet output. Keep
#'     brief. Letters and numbers only; use underscores for spaces. For example:
#'     'Cover', 'Contents', 'Notes', 'Table_1'. Will be corrected automatically
#'     if non-conforming.
#' @param sheet_types Required character vector, one value per sheet. Sheets
#'     that don't contain publication tables ('meta' sheets) should be of type
#'     'contents', 'cover' or 'notes'. Sheets that contain statistical tables of
#'     data are type 'tables'.
#' @param sheet_titles Required character vector, one value per sheet. The main
#'     title for each sheet, which will appear in cell A1 (top-left corner).
#' @param blank_cells Optional character vector, one value per sheet. A short
#'     sentence to explain the reason for any blank cells in the sheet. Most
#'     likely to be used with sheet type 'tables'.
#' @param sources Optional character vector, one value per sheet. The origin of
#'     the data for a given sheet. Supply as \code{NA_character_} if empty. To
#'     be used with sheet type 'tables'.
#' @param tables Required list of data.frames (though the cover sheet may be
#'     supplied as a list), one per sheet. See details.
#'
#' @details
#'
#' ## How to supply data to the 'tables' argument
#'
#' Formats for the elements collected as a list and passed to the 'tables'
#' argument, depending on the sheet type.
#'
#' \itemize{
#'     \item Sheet type 'cover': either (a) a list where each element name is a
#'         section header and each element's content is a character vector
#'         whose elements will make up separate rows of that section
#'         (recommended), or (b) a data.frame with one row per subsection, with
#'         one column for section titles and one column for corresponding for
#'         that section's body text. For example, you may have a section with
#'         the title 'Contact details' that contains an email address and
#'         telephone number. You can use linebreaks (i.e. '\\n') to separate
#'         text into paragraphs.
#'     \item Sheet type 'contents': one row per sheet, two columns suggested at
#'         least ('Tab title' and 'Worksheet title').
#'     \item Sheet type 'notes': one row per note, two columns suggested ('Note
#'         number', 'Note text'), where notes are in the form '\[note 1\]'.
#'     \item Sheet type 'tables': a tidy, rectangular data.frame containing the
#'         data to be published. It's the user's responsibility to add notes in
#'         the form '\[note 1\]' to column headers, or in a special 'Notes' row.
#' }
#'
#' ## How to supply hyperlinks
#'
#' You can provide text in Markdown link syntax (e.g.
#' '\[GOV.UK\](https://www.gov.uk)', adding 'mailto:' before an
#' email address) and the containing cell will be rendered as a hyperlink in the
#' output spreadsheet. Note that whole cells will become hyperlinks; there is no
#' support for selected words in a sentence to be rendered as a hyperlink.
#'
#' Hyperlinks can be supplied in two locations:
#'
#' \itemize{
#'     \item To the 'tables' argument for sheet type 'cover' only. It's
#'         recommended to supply the cover information as a list rather than a
#'         data.frame, which will allow you to make specific rows within a
#'         section into hyperlinks. For example, in a 'Contact us' section you
#'         might want a row containing some preamble (no hyperlink), a cell
#'         containing a phone number (no hyperlink) and a cell containing an
#'         email address (hyperlinked).
#'     \item To the 'source' argument for data tables.
#' }
#'
#' @return An object with classes 'a11ytable', 'tbl' and 'data.frame'.
#'
#' @examples
#' # Create an a11ytable with in-built demo dataframe, mtcars_df2
#' x <- create_a11ytable(
#'   tab_titles   = mtcars_df2$tab_title,
#'   sheet_types  = mtcars_df2$sheet_type,
#'   sheet_titles = mtcars_df2$sheet_title,
#'   blank_cells  = mtcars_df2$blank_cells,
#'   sources      = mtcars_df2$source,
#'    tables       = mtcars_df2$table
#' )
#'
#' # Test that 'a11ytable' is one of the object's classes
#' is_a11ytable(x)
#'
#' # You can also use the RStudio Addin installed with the package to insert a
#' # an example skeleton containing this function.
#'
#' @export
create_a11ytable <- function(
    tab_titles,
    sheet_types = c("cover", "contents", "notes", "tables"),
    sheet_titles,
    blank_cells = NA_character_,
    sources = NA_character_,
    tables
) {

  x <- data.frame(
    tab_title   = unlist(tab_titles),
    sheet_type  = unlist(sheet_types),
    sheet_title = unlist(sheet_titles),
    blank_cells = unlist(blank_cells),
    source      = unlist(sources),
    stringsAsFactors = FALSE  # because default is TRUE prior to R v4
  )

  x[["table"]] <- tables

  as_a11ytable(x)

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
#' # Create an a11ytable with in-built demo dataframe, mtcars_df2. We can use
#' # 'as_a11ytable' rather than 'create_a11ytable' because the data is already
#' # in the right format.
#' x <- as_a11ytable(mtcars_df2)
#'
#' # Test the object's class
#' is_a11ytable(x)
#'
#' @export
as_a11ytable <- function(x) {

  if (any(names(x) %in% "tab_title")) {
    x[["tab_title"]] <- .clean_tab_titles(x[["tab_title"]])
  }

  if (any(names(x) %in% "blank_cells")) {
    x[["blank_cells"]] <- .append_period(x[["blank_cells"]])
  }

  # if (any(names(x) %in% "source")) {
  #   x[["source"]] <- .append_period(x[["source"]])
  # }

  class(x) <- c("a11ytable", "tbl", "data.frame")

  .validate_a11ytable(x)
  .warn_a11ytable(x)

  x

}

#' @rdname as_a11ytable
#' @export
is_a11ytable <- function(x) {

  inherits(x, "a11ytable")

}

#' Summarise An 'a11ytable' Object
#'
#' A concise result summary of an a11ytable-class object to see information about
#' the sheet content.
#'
#' @param object An a11ytable-class object for which to get a summary.
#' @param ... Other arguments to pass.
#'
#' @examples
#' # Create an a11ytable with in-built demo dataframe, mtcars_df2. We can use
#' # 'as_a11ytable' rather than 'create_a11ytable' because the data is already
#' # in the right format.
#' x <- as_a11ytable(mtcars_df2)
#'
#' # Print summary of a11ytable-class object
#' summary(x)
#'
#' @export
summary.a11ytable <- function(object, ...) {

  x_dims <- lapply(
    lapply(object[["table"]], dim),
    function(x) paste(x, collapse = " x ")
  )

  tab_title <- paste0("\n", paste("  -", object[["tab_title"]], collapse = "\n"))
  sh_type   <- paste0("\n", paste("  -", object[["sheet_type"]], collapse = "\n"))
  sh_title  <- paste0("\n", paste("  -", object[["sheet_title"]], collapse = "\n"))
  tbl_dims  <- paste0("\n", paste("  -", unlist(x_dims), collapse = "\n"))

  cat(
    "# An a11ytable with", nrow(object), "sheets\n",
    "* Tab titles:",   tab_title, "\n",
    "* Sheet types:",  sh_type,   "\n",
    "* Sheet titles:", sh_title,  "\n",
    "* Table sizes:",  tbl_dims,  "\n"
  )

  invisible(object)

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
#' # Create an a11ytable with in-built demo dataframe, mtcars_df2. We can use
#' # 'as_a11ytable' rather than 'create_a11ytable' because the data is already
#' # in the right format.
#' x <- as_a11ytable(mtcars_df2)
#'
#' # Print description only
#' tbl_sum(x)
#'
#' # Print with description
#' print(x)
#' }
#'
#' @export
tbl_sum.a11ytable <- function(x, ...) {

  header <- sprintf(
    "%s x %s",
    formatC(nrow(x), big.mark = ","),
    formatC(ncol(x), big.mark = ",")
  )

  c("a11ytable" = header)

}
