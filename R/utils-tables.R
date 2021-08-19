.stop_bad_input <- function(wb, contents, table_name = NULL) {

  if (class(wb)[1] != "Workbook") {
    stop("'wb' must be a Workbook-class object.")
  }

  if (!any(class(contents) %in% "data.frame")) {
    stop("'contents' must have class data.frame.")
  }

  if (!is.null(table_name) &
      class(table_name) != "character" &
      length(table_name != 1)
  ) {
    stop("'table_name' must be a string of length 1")
  }

}

.insert_title <- function(wb, content, tab_title) {

  sheet_title <- content[content$tab_title == tab_title, "sheet_title"][[1]]

  if (content[content$tab_title == tab_title, "sheet_type"][[1]] == "tables") {
    sheet_title <- paste0("Worksheet ", tab_title, ": ", sheet_title)
  }

  openxlsx::writeData(
    wb = wb,
    sheet = tab_title,
    x = sheet_title,
    startCol = 1,
    startRow = 1,
    colNames = TRUE
  )

  return(wb)

}

.insert_source <- function(wb, content, tab_title) {

  text <- paste(
    "Source:",
    content[content$tab_title == tab_title, "source"][[1]]
  )

  openxlsx::writeData(
    wb = wb,
    sheet = tab_title,
    x = text,
    startCol = 1,
    startRow = 3,
    colNames = TRUE
  )

  return(wb)

}

.insert_prelim_a11y <- function(wb, content, tab_title) {

  table_count <- nrow(content[content$tab_title == tab_title, ])
  has_notes <- any(
    grepl(
      "[note [0-9]{1,3}]",
      names(
        content[content$tab_title == tab_title, "table"][[1]][[1]]
      )
    )
  )

  text <- paste("This worksheet contains", table_count, "table.")

  if (has_notes) {

    text <- paste(
      text,
      "Some cells refer to notes which can be found on the notes worksheet."
    )

  }

  openxlsx::writeData(
    wb = wb,
    sheet = tab_title,
    x = text,
    startCol = 1,
    startRow = 2,
    colNames = TRUE
  )

  return(wb)

}

.insert_table <- function(wb, content, table_name, subtable_num = NULL) {

  table <- content[content$table_name == table_name, "table"][[1]][[1]]
  tab_title <- content[content$table_name == table_name, "tab_title"][[1]]

  if (tab_title == "cover") { start_row <- 2 }
  if (tab_title %in% c("contents", "notes")) { start_row <- 3 }
  if (!tab_title %in% c("cover", "contents", "notes")) { start_row <- 4 }

  if (tab_title == "cover") {

    openxlsx::writeData(
      wb = wb,
      sheet = tab_title,
      x = table,
      startCol = 1,
      startRow = start_row,
      colNames = FALSE  # assumes cover df uses a dummy header
    )

  }

  if (tab_title != "cover") {

    openxlsx::writeDataTable(
      wb = wb,
      sheet = tab_title,
      x = table,
      tableName = table_name,
      startCol = 1,
      startRow = start_row,
      colNames = TRUE,
      tableStyle = "none",
      withFilter = FALSE,
      bandedRows = FALSE
    )

  }

  return(wb)

}

