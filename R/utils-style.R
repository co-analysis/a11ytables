
.style_create <- function() {

  list(
    bold       = openxlsx::createStyle(textDecoration = "Bold"),
    lalign     = openxlsx::createStyle(halign = "left"),
    pt14       = openxlsx::createStyle(fontSize = 14),
    pt16       = openxlsx::createStyle(fontSize = 16),
    ralign     = openxlsx::createStyle(halign = "right"),
    row_height = openxlsx::createStyle(halign = "right"),
    wrap       = openxlsx::createStyle(wrapText = TRUE)
  )

}

.style_workbook <- function(wb) {

  openxlsx::modifyBaseFont(
    wb = wb,
    fontSize = 12,
    fontName = "Arial"
  )

  return(wb)

}

.style_sheet_title <- function(wb, tab_title, style_ref) {

  # Sheet titles are BOLD and 16PT

  openxlsx::addStyle(
    wb = wb,
    sheet = tab_title,
    rows = 1,  # will always be cell A1
    cols = 1,
    style = style_ref$bold,
    stack = TRUE
  )

  openxlsx::addStyle(
    wb = wb,
    sheet = tab_title,
    rows = 1,  # will always be cell A1
    cols = 1,
    style = style_ref$pt16,
    stack = TRUE
  )

  return(wb)

}

.style_cover <- function(wb, content, style_ref) {

  tab_name <- content[content$sheet_type == "cover", "tab_title"][[1]]
  table <- content[content$sheet_type == "cover", "table"][[1]]
  table_height <- nrow(table)

  # The cover column is SET-WIDTH and WRAPPED

  openxlsx::setColWidths(
    wb = wb,
    sheet = tab_name,
    cols = 1,
    widths = 80
  )

  openxlsx::addStyle(
    wb = wb,
    sheet = tab_name,
    rows = seq(table_height * 2 + 1), # include sheet title
    cols = 1,
    style = style_ref$wrap,
    stack = TRUE
  )

  # Subheader rows are also have LARGER ROW HEIGHT, are BOLD and 14PT

  subheader_rows <- seq(2, table_height * 2, 2)

  openxlsx::setRowHeights(
    wb = wb,
    sheet = tab_name,
    rows = subheader_rows,
    heights = 34
  )

  openxlsx::addStyle(
    wb = wb,
    sheet = tab_name,
    rows = subheader_rows,
    cols = 1,
    style = style_ref$bold,
    stack = TRUE
  )

  openxlsx::addStyle(
    wb = wb,
    sheet = tab_name,
    rows = subheader_rows,
    cols = 1,
    style = style_ref$pt14,
    stack = TRUE
  )

  return(wb)

}

