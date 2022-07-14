
# Validate ----------------------------------------------------------------


.stop_bad_input <- function(wb, content, table_name = NULL) {

  if (class(wb)[1] != "Workbook") {
    stop("'wb' must be a Workbook-class object.")
  }

  if (!is.null(table_name) &
      class(table_name) != "character" &
      length(table_name != 1)
  ) {
    stop("'table_name' must be a string of length 1")
  }

}


# Detect meta elements ----------------------------------------------------


.has_blanks_message <- function(content, tab_title) {

  blank_cells_message <- content[content$tab_title == tab_title, "blank_cells"][[1]]

  if (!is.na(blank_cells_message)) {
    TRUE
  } else {
    FALSE
  }

}

.has_source <- function(content, tab_title) {

  table_source <- content[content$tab_title == tab_title, "source"][[1]]

  if (!is.na(table_source)) {
    TRUE
  } else {
    FALSE
  }

}

.has_notes <- function(content, tab_title) {

  table_names <- names(content[content$tab_title == tab_title, "table"][[1]])

  has_header_notes <- any(grepl("(?<=\\[).*(?=\\])", table_names, perl = TRUE))

  has_notes_column <- any(tolower(table_names) %in% "notes")

  any(has_header_notes, has_notes_column)

}

.extract_note_values <- function(content, tab_title) {

  has_notes <- .has_notes(content, tab_title)

  if (has_notes) {  # if there are notes in this table

    # Isolate named table dataframe

    table <- content[content$tab_title == tab_title, "table"][[1]]

    # Vector with potential note values, e.g. '[1, 2]' to c(1, 2)

    table_names <- names(table)
    notes_column_index <- which(tolower(table_names) %in% "notes")
    notes_column_content <- table[, notes_column_index]

    possible_note_text <- c(table_names, notes_column_content)

    square_bracket_contents <- unlist(
      regmatches(
        possible_note_text,
        gregexpr("(?<=\\[).*(?=\\])", possible_note_text, perl = TRUE)
      )
    )

    sort(
      as.numeric(
        unique(
          unlist(
            lapply(
              square_bracket_contents,
              function(x) unlist(regmatches(x, gregexpr("\\d", x, perl = TRUE)))
            )
          )
        )
      )
    )

  }

}


# Table placement ---------------------------------------------------------


.get_start_row_blanks_message <- function(has_notes, start_row = 3) {

  if (has_notes) {
    start_row <- start_row + 1
  }

  return(start_row)

}

.get_start_row_source <- function(
  has_notes,
  has_blanks_message,
  start_row = 3
) {

  if (has_notes) {
    start_row <- start_row + 1
  }

  if (has_blanks_message) {
    start_row <- start_row + 1
  }

  return(start_row)

}

.get_start_row_table <- function(
  has_notes,
  has_blanks_message,
  has_source,
  start_row = 3
) {

  if (has_notes) {
    start_row <- start_row + 1
  }

  if (has_blanks_message) {
    start_row <- start_row + 1
  }

  if (has_source) {
    start_row <- start_row + 1
  }

  return(start_row)

}


# Insert sheet elements ---------------------------------------------------


.insert_title <- function(wb, content, tab_title) {

  sheet_type <- content[content$tab_title == tab_title, "sheet_type"][[1]]
  sheet_title <- content[content$tab_title == tab_title, "sheet_title"][[1]]

  if (sheet_type %in% c("cover", "contents", "notes")) {

    openxlsx::writeData(
      wb = wb,
      sheet = tab_title,
      x = sheet_title,
      startCol = 1,
      startRow = 1,
      colNames = TRUE
    )

  }

  if (sheet_type == "tables") {

    openxlsx::writeData(
      wb = wb,
      sheet = tab_title,
      x = sheet_title,
      startCol = 1,
      startRow = 1,
      colNames = TRUE
    )

  }

  return(wb)

}

.insert_table_count <- function(wb, content, tab_title) {

  table_count <- nrow(content[content$tab_title == tab_title, ])

  text <- paste(
    "This worksheet contains", table_count,
    ifelse(table_count == 1, "table.", "tables.")
  )

  openxlsx::writeData(
    wb = wb,
    sheet = tab_title,
    x = text,
    startCol = 1,
    startRow = 2,  # table count will always be the second row
    colNames = TRUE
  )

  return(wb)

}

.insert_notes_statement <- function(wb, content, tab_title) {

  has_notes <- .has_notes(content, tab_title)

  if (has_notes) {

    text <-
      "This table contains notes, which can be found in the Notes worksheet."

    openxlsx::writeData(
      wb = wb,
      sheet = tab_title,
      x = text,
      startCol = 1,
      startRow = 3,  # notes will always go in row 3 if they exist
      colNames = TRUE
    )

  }

  return(wb)

}

.insert_blanks_message <- function(wb, content, tab_title) {

  has_blanks_message <- .has_blanks_message(content, tab_title)

  if (has_blanks_message) {

    blanks_text <- content[content$tab_title == tab_title, "blank_cells"][[1]]

    # last_char <- strsplit(blanks_text, "")[[1]][nchar(blanks_text)]
    #
    # if (last_char == ".") {
    #   text <- blanks_text
    # }
    #
    # if (last_char != ".") {
    #   text <- paste0(blanks_text, ".")
    # }

    has_notes <- .has_notes(content, tab_title)
    start_row <- .get_start_row_blanks_message(has_notes)

    openxlsx::writeData(
      wb = wb,
      sheet = tab_title,
      x = blanks_text,
      startCol = 1,
      startRow = start_row,  # dependent on whether notes text present
      colNames = TRUE
    )

  }

  return(wb)

}

