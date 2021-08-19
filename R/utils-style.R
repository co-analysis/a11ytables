# Title [B,S]
# Table count/note presence [None]
# Source [None]
# Subtable title [B]
# Table header [B,R,W]
# Table [B,R,W]


.style_create <- function() {

  list(
    bold   = openxlsx::createStyle(textDecoration = "Bold"),
    large  = openxlsx::createStyle(fontSize = 16),
    ralign = openxlsx::createStyle(halign = "right"),
    wrap   = openxlsx::createStyle(wrapText = TRUE)
  )

}

.style_workbook <- function(wb) {

  openxlsx::modifyBaseFont(
    wb,
    fontSize = 12,
    fontName = "Arial"
  )

  return(wb)

}

.style_sheet_title <- function(wb, tab_title, style_ref) {

  # Sheet titles are BOLD and have LARGER FONT SIZE

  openxlsx::addStyle(
    wb,
    sheet = tab_title,
    rows = 1,  # will always be cell A1
    cols = 1,
    style = style_ref$bold,
    stack = TRUE
  )

  openxlsx::addStyle(
    wb,
    sheet = tab_title,
    rows = 1,  # will always be cell A1
    cols = 1,
    style = style_ref$large,
    stack = TRUE
  )

  return(wb)

}

.style_table <- function(wb, content, table_name, style_ref) {

  table <- content[content$table_name == table_name, "table"][[1]][[1]]
  tab_title <- content[content$table_name == table_name, "tab_title"][[1]]
  table_header_row <- 4
  table_height <- nrow(table)
  table_width <- ncol(table)

  # Table data columns are SET-WIDTH, WRAPPED and RIGHT ALIGNED

  openxlsx::setColWidths(
    wb,
    sheet = tab_title,
    cols = seq(table_width),
    widths = 16
  )

  openxlsx::addStyle(
    wb,
    sheet = tab_title,
    rows = table_header_row,
    cols = seq(table_width),
    style = style_ref$wrap,
    stack = TRUE
  )

  openxlsx::addStyle(
    wb,
    sheet = tab_title,
    rows = seq(table_header_row, table_header_row + table_height),
    cols = seq(table_width)[-1],  # assumes first col is row labels
    gridExpand = TRUE,
    style = style_ref$ralign,
    stack = TRUE
  )

  # Table headers are also BOLD

  openxlsx::addStyle(
    wb,
    sheet = tab_title,
    rows = table_header_row,
    cols = seq(table_width),
    style = style_ref$bold,
    stack = TRUE
  )


  return(wb)

}
