# string_new_a11ytable skeleton is okay

    [1] "a11y_example <- a11ytables::new_a11ytable(\n      tab_titles = c(\n        \"Cover\",\n        \"Contents\",\n        \"Notes\",\n        \"Table 1\"\n      ),\n      sheet_types = c(\n        \"cover\",\n        \"contents\",\n        \"notes\",\n        \"tables\"\n      ),\n      sheet_titles = c(\n        \"Cover title (example)\",\n        \"Contents\",\n        \"Notes\",\n        \"Sheet title (example)\"\n      ),\n      blank_cells = c(\n        NA_character_,\n        NA_character_,\n        NA_character_,\n        \"Blank cells in this table indicate something.\"\n      ),\n      sources = c(\n        NA_character_,\n        NA_character_,\n        NA_character_,\n        \"Source (example)\"\n      ),\n      tables = list(\n        cover_example,\n        contents_example,\n        notes_example,\n        table_example\n      )\n    )"

# string_tables_tibble skeleton is okay

    [1] "cover_example <- tibble::tribble(\n    ~subsection_title, ~subsection_body,\n    \"Purpose\", \"Example results for something.\",\n    \"Workbook properties\", \"Some placeholder information.\",\n    \"Contact\", \"Placeholder email\"\n  )\n\n  contents_example <- tibble::tribble(\n    ~\"Sheet name\", ~\"Sheet title\",\n    \"Notes\", \"Notes\",\n    \"Table 1\", \"Sheet title (example)\"\n  )\n\n  notes_example <- tibble::tribble(\n    ~\"Note number\", ~\"Note text\",\n    \"[note 1]\", \"Placeholder note.\"\n  )\n\n  table_example <- mtcars\n  table_example[[\"car [note 1]\"]] <- row.names(mtcars)\n  row.names(table_example) <- NULL\n  table_example <- table_example[1:5, c(\"car [note 1]\", \"mpg\", \"cyl\")]"

# string_tables_df skeleton is okay

    [1] "cover_example <- data.frame(\n      subsection_title = c(\n        \"Purpose\",\n        \"Workbook properties\",\n        \"Contact\"\n      ),\n      subsection_body = c(\n        \"Example results for something.\",\n        \"Some placeholder information.\",\n        \"Placeholder email\"\n      ),\n      check.names = FALSE\n    )\n\n    contents_example <- data.frame(\n      \"Sheet name\" = c(\"Notes\", \"Table 1\"),\n      \"Sheet title\" = c(\"Notes\", \"Sheet title (example)\"),\n      check.names = FALSE\n    )\n\n    notes_example <- data.frame(\n      \"Note number\" = \"[note 1]\",\n      \"Note text\" = \"Placeholder note\",\n      check.names = FALSE\n    )\n\n  table_example <- mtcars\n  table_example[[\"car [note 1]\"]] <- row.names(mtcars)\n  row.names(table_example) <- NULL\n  table_example <- table_example[1:5, c(\"car [note 1]\", \"mpg\", \"cyl\")]"
