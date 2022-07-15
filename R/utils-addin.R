string_create_a11ytable <- function() {

  'my_a11ytable <-
    a11ytables::create_a11ytable(
      tab_titles = c(
        "Cover",
        "Contents",
        "Notes",
        "Table_1"
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
        "Example sheet title"
      ),
      blank_cells = c(
        NA_character_,
        NA_character_,
        NA_character_,
        "Blank cells mean that a row does not have a note."
      ),
      sources = c(
        NA_character_,
        NA_character_,
        NA_character_,
        "Example source."
      ),
      tables = list(
        cover_df,
        contents_df,
        notes_df,
        table_df
      )
    )'

}

string_tables_tibble <- function() {

  'cover_df <- tibble::tribble(
    ~subsection_title, ~subsection_content,
    "Purpose", "Example results for something.",
    "Workbook properties", "Some placeholder information.",
    "Contact", "Placeholder email"
  )

  contents_df <- tibble::tribble(
    ~"Sheet name", ~"Sheet title",
    "Notes", "Notes",
    "Table_1", "Example sheet title"
  )

  notes_df <- tibble::tribble(
    ~"Note number", ~"Note text",
    "[note 1]", "Placeholder note.",
    "[note 2]", "Placeholder note."
  )

  table_df <- mtcars
  table_df[["car [note 1]"]] <- row.names(mtcars)
  row.names(table_df) <- NULL
  table_df <- table_df[1:5, c("car [note 1]", "mpg", "cyl")]
  table_df["Notes"] <- c("[note 2]", rep(NA_character_, 4))'

}

string_tables_df <- function() {
  'cover_df <- data.frame(
      subsection_title = c(
        "Purpose",
        "Workbook properties",
        "Contact"
      ),
      subsection_content = c(
        "Example results for something.",
        "Some placeholder information.",
        "Placeholder email"
      ),
      check.names = FALSE
    )

    contents_df <- data.frame(
      "Sheet name" = c("Notes", "Table_1"),
      "Sheet title" = c("Notes", "Example sheet title"),
      check.names = FALSE
    )

    notes_df <- data.frame(
      "Note number" = c("[note 1]", "[note 2]"),
      "Note text" = c("Placeholder note.", "Placeholder note."),
      check.names = FALSE
    )

  table_df <- mtcars
  table_df[["car [note 1]"]] <- row.names(mtcars)
  row.names(table_df) <- NULL
  table_df <- table_df[1:5, c("car [note 1]", "mpg", "cyl")]
  table_df["Notes"] <- c("[note 2]", rep(NA_character_, 4))'

}
