
.style_create <- function() {

  list(
    bold   = openxlsx::createStyle(textDecoration = "Bold"),
    pt14  = openxlsx::createStyle(fontSize = 14),
    pt16  = openxlsx::createStyle(fontSize = 16),
    ralign = openxlsx::createStyle(halign = "right"),
    row_height = openxlsx::createStyle(halign = "right"),
    wrap   = openxlsx::createStyle(wrapText = TRUE)
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

  tab_name <- "cover"
  table <- content[content$tab_title == "cover", "table"][[1]][[1]]
  table_height <- nrow(table)

  # Cover columns are SET-WIDTH and WRAPPED

  openxlsx::setColWidths(
    wb = wb,
    sheet = tab_name,
    cols = 1,
    widths = 100
  )

  openxlsx::addStyle(
    wb = wb,
    sheet = tab_name,
    rows = seq(table_height + 1), # include sheet title
    cols = 1,
    style = style_ref$wrap,
    stack = TRUE
  )

  # Subheader rows are also have LARGER ROW HEIGHT, are BOLD and 14PT

  subheader_rows <- seq(3, table_height, 2)

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

  table <- content[content$table_name == table_name, "table"][[1]][[1]]
  tab_title <- content[content$table_name == table_name, "tab_title"][[1]]
  sheet_type <- content[content$table_name == table_name, "sheet_type"][[1]]
  table_height <- nrow(table)
  table_width <- ncol(table)

  if (sheet_type == "meta") table_header_row <- 3
  if (sheet_type == "tables") table_header_row <- 4

  # Table data columns are SET-WIDTH, WRAPPED and RIGHT ALIGNED

  openxlsx::setColWidths(
    wb = wb,
    sheet = tab_title,
    cols = seq(table_width),
    widths = 16
  )

  openxlsx::addStyle(
    wb = wb,
    sheet = tab_title,
    rows = table_header_row,
    cols = seq(table_width),
    style = style_ref$wrap,
    stack = TRUE
  )

  openxlsx::addStyle(
    wb = wb,
    sheet = tab_title,
    rows = seq(table_header_row, table_header_row + table_height),
    cols = seq(table_width)[-1],  # assumes first col is row labels
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
