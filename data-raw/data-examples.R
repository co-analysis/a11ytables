# This file generates and writes the in-built datasets lfs_tables and
# lfs_subtables

library(usethis)
library(dplyr, warn.conflicts = FALSE)
library(readODS)

# Fetch example spreadsheet from online location:
#   https://gss.civilservice.gov.uk/policy-store/releasing-statistics-in-spreadsheets/

path <- "https://gss.civilservice.gov.uk/wp-content/uploads/2021/11/Labour-market-overview-accessibility-example-Nov21.ods"

temp_dir <- tempdir()
temp_file <- file.path(temp_dir, "data.ods")
download.file(path, temp_file)

# Extract subset of tables from spreadsheet

cover_tbl <- read_ods(
  temp_file, sheet = "Cover_sheet", skip = 1, col_names = FALSE
) %>%
  tibble() %>%
  slice(-c(1, 4, 7, 18, 21))  # so subheaders alternate from row 2

contents_tbl <- read_ods(temp_file, sheet = "Table_of_contents", skip = 1) %>%
  tibble() %>%
  filter(`Worksheet number` %in% c("1a", "2"))

notes_tbl <- read_ods(temp_file, sheet = "Notes", skip = 2) %>% tibble()

s1_tbl <- read_ods(temp_file, sheet = "1a", skip = 3) %>%
  tibble() %>% tail() %>% mutate(across(-1, as.numeric))

s2_t2a_tbl <- read_ods(temp_file, sheet = "2", range = "A5:I348") %>%
  tibble() %>% tail() %>% mutate(across(-1, as.numeric))

s2_t2b_tbl <- read_ods(temp_file, sheet = "2", range = "K5:S348") %>%
  tibble() %>% tail() %>% mutate(across(-1, as.numeric))

# Prepare listcol tibble with sub-tables: lfs_subtables
lfs_subtables <- tibble(
  tab_title = c("cover", "contents", "notes", "1", "2", "2"),
  sheet_type = c("cover", "contents", "notes", rep("tables", 3)),
  sheet_title = c(
    paste(
    "Labour market overview data tables, UK,",
    "December 2020 (accessibility example)"
    ),
    "Table of contents",
    "Notes",
    paste(
      "Number and percentage of population aged 16 and over in each labour",
      "market activity group, UK, seasonally adjusted"
    ),
    rep(
      paste(
        "Number and percentage of population in each labour market activity",
        "group by age band, UK, seasonally adjusted"
      ),
      2
    )
  ),
  source = c(rep(NA, 3), rep("Labour Force Survey", 3)),
  subtable_num = c(NA, NA, NA, NA, "a", "b"),
  subtable_title = c(
    NA, NA, NA, NA,
    paste(
      "Number and percentage of people aged 16 and over in each labour market",
      "activity group"
    ),
    paste(
      "Number and percentage of people aged 16 to 64 in each labour market",
      "activity group"
    )
  ),
  table_name = c(
    "Cover_content",
    "Table_of_contents",
    "Notes_table",
    "Labour_market_summary_for_16_and_over",
    "Labour_market_activity_groups_16_and_over",
    "Labour_market_activity_groups_16_to_64"
  ),
  table = list(
    cover_tbl, contents_tbl, notes_tbl, s1_tbl, s2_t2a_tbl, s2_t2b_tbl
  )
)

# Prepare a version without subtables: lfs_tables
lfs_tables <- lfs_subtables[-nrow(lfs_subtables), ]
lfs_tables$subtable_num <- NA_character_
lfs_tables$subtable_title <- NA_character_

# Write to data/
use_data(lfs_subtables, overwrite = TRUE)
use_data(lfs_tables, overwrite = TRUE)
