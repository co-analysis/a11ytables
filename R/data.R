#' Test Data: A Modified 'mtcars' Dataframe
#'
#' A modified version of the mtcars dataset prepared into a data.frame structure
#' ready for coercion to an a11ytables-class object with
#' \code{\link{as_a11ytable}}.
#'
#' @format A data frame with 5 rows and 7 columns:
#' \describe{
#'   \item{tab_title}{Character. Text to appear on the sheet's tab.}
#'   \item{sheet_type}{Character. The content type for each sheet: 'cover', 'contents', 'notes', or 'tables'.}
#'   \item{sheet_title}{Character. The title that will appear in the top-left of each sheet.}
#'   \item{blank_cells}{Character. An explanation for any blank cells in the table.}
#'   \item{source}{Character. The origin of the data, if relevant.}
#'   \item{table}{List-column of data.frames containing the statistical tables.}
#' }
#'
#' @source \code{\link[datasets:mtcars]{mtcars}}
"mtcars_df"