.style_table <- function(wb, content, table_name, style_ref) {

  table <- content[content$table_name == table_name, "table"][[1]]
  tab_title <- content[content$table_name == table_name, "tab_title"][[1]]
  sheet_type <- content[content$table_name == table_name, "sheet_type"][[1]]

  has_notes <- .has_notes(content, tab_title)
  has_source <- .has_source(content, tab_title)
  start_row <- .get_start_row_table(has_notes, has_source)

  table_height <- nrow(table)
  table_width  <- ncol(table)

  cellwidth_default <- 16
  cellwidth_wider <- 32
  # nchar_break <- 50  # TODO: fix colwidth breaking

  # Some columns may contain numbers but have suppression text in them, e.g.
  # '[c]', which makes the column character class. Find the likely numeric cols.
  suppressWarnings(  # coercion to numeric may trigger a warning
    likely_num_cols <-
      names(  # return names of columns that are most likely numeric
        Filter(
          isTRUE,  # isolate the columns that are likely numeric
          lapply(
            lapply(table, as.numeric),  # coerce cols to numeric
            function(x) any(!is.na(x))  # at least one number after coercion?
          )
        )
      )
  )

  # Get the index of columns that are likely numeric, so styles can be applied
  num_cols_index <- which(names(table) %in% likely_num_cols)

  if (sheet_type %in% c("cover", "contents", "notes")) {
    table_header_row <- 3
  }

  if (sheet_type == "tables") {
    table_header_row <- start_row
  }

  # # Columns that should be wider than default  # TODO: fix colwidth breaking
  # wide_cells <- names(Filter(function(x) max(nchar(x)) > nchar_break, table))
  # wide_cells_index <- which(names(table) %in% wide_cells)
  # wide_headers_index <- which(nchar(names(table)) > 50)
  # wide_cols_index <- c(wide_cells_index, wide_headers_index)

  # Table data columns are SET-WIDTH (depending on character length),
  # RIGHT-ALIGNED (if numeric) and WRAPPED

  openxlsx::setColWidths(
    wb = wb,
    sheet = tab_title,
    cols = seq(table_width),
    widths = cellwidth_default  # set all columns to default width first
  )

  # openxlsx::setColWidths(  # TODO: fix colwidth breaking
  #   wb = wb,
  #   sheet = tab_title,
  #   cols = wide_cols_index,
  #   widths = cellwidth_wider  # apply larger width to certain columns
  # )

  openxlsx::addStyle(
    wb = wb,
    sheet = tab_title,
    rows = seq(table_header_row, table_header_row + table_height),
    cols = seq(table_width),
    gridExpand = TRUE,
    style = style_ref$wrap,
    stack = TRUE
  )

  openxlsx::addStyle(
    wb = wb,
    sheet = tab_title,
    rows = seq(table_header_row, table_header_row + table_height),
    cols = num_cols_index,  # right-align numeric columns only
    gridExpand = TRUE,
    style = style_ref$ralign,
    stack = TRUE
  )

  # Table headers are also BOLD

  openxlsx::addStyle(
    wb = wb,
    sheet = tab_title,
    rows = table_header_row,
    cols = seq(table_width),
    style = style_ref$bold,
    stack = TRUE
  )

  return(wb)

}

.style_contents <- function(wb, content, style_ref) {

  tab_name <- content[content$sheet_type == "contents", "tab_title"][[1]]
  table <- content[content$sheet_type == "contents", "table"][[1]]
  table_height <- nrow(table)
  table_width <- ncol(table)

  # Contents columns are SET-WIDTH, WRAPPED and LEFT ALIGNED

  openxlsx::setColWidths(
    wb = wb,
    sheet = tab_name,
    cols = seq(table_width),
    widths = 30
  )

  openxlsx::addStyle(
    wb = wb,
    sheet = tab_name,
    rows = seq(table_height + 1) + 2,
    cols = seq(table_width),
    gridExpand = TRUE,
    style = style_ref$wrap,
    stack = TRUE
  )

  openxlsx::addStyle(
    wb = wb,
    sheet = tab_name,
    rows = seq(table_height + 1) + 2,
    cols = seq(table_width),
    gridExpand = TRUE,
    style = style_ref$lalign,
    stack = TRUE
  )

}


.style_notes <- function(wb, content, style_ref) {

  tab_name <- content[content$sheet_type == "notes", "tab_title"][[1]]
  table <- content[content$sheet_type == "notes", "table"][[1]]
  table_height <- nrow(table)
  table_width <- ncol(table)

  # Notes columns are SET-WIDTH, WRAPPED and LEFT ALIGNED

  openxlsx::setColWidths(
    wb = wb,
    sheet = tab_name,
    cols = 1,
    widths = 15
  )

  openxlsx::setColWidths(
    wb = wb,
    sheet = tab_name,
    cols = 2,
    widths = 80
  )

  openxlsx::addStyle(
    wb = wb,
    sheet = tab_name,
    rows = seq(table_height + 1) + 2,
    cols = seq(table_width),
    gridExpand = TRUE,
    style = style_ref$wrap,
    stack = TRUE
  )

  openxlsx::addStyle(
    wb = wb,
    sheet = tab_name,
    rows = seq(table_height + 1) + 2,
    cols = seq(table_width),
    gridExpand = TRUE,
    style = style_ref$lalign,
    stack = TRUE
  )

}
