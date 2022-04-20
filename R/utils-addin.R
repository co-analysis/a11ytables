string_new_a11ytable <- function() {

  'a11y_example <- a11ytables::new_a11ytable(
      tab_titles = c(
        "Cover",
        "Contents",
        "Notes",
        "Table 1"
      ),
      sheet_types = c(
        "cover",
        "contents",
        "notes",
        "tables"
      ),
      sheet_titles = c(
        "Cover title (example)",
        "Contents",
        "Notes",
        "Sheet title (example)"
      ),
      sources = c(
        NA_character_,
        NA_character_,
        NA_character_,
        "Source (example)"
      ),
      tables = list(
        cover_example,
        contents_example,
        notes_example,
        table_example
      )
    )'

}

string_tables_tibble <- function() {

  'cover_example <- tibble::tribble(
    ~subsection_title, ~subsection_body,
    "Purpose", "Example results for something.",
    "Workbook properties", "Some placeholder information.",
    "Contact", "Placeholder email"
  )

  contents_example <- tibble::tribble(
    ~"Sheet name", ~"Sheet title",
    "Notes", "Notes",
    "Table 1", "Sheet title (example)"
  )

  notes_example <- tibble::tribble(
    ~"Note number", ~"Note text",
    "[note 1]", "Placeholder note."
  )

  table_example <- mtcars
  table_example[["car [note 1]"]] <- row.names(mtcars)
  row.names(table_example) <- NULL
  table_example <- table_example[1:5, c("car [note 1]", "mpg", "cyl")]'

}

string_tables_df <- function() {
  'cover_example <- data.frame(
      subsection_title = c(
        "Purpose",
        "Workbook properties",
        "Contact"
      ),
      subsection_body = c(
        "Example results for something.",
        "Some placeholder information.",
        "Placeholder email"
      ),
      check.names = FALSE
    )

    contents_example <- data.frame(
      "Sheet name" = c("Notes", "Table 1"),
      "Sheet title" = c("Notes", "Sheet title (example)"),
      check.names = FALSE
    )

    notes_example <- data.frame(
      "Note number" = "[note 1]",
      "Note text" = "Placeholder note",
      check.names = FALSE
    )

  table_example <- mtcars
  table_example[["car [note 1]"]] <- row.names(mtcars)
  row.names(table_example) <- NULL
  table_example <- table_example[1:5, c("car [note 1]", "mpg", "cyl")]'

}
