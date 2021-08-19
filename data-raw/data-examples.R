library(dplyr, warn.conflicts = FALSE)
library(purrr)
library(readODS)

path <- paste0(
  "https://gss.civilservice.gov.uk/wp-content/uploads/2021/05/",
  "Labour-market-overview-accessibility-example.ods"
)

temp_dir <- tempdir()
temp_file <- file.path(temp_dir, "data.ods")

download.file(path, temp_file)

# extract tables

cover_tbl <- read_ods(temp_file, sheet = "Cover_sheet", skip = 1) %>%
  tibble()

contents_tbl <- read_ods(temp_file, sheet = "Table_of_contents", skip = 1) %>%
  tibble() %>%
  filter(`Worksheet number` %in% c("1a", 2))

notes_tbl <- read_ods(temp_file, sheet = "Notes", skip = 2) %>% tibble()

s1a_tbl <- read_ods(temp_file, sheet = "1a", skip = 3) %>%
  tibble() %>% tail() %>% mutate(across(-1, as.numeric))

s2_t2a_tbl <- read_ods(temp_file, sheet = "2", range = "A5:I348") %>%
  tibble() %>% tail() %>% mutate(across(-1, as.numeric))

s2_t2b_tbl <- read_ods(temp_file, sheet = "2", range = "K5:S348") %>%
  tibble() %>% tail() %>% mutate(across(-1, as.numeric))

# Prepare listcol tibble

lfs_tables <- tibble(
  tab_title = c("cover", "contents", "notes", "1a", "2", "2"),
  sheet_type = c(rep("meta", 3), rep("tables", 3)),
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
    cover_tbl, contents_tbl, notes_tbl, s1a_tbl, s2_t2a_tbl, s2_t2b_tbl
  )
)

usethis::use_data(lfs_tables, overwrite = TRUE)
