
.validate_a11ytable <- function(x) {

  names_req <- c(
    "tab_title", "sheet_type", "sheet_title", "source",
    "subtable_num","subtable_title", "table_name", "table"
  )

  names_in <- names(x)

  # must be of data.frame class
  if (!any(class(x) %in% "data.frame")) {
    stop("'x' must have class data.frame.")
  }

  # must have particular dimensions (must have cover, contents table, at least)
  if (length(names_req) != length(x) | nrow(x) < 3) {
    stop("'x' must have 8 columns and at least 4 rows.")
  }

  # column names must match expected format
  if (!all(names_req %in% names_in)) {
    stop("Content data.frame does not have the correct column names.")
  }

  # 'table' column class must be listcol
  if (class(x[["table"]]) != "list") {
    stop("Column 'table' must be a listcol of data.frame objects.")
  }

  # class must be character for all columns except 'table'
  if (!all(unlist(lapply(x[-8], is.character)))) {
    stop("All columns except 'table' must be character class.")
  }

  # content of listcol column must be single data.frame objects
  if (!all(unlist(lapply(x[["table"]], is.data.frame)))) {
    stop("List-column 'table' must contain data.frame objects only.")
  }

  # first three rows must be cover, contents and notes
  if (
    !any(
      unlist(x[1:3, "tab_title"]) == c("cover", "contents", "notes")
    )
  ) {
    stop(
      paste(
        "The first three elements of the 'table_name' column in 'x' must",
        "be 'cover', 'contents' and 'notes'"
      )
    )
  }

  # there should be no empty rows for certain columns
  if (!all(unlist(lapply(x[c(1:3, 7)], function(x) all(!is.na(x)))))) {
    stop(
      paste(
        "Columns 'tab_title', 'sheet_type', 'sheet_tite', 'table_name', and",
        "'table' must not contain NA."
      )
    )
  }

}
