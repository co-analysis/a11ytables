# This file generates and writes the dataset 'mtcars_df'

library(tibble)

cover_df <-
  tribble(
    ~"Sub title",  ~"Sub body",
    "Description", "Aspects of automobile design and performance.",
    "Properties",  paste0("Suppressed values are replaced with the value '[c]'."),
    "Contact",     "The mtcars Team, telephone 0123456789."
  ) |>
  as.data.frame()

contents_df <-
  tribble(
    ~"Sheet name", ~"Sheet title",
    "Notes",       "Notes used in the statistical tables of this workbook",
    "Table 1",     "Car Road Tests (demo 1)",
    "Table 2",     "Car Road Tests (demo 2)"
  ) |>
  as.data.frame()

notes_df <-
  tribble(
    ~"Note number", ~"Note text",
    "[note 1]",     "US gallons.",
    "[note 2]",     "Retained to enable comparisons with previous analyses."
  ) |>
  as.data.frame()

stats_df_1 <- mtcars |>
  head() |>
  rownames_to_column("car") |>
  subset(select = c("car", "cyl", "mpg"))

names(stats_df_1) <- c(
  "Car",
  "Cylinder count",
  "Miles per gallon [note 1]"
)

stats_df_1$Notes <- c(
  rep("[note 2]", 2),
  rep(NA_character_, 4)
)

stats_df_1[3, 2:3] <- "[c]"

stats_df_2 <- mtcars |>
  head() |>
  rownames_to_column("car") |>
  subset(select = c("car", "hp", "drat"))

names(stats_df_2) <- c(
  "Car",
  "Gross horsepower",
  "Rear axle ratio"
)

mtcars_df <- tibble(
  tab_title = c(
    "Cover",
    "Contents",
    "Notes",
    "Table_1",
    "Table_2"
  ),
  sheet_type = c(
    "cover",
    "contents",
    "notes",
    "tables",
    "tables"
  ),
  sheet_title = c(
    "The 'mtcars' Demo Dataset",
    "Table of contents",
    "Notes",
    "Table 1: Car Road Tests 1",
    "Table 2: Car Road Tests 2"
  ),
  blank_cells = c(
    NA_character_,
    NA_character_,
    NA_character_,
    "A blank cell in the Notes column indicates that there is no note for that row.",
    NA_character_
  ),
  source = c(
    NA_character_,
    NA_character_,
    NA_character_,
    "Motor Trend (1974)",
    "Motor Trend (1974)"
  ),
  table = list(
    cover_df,
    contents_df,
    notes_df,
    stats_df_1,
    stats_df_2
  )
)

# Write to data/
usethis::use_data(mtcars_df, overwrite = TRUE)
