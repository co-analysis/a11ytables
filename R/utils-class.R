
.validate_a11ytable <- function(x) {

  names_req <- c(
    "tab_title", "sheet_type", "sheet_title", "blank_cells", "source", "table"
  )
  names_count <- length(names_req)
  names_in <- names(x)

  # Must be of data.frame class
  if (!any(class(x) %in% "data.frame")) {
    stop("Input must have class data.frame.")
  }

  # Must have particular dimensions (must have cover, contents table, at least)
  if (length(names_req) != length(x) | nrow(x) < 3) {
    stop(
      "Input must be a data.frame with ",
      names_count,
      " columns and at least 4 rows."
    )
  }

  # Column names must match expected format
  if (!all(names_req %in% names_in)) {
    stop("Input data.frame does not have the required column names.")
  }

  # 'table' column class must be listcol
  if (class(x[["table"]]) != "list") {
    stop("Column 'table' must be a listcol of data.frame objects.")
  }

  # Class must be character for all columns except 'table'
  if (!all(unlist(lapply(subset(x, select = -table), is.character)))) {
    stop("All columns except 'table' must be character class.")
  }

  # Content of listcol column must be single data.frame objects
  if (!all(unlist(lapply(x[["table"]], is.data.frame)))) {
    stop("List-column 'table' must contain data.frame objects only.")
  }

  # There must be cover and contents sheets
  if (sum(x[["sheet_type"]] %in% c("cover", "contents")) < 2) {
    stop("The input data.frame must have sheet_type 'cover' and 'contents'.")
  }

  # There must be only one cover, contents and (optional) notes sheet
  if (
    sum(x[["sheet_type"]] == "cover") > 1 |
    sum(x[["sheet_type"]] == "contents") > 1 |
    sum(x[["sheet_type"]] == "notes") > 1
  ) {
    stop(
      "There can be only one 'cover', 'contents' and 'notes' in sheet_type."
    )
  }

  # There should be no empty rows, except in the blank_cells or source columns
  if (
    any(
      is.na(
        subset(x, select = c("tab_title", "sheet_type", "sheet_title", "table"))
      )
    )
  ) {
    stop(
      paste(
        "Columns 'tab_title', 'sheet_type', 'sheet_title' and",
        "'table' must not contain NA."
      )
    )
  }

}

.warn_a11ytable <- function(content) {

  # Warn about missing sources

  table_sources <- content[content$sheet_type == "tables", "source"]

  if (any(is.na(table_sources))) {
    warning("One of your tables is missing a source statement.", call. = FALSE)
  }

  # Warn about possibly missing rows in the contents table

  contents_table <- content[content$sheet_type == "contents", "table"][[1]]

  if (nrow(content) != nrow(contents_table) + 2) {
    warning(
      "There are ", nrow(content) - 2, " tables but only ",
      nrow(contents_table), " in the contents sheet.",
      call. = FALSE
    )
  }

  # Warn about notes (missing notes sheet, or notes in table)

  tables_sheets <- content[content$sheet_type == "tables", ]

  has_notes_sheet <- ifelse(
    nrow(content[content$sheet_type == "notes", ]) > 0,
    TRUE, FALSE
  )

  has_notes <-
    any(
      unlist(
        lapply(
          tables_sheets[, "tab_title"][[1]],
          function(x) .has_notes(content, x)
        )
      )
    )


  if (has_notes_sheet) {

    if (!has_notes) {
      warning(
        "You have a 'notes' sheet, but no notes in your tables.",
        call. = FALSE
      )
    }

  }

  if (has_notes) {

    if (!has_notes_sheet) {
      warning(
        "You have notes in your tables, but no 'notes' sheet.",
        call. = FALSE
      )
    }

  }

  # Warn about notes (note sheet present, but mismatches exist)

  if (has_notes_sheet) {

    notes_sheet  <- content[content$sheet_type == "notes", ]  # max of one notes sheet

    notes_sheet_vector <- notes_sheet[, "table"][[1]][[1]]  # assumes first col has note values

    notes_sheet_values <- unlist(  # e.g. get c(1, 2) from c("[note 1]", "[note 2]")
      regmatches(
        notes_sheet_vector,
        gregexpr("\\d", notes_sheet_vector, perl = TRUE)  # extract numbers
      )
    )

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

    not_in_tables <- setdiff(notes_sheet_values, tables_sheet_notes)
    not_in_notes  <- setdiff(tables_sheet_notes, notes_sheet_values)

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
        "Some notes are in the notes sheet (",
        paste(not_in_notes, collapse = ", "),
        ") but are missing from the tables.",
        call. = FALSE
      )
    }

  }

  # Warn about blank cells in tables

  tables_list <- stats::setNames(
    tables_sheets[["table"]], tables_sheets[["tab_title"]]
  )

  tables_with_na_lgl <- unlist(
    lapply(
      tables_list,
      function(x) any(!stats::complete.cases(x))
    )
  )

  tables_with_na_names <- names(tables_with_na_lgl[tables_with_na_lgl])

  tables_with_blanks_reason <-
    tables_sheets[!is.na(tables_sheets$blank_cells), ][["tab_title"]]

  tables_with_na_no_reason <-
    setdiff(tables_with_na_names, tables_with_blanks_reason)

  tables_with_reason_no_na <-
    setdiff(tables_with_blanks_reason, tables_with_na_names)

  if (length(tables_with_na_no_reason) > 0) {
    warning(
      "You have blank cells in these tables but haven't provided a reason: ",
      paste(tables_with_na_no_reason, collapse = ", "), ".",
      call. = FALSE
    )
  }

  if (length(tables_with_reason_no_na) > 0) {
    warning(
      paste(
        "There's no blank cells in these tables,",
        "but you've provided a reason for blank cells: "
      ),
      paste(tables_with_reason_no_na, collapse = ", "), ".",
      call. = FALSE
    )
  }





}
