# This file generates and writes the in-built datasets mtcars_a11ytable


# Create table for cover
cover_df <- tibble::tribble(
  ~"Subsection title", ~"Subsection body",
  "Description", "The data was extracted from the 1974 Motor Trend US magazine, and comprises fuel consumption and 10 aspects of automobile design and performance for 32 automobiles (1973–74 models)",
  "Format", "A data frame with 32 observations on 11 (numeric) variables."
) |>
  as.data.frame()

# Create table for contents
contents_df <- tibble::tribble(
  ~"Sheet name", ~"Sheet title",
  "Notes", "Notes",
  "Table 1", "Motor Trend Car Road Tests"
) |>
  as.data.frame()

# Create table for notes
notes_df <- tibble::tribble(
  ~"Note number", ~"Note text",
  "[c]", "Confidential: suppressed.",
  "[z]", "Not applicable.",
  "[1]", "Hocking [original transcriber]'s noncrucial coding of the Mazda's rotary engine as a straight six-cylinder engine and the Porsche's flat engine as a V engine, as well as the inclusion of the diesel Mercedes 240D, have been retained to enable direct comparisons to be made with previous analyses.",
  "[2]", "Test note.",
  "[3]", "Test note."
) |>
  as.data.frame()

# Select mtcars columns
cars_df <- tibble::rownames_to_column(mtcars, "car") |>
  subset(select = c("car", "mpg", "cyl", "disp", "hp"))

# Add suppression examples
cars_df[1, "mpg"] <- "[c]" # single
cars_df[2:nrow(cars_df) , "cyl"] <- "[c]"  # multi (all but one suppressed)
cars_df[, "disp"] <- "[c]"  # all suppressed

# Add notes column example
notes_cars <- c("Mazda RX4", "Mazda RX4 Wag", "Porsche 914-2", "Merc 240D")
cars_df[["Notes"]] <- ifelse(cars_df[["car"]] %in% notes_cars, "[1]", "[z]")

# Provide better names
names(cars_df) <- c(
  "Car",
  "Miles per gallon [2]",
  "Cylinders [2, 3]",
  "Displacement [note 2]",
  "Horsepower [note]",
  "Notes"
)

# Build data.frame
mtcars_df <- tibble::tibble(
  tab_title = c("Cover", "Contents", "Notes", "Table 1"),
  sheet_type = c("cover", "contents", "notes", "tables"),
  sheet_title = c(
    "The mtcars demo datset: 'Motor Trend Car Road Tests'",
    "Table of contents",
    "Notes",
    "Motor Trend Car Road Tests"
  ),
  source = c(rep(NA_character_, 3), "Motor Trend (1974)"),
  table_name = c(
    "cover_sheet",
    "table_of_contents",
    "notes_table",
    "car_scores"
  ),
  table = list(
    cover_df,
    contents_df,
    notes_df,
    cars_df
  )
)

# Write to data/
usethis::use_data(mtcars_df, overwrite = TRUE)