.insert_source <- function(wb, content, tab_title) {

  has_source <- .has_source(content, tab_title)

  if (has_source) {

    source_text <- paste(
      "Source:",
      content[content$tab_title == tab_title, "source"][[1]]
    )

    # last_char <- strsplit(source_text, "")[[1]][nchar(source_text)]
    #
    # if (last_char == ".") {
    #   text <- paste("Source:", source_text)
    # }
    #
    # if (last_char != ".") {
    #   text <- paste0("Source: ", source_text, ".")
    # }

    has_notes <- .has_notes(content, tab_title)
    has_blanks_message <- .has_blanks_message(content, tab_title)
    start_row <- .get_start_row_source(has_notes, has_blanks_message)

    openxlsx::writeData(
      wb = wb,
      sheet = tab_title,
      x = source_text,
      startCol = 1,
      startRow = start_row,  # dependent on whether notes text present
      colNames = TRUE
    )

  }

  return(wb)

}

.insert_table <- function(wb, content, table_name) {

  table <- content[content$table_name == table_name, ][["table"]][[1]]
  sheet_type <- content[content$table_name == table_name, "sheet_type"][[1]]
  tab_title <- content[content$table_name == table_name, "tab_title"][[1]]

  if (sheet_type == "cover") {

    table <- data.frame(cover_content = as.vector(t(table)))

    openxlsx::writeData(
      wb = wb,
      sheet = tab_title,
      x = table,
      startCol = 1,
      startRow = 2,
      colNames = FALSE  # because cover df uses dummy column headers
    )

  }

  if (sheet_type != "cover") {

    has_notes <- .has_notes(content, tab_title)
    has_blanks_message <- .has_blanks_message(content, tab_title)
    has_source <- .has_source(content, tab_title)

    if (sheet_type %in% c("contents", "notes")) {
      start_row <- 3
    }

    if (sheet_type == "tables") {
      start_row <- .get_start_row_table(
        has_notes,
        has_blanks_message,
        has_source
      )
    }

    openxlsx::writeDataTable(
      wb = wb,
      sheet = tab_title,
      x = table,
      tableName = table_name,
      startCol = 1,
      startRow = start_row,  # dependent on whether notes or source text present
      colNames = TRUE,
      tableStyle = "none",
      withFilter = FALSE,
      bandedRows = FALSE
    )

  }

  return(wb)

}


# Add sheets to workbook --------------------------------------------------


.add_tabs <- function(wb, content) {

  .stop_bad_input(wb, content)

  for (i in unique(content$tab_title)) {
    openxlsx::addWorksheet(wb, i)
  }

  return(wb)

}

.add_cover <- function(wb, content) {

  .stop_bad_input(wb, content)

  tab_title <- content[content$sheet_type == "cover", "tab_title"][[1]]
  table_name <- content[content$sheet_type == "cover", "table_name"][[1]]

  .insert_title(wb, content, tab_title)
  .insert_table(wb, content, table_name)

  styles <- .style_create()
  .style_workbook(wb)
  .style_sheet_title(wb, tab_title, styles)
  .style_cover(wb, content, styles)

  return(wb)

}


.add_contents <- function(wb, content) {

  .stop_bad_input(wb, content)

  tab_title <- content[content$sheet_type == "contents", "tab_title"][[1]]
  table_name <- content[content$sheet_type == "contents", "table_name"][[1]]


  .insert_title(wb, content, tab_title)
  .insert_table_count(wb, content, tab_title)
  .insert_table(wb, content, table_name)

  styles <- .style_create()
  .style_workbook(wb)
  .style_sheet_title(wb, tab_title, styles)
  .style_table(wb, content, table_name, styles)
  .style_contents(wb, content, styles)

  return(wb)

}


.add_notes <- function(wb, content) {

  .stop_bad_input(wb, content)

  tab_title <- content[content$sheet_type == "notes", "tab_title"][[1]]
  table_name <- content[content$sheet_type == "notes", "table_name"][[1]]

  .insert_title(wb, content, tab_title)
  .insert_table_count(wb, content, tab_title)
  .insert_table(wb, content, table_name)

  styles <- .style_create()
  .style_workbook(wb)
  .style_sheet_title(wb, tab_title, styles)
  .style_table(wb, content, table_name, styles)
  .style_notes(wb, content, styles)

  return(wb)

}

.add_tables <- function(wb, content, table_name) {

  .stop_bad_input(wb, content, table_name)

  tab_title <- content[content$table_name == table_name, "tab_title"][[1]]

  .insert_title(wb, content, tab_title)
  .insert_table_count(wb, content, tab_title)
  .insert_source(wb, content, tab_title)
  .insert_notes_statement(wb, content, tab_title)
  .insert_blanks_message(wb, content, tab_title)
  .insert_table(wb, content, table_name)

  styles <- .style_create()
  .style_workbook(wb)
  .style_sheet_title(wb, tab_title, styles)
  .style_table(wb, content, table_name, styles)

  return(wb)

}
