string_create_a11ytable <- function() {

  'my_a11ytable <-
  a11ytables::create_a11ytable(
    tab_titles = c(
      "Cover",
      "Contents",
      "Notes",
      "Table 1",
      "Table 2"
    ),
    sheet_types = c(
      "cover",
      "contents",
      "notes",
      "tables",
      "tables"
    ),
    sheet_titles = c(
      "The \'mtcars\' Demo Datset",
      "Table of contents",
      "Notes",
      "Table 1: Car Road Tests",
      "Table 2: Car Road Tests"
    ),
    blank_cells = c(
      NA_character_,
      NA_character_,
      NA_character_,
      "Blank cells indicate that there\'s no note in that row",
      NA_character_
    ),
    custom_rows = list(
      NA_character_,
      NA_character_,
      NA_character_,
      "This is a custom row for Table 1",
      c("This is a custom row for Table 2", "This is another custom row.")
    ),
    sources = c(
      NA_character_,
      NA_character_,
      NA_character_,
      "Motor Trend (1974)",
      "Motor Trend (1974)"
    ),
    tables = list(
      cover_list,
      contents_df,
      notes_df,
      stats_df_1,
      stats_df_2
    )
  )'

}

string_tables_tibble <- function() {

  'cover_list <- list(
    "Description" = c(
      "Aspects of automobile design and performance from \'Motor Trend\' in 1974.",
      "Used by Henderson and Velleman in a 1981 paper in \'Biometrics\'."
    ),
    "Properties" = "Suppressed values are replaced with the value \'[c]\'.",
    "Contact" = c(
      "[Visit the website.](https://github.com/co-analysis/a11ytables)",
      "[Email the team.](mailto:not-a-real-email-address@completely-fake.net)",
      "Telephone 0123456789."
    )
  )

  contents_df <- tibble::tribble(
    ~"Sheet name", ~"Sheet title",
    "Notes",       "Notes used in the statistical tables of this workbook",
    "Table 1",     "Car Road Tests (demo 1)",
    "Table 2",     "Car Road Tests (demo 2)"
  )

  notes_df <- tibble::tribble(
    ~"Note number", ~"Note text",
    "[note 1]",     "US gallons.",
    "[note 2]",     "Retained to enable comparisons with previous analyses."
  )

  # Prepare Table 1

  stats_df_1 <- mtcars |>
    head() |>
    tibble::rownames_to_column("car") |>
    subset(select = c("car", "cyl", "mpg"))

  names(stats_df_1) <- c(
    "Car",
    "Cylinder count",
    "Miles per gallon [note 1]"  # ideally, note markers go in headers not cells
  )

  stats_df_1$Notes <- c(  # add \'Notes\' column
    rep("[note 2]", 2),
    rep(NA_character_, 4)  # note: blank cells in this column
  )

  stats_df_1[3, 2:3] <- "[c]"  # suppressed (confidential) data

  # Prepare Table 2

  stats_df_2 <- mtcars |>
  head() |>
  tibble::rownames_to_column("car") |>
  subset(select = c("car", "hp", "drat"))

  names(stats_df_2) <- c("Car", "Gross horsepower", "Rear axle ratio")'

}
