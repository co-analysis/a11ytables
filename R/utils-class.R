
.validate_a11ytable <- function(x) {

  names_req <- c(
    "tab_title", "sheet_type", "sheet_title", "source", "table_name", "table"
  )

  names_in <- names(x)

  # must be of data.frame class
  if (!any(class(x) %in% "data.frame")) {
    stop("Input must have class data.frame.")
  }

  # must have particular dimensions (must have cover, contents table, at least)
  if (length(names_req) != length(x) | nrow(x) < 3) {
    stop("Input must be a data.frame with 6 columns and at least 4 rows.")
  }

  # column names must match expected format
  if (!all(names_req %in% names_in)) {
    stop("Input data.frame does not have the required column names.")
  }

  # 'table' column class must be listcol
  if (class(x[["table"]]) != "list") {
    stop("Column 'table' must be a listcol of data.frame objects.")
  }

  # class must be character for all columns except 'table'
  if (!all(unlist(lapply(x[-6], is.character)))) {
    stop("All columns except 'table' must be character class.")
  }

  # content of listcol column must be single data.frame objects
  if (!all(unlist(lapply(x[["table"]], is.data.frame)))) {
    stop("List-column 'table' must contain data.frame objects only.")
  }

  # There must be cover and contents sheets
  if (sum(x[["sheet_type"]] %in% c("cover", "contents")) < 2) {
    stop("The input data.frame must have sheet_type 'cover' and 'contents'.")
  }

  # there should be no empty rows for certain columns
  if (!all(unlist(lapply(x[c(1:3, 5:6)], function(x) all(!is.na(x)))))) {
    stop(
      paste(
        "Columns 'tab_title', 'sheet_type', 'sheet_title', 'table_name', and",
        "'table' must not contain NA."
      )
    )
  }

}

.warn_a11ytable <- function(content) {

  # Sources

  table_sources <- content[content$sheet_type == "tables", "source"]

  if (any(is.na(table_sources))) {

    warning(
      "One of your tables is missing a source.",
      call. = FALSE
    )

  }

  # Notes (presence)

  notes_sheet  <- content[content$sheet_type == "notes", ]  # only one
  tables_sheets <- content[content$sheet_type == "tables", ]  # maybe multiple

  has_notes <-
    any(
      unlist(
        lapply(
          tables_sheets[, "tab_title"],
          function(x) .detect_notes(tables_sheets, x)
        )
      )
    )

  if (nrow(notes_sheet) == 0 & has_notes) {

    warning(
      "You have in-table notes, but no notes sheet.",
      call. = FALSE
    )

  }

  if (nrow(notes_sheet) > 0 & !has_notes) {

    warning(
      "You have a notes sheet, but no in-table notes.",
      call. = FALSE
    )

  }

  # Notes mismatch

  notes_sheet_notes <-
    suppressWarnings(
      as.numeric(
        gsub("\\[|\\]", "", notes_sheet[, "table"][[1]][[1]])
      )
    )

  notes_sheet_notes <- notes_sheet_notes[!is.na(notes_sheet_notes)]

  tables_sheet_notes <- sort(
    unique(
      unlist(
        lapply(
          tables_sheets$tab_title,
          function(x) .extract_note_values(content, x)
        )
      )
    )
  )

  not_in_tables <- setdiff(notes_sheet_notes, tables_sheet_notes)
  not_in_notes  <- setdiff(tables_sheet_notes, notes_sheet_notes)

  if (length(not_in_tables) > 0) {

    warning(
      "Some notes are in the tables (",
      paste(not_in_tables, collapse = ", "),
      ") but are missing from the notes sheet.",
      call. = FALSE
    )

  }

  if (length(not_in_notes) > 0) {

    warning(
      "Some notes are in the notes sheets (",
      paste(not_in_notes, collapse = ", "),
      ") but are missing from the tables.",
      call. = FALSE
    )

  }

}
