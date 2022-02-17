#' Labour Market Overview Tables (Including Sub-tables)
#'
#' A dataset containing selected content from the Labour Market Overview Tables
#' publication (UK, December 2020), published by the Office for National
#' Statistics as a demonstration of good practice for releasing statistics in
#' spreadsheets (June 2021). See \code{\link{lfs_tables}} for a version
#' without sub-tables.
#'
#' @format A data frame with 6 rows and 7 columns:
#' \describe{
#'   \item{tab_title}{Character. Text to appear on the sheet's tab.}
#'   \item{sheet_type}{Character. Either 'cover', 'contents', 'notes', or 'tables'.}
#'   \item{sheet_title}{Character. Title that will appear in the top-left of each sheet}
#'   \item{subtable_num}{Character. A letter. Identifier for tables when there's more than one per sheet.}
#'   \item{subtable_title}{Character. A name to place above the table if there's more than one table per sheet.}
#'   \item{source}{Character. The origin of the data.}
#'   \item{table_name}{Character. A name applied to the marked-up table.}
#'   \item{table}{List containing dataframes/tibbles. Rectangular table containing the data.}
#' }
#'
#' @details The object is a data.frame and is formatted for easy coercion to
#'     a11ytable class with \code{\link{as_a11ytable}}.
#'
#' @source \url{https://gss.civilservice.gov.uk/policy-store/releasing-statistics-in-spreadsheets/}
"lfs_subtables"

#' Labour Market Overview Tables
#'
#' A dataset containing selected content from the Labour Market Overview Tables
#' publication (UK, December 2020), published by the Office for National
#' Statistics as a demonstration of good practice for releasing statistics in
#' spreadsheets (June 2021). See \code{\link{lfs_subtables}} for a version
#' with sub-tables.
#'
#' @format A data frame with 5 rows and 7 columns:
#' \describe{
#'   \item{tab_title}{Character. Text to appear on the sheet's tab.}
#'   \item{sheet_type}{Character. Either 'cover', 'contents', 'notes', or 'tables'.}
#'   \item{sheet_title}{Character. Title that will appear in the top-left of each sheet}
#'   \item{source}{Character. The origin of the data.}
#'   \item{table_name}{Character. A name applied to the marked-up table.}
#'   \item{table}{List containing dataframes/tibbles. Rectangular table containing the data.}
#' }
#'
#' @details The object is a data.frame and is formatted for easy coercion to
#'     a11ytable class with \code{\link{as_a11ytable}}.
#'
#' @source \url{https://gss.civilservice.gov.uk/policy-store/releasing-statistics-in-spreadsheets/}
"lfs_tables"
