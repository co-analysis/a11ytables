#' Insert 'a11ytable' Template
#'
#' Insert at the cursor a template for \code{\link{create_a11ytable}} from the
#' 'a11ytable' package, pre-filled with example information.
#'
#' @export
at_template_a11ytable <- function() {
  rstudioapi::insertText(string_create_a11ytable())
}

#' Insert Table Templates Using 'tibble'
#'
#' Insert at the cursor templates for cover, contents and notes tables,
#' pre-filled with example information. Requires the 'tibble' package to be
#' installed.
#'
#' @export
at_template_tibble <- function() {
  rstudioapi::insertText(string_tables_tibble())
}

#' Insert Table Templates Using 'data.frame'
#'
#' Insert at the cursor templates for cover, contents and notes
#' tables, pre-filled with example information. Uses \code{\link{data.frame}},
#' so isn't dependent on external packages.
#'
#' @export
at_template_df <- function() {
  rstudioapi::insertText(string_tables_df())
}

#' Insert Full 'a11ytables' Template Workflow
#'
#' Insert at the cursor templates for cover, contents and notes
#' tables, and \code{\link{create_a11ytable}}, which are all pre-filled with
#' example information.
#'
#' @export
at_template_workflow <- function() {

  rstudioapi::insertText(
    paste0(
      "# Prepare tables",
      "\n\n",
      string_tables_tibble(),
      "\n\n",
      "# Create new a11ytable",
      "\n\n",
      string_create_a11ytable(),
      "\n\n",
      "# Generate workbook from a11ytable",
      "\n\n",
      "wb_example <- a11ytables::generate_workbook(a11y_example)",
      "\n\n",
      "# Create output",
      "\n\n",
      "openxlsx::openXL(wb_example)  # open temp copy",
      "\n\n",
      'openxlsx::saveWorkbook(wb_example, "~/Desktop/example.xlsx")'
    )
  )

}
