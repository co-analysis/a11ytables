#' Add Named Tabs to a Workbook
#'
#' After creating a new empty workbook you need to add named tabs for the
#' sheets.
#'
#' @param wb A Workbook-class object created by \link[openxlsx]{createWorkbook}
#' @param content A data.frame-class object containing your data.
#'
#' @details The 'content' object should adhere to the form demonstrated in
#'     \code{\link{lfs_tables}}
#'
#' @return A Workbook-class object.
#' @export
#'
#' @examples \dontrun{openxlsx::createWorkbook() %>% add_tabs(content)}
add_tabs <- function(wb, content) {

  purrr::walk(
    unique(content$tab_title),
    ~ openxlsx::addWorksheet(wb, .x)
  )

  return(wb)

}

#' Add a Cover Page Sheet to a Workbook
#'
#' After creating a new empty workbook and named tabs, you need to add a cover
#' sheet
#'
#' @param wb A Workbook-class object created by \link[openxlsx]{createWorkbook}
#' @param content A data.frame-class object containing your data.
#'
#' @details The 'content' object should adhere to the form demonstrated in
#'     \code{\link{lfs_tables}}
#'
#' @return A Workbook-class object.
#' @export
#'
#' @examples \dontrun{
#' openxlsx::createWorkbook() %>%
#'   add_tabs(content) %>%
#'   add_cover(content)}
add_cover <- function(wb, content) {

  tab_title <- "cover"
  table_name <- content[content$tab_title == "cover", "table_name"][[1]]

  .insert_title(wb, content, tab_title)
  .insert_table(wb, content, table_name)

  styles <- .style_create()
  .style_workbook(wb)
  .style_sheet_title(wb, tab_title, styles)
  .style_cover(wb, content, styles)

  return(wb)

}

#' Add a Table of Contents Sheet to a Workbook
#'
#' After creating a new empty workbook, named tabs and a cover sheet, you need
#' to add a table-of-contents sheet
#'
#' @param wb A Workbook-class object created by \link[openxlsx]{createWorkbook}
#' @param content A data.frame-class object containing your data.
#'
#' @details The 'content' object should adhere to the form demonstrated in
#'     \code{\link{lfs_tables}}
#'
#' @return A Workbook-class object.
#' @export
#'
#' @examples \dontrun{
#' openxlsx::createWorkbook() %>%
#'   add_tabs(content) %>%
#'   add_cover(content) %>%
#'   add_contents(content)}
add_contents <- function(wb, content) {

  tab_title <- "contents"
  table_name <- content[content$tab_title == "contents", "table_name"][[1]]

  .insert_title(wb, content, tab_title)
  .insert_prelim_a11y(wb, content, tab_title)
  .insert_table(wb, content, table_name)

  styles <- .style_create()
  .style_workbook(wb)
  .style_sheet_title(wb, tab_title, styles)
  .style_table(wb, content, table_name, styles)

  return(wb)

}

#' Add a Notes Sheet to a Workbook
#'
#' After creating a new empty workbook, named tabs, a cover sheet and a
#' table-of-contents sheet, you can add a notes sheet (optional, only needed if
#' there are any notes in teh workbook).
#'
#' @param wb A Workbook-class object created by \link[openxlsx]{createWorkbook}
#' @param content A data.frame-class object containing your data.
#'
#' @details The 'content' object should adhere to the form demonstrated in
#'     \code{\link{lfs_tables}}
#'
#' @return A Workbook-class object.
#' @export
#'
#' @examples \dontrun{
#' openxlsx::createWorkbook() %>%
#'   add_tabs(content) %>%
#'   add_cover(content) %>%
#'   add_contents(content) %>%
#'   add_notes(content)}
add_notes <- function(wb, content) {

  tab_title <- "notes"
  table_name <- content[content$tab_title == "notes", "table_name"][[1]]

  .insert_title(wb, content, tab_title)
  .insert_prelim_a11y(wb, content, tab_title)
  .insert_table(wb, content, table_name)

  styles <- .style_create()
  .style_workbook(wb)
  .style_sheet_title(wb, tab_title, styles)
  .style_table(wb, content, table_name, styles)

  return(wb)

}

#' Add a Table Sheet to a Workbook
#'
#' After creating a new empty workbook, named tabs, a cover sheet, a
#' table-of-contents sheet and a notes sheet (optional), you should add the
#' tables of data.
#'
#' @param wb A Workbook-class object created by \link[openxlsx]{createWorkbook}
#' @param content A data.frame-class object containing your data.
#' @param table_name Character. The name of the table, which is used to filter
#'     the relevant data from the object in the content argument.
#'
#' @details The 'content' object should adhere to the form demonstrated in
#'     \code{\link{lfs_tables}}
#'
#' @return A Workbook-class object.
#' @export
#'
#' @examples \dontrun{
#' openxlsx::createWorkbook() %>%
#'   add_tabs(content) %>%
#'   add_cover(content) %>%
#'   add_contents(content) %>%
#'   add_notes(content) %>%
#'   add_tables(content, "1a")}
add_tables <- function(wb, content, table_name) {

  tab_title <- content[content$table_name == table_name, "tab_title"][[1]]

  .insert_title(wb, content, tab_title)
  .insert_prelim_a11y(wb, content, tab_title)
  .insert_source(wb, content, tab_title)
  .insert_table(wb, content, table_name)

  styles <- .style_create()
  .style_workbook(wb)
  .style_sheet_title(wb, tab_title, styles)
  .style_table(wb, content, table_name, styles)

  return(wb)

}
