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
  sheet <- content[content$table_name == table_name, "tab_title"][[1]]

  if (sheet == "cover") start_row <- 2
  if (sheet %in% c("contents", "notes")) start_row <- 3
  if (!sheet %in% c("cover", "contents", "notes")) start_row <- 4

  openxlsx::writeDataTable(
    wb = wb,
    sheet = sheet,
    x = table,
    tableName = table_name,
    startCol = 1,
    startRow = start_row,
    colNames = TRUE,
    tableStyle = "none",
    withFilter = FALSE,
    bandedRows = FALSE
  )

  return(wb)

}

