
test_that("a11ytable can be created by hand (with df for cover)", {

  # Uses mtcars_df3, which has a data.frame containing cover information in the
  # 'table' column.

  x <- suppressWarnings(
    create_a11ytable(
      tab_titles   = mtcars_df3$tab_title,
      sheet_types  = mtcars_df3$sheet_type,
      sheet_titles = mtcars_df3$sheet_title,
      sources      = mtcars_df3$source,
      tables       = mtcars_df3$table
    )
  )

  expect_s3_class(x, class = "a11ytable")
  expect_identical(class(x), c("a11ytable", "tbl", "data.frame"))

  expect_error(
    suppressWarnings(
      create_a11ytable(
        tab_titles   = mtcars_df3$tab_title,
        sheet_types  = "x",
        sheet_titles = mtcars_df3$sheet_title,
        sources      = mtcars_df3$source,
        tables       = mtcars_df3$table
      )
    )
  )

})

test_that("a11ytable can be created by hand (with list for cover)", {

  # Uses mtcars_df3, which has a list containing cover information in the
  # 'table' column.

  x <- suppressWarnings(
    create_a11ytable(
      tab_titles   = mtcars_df3$tab_title,
      sheet_types  = mtcars_df3$sheet_type,
      sheet_titles = mtcars_df3$sheet_title,
      sources      = mtcars_df3$source,
      tables       = mtcars_df3$table
    )
  )

  expect_s3_class(x, class = "a11ytable")
  expect_identical(class(x), c("a11ytable", "tbl", "data.frame"))

  expect_error(
    suppressWarnings(
      create_a11ytable(
        tab_titles   = mtcars_df3$tab_title,
        sheet_types  = "x",
        sheet_titles = mtcars_df3$sheet_title,
        sources      = mtcars_df3$source,
        tables       = mtcars_df3$table
      )
    )
  )

})

test_that("strings are not converted to factors", {

  x <- suppressWarnings(
    create_a11ytable(
      tab_titles   = mtcars_df3$tab_title,
      sheet_types  = mtcars_df3$sheet_type,
      sheet_titles = mtcars_df3$sheet_title,
      sources      = mtcars_df3$source,
      tables       = mtcars_df3$table
    )
  )

  classes <- unlist(lapply(x, class))

  expect_true(all(c("character", "list") %in% classes))
  expect_false(any("factor" %in% classes))

})

test_that("suitable objects can be coerced", {

  x <- suppressWarnings(as_a11ytable(mtcars_df3))

  expect_s3_class(x, class = "a11ytable")
  expect_identical(class(x), c("a11ytable", "tbl", "data.frame"))

  expect_identical(is_a11ytable(x), TRUE)
  expect_identical(is_a11ytable("x"), FALSE)

  expect_true(is_a11ytable(x))
  expect_false(is_a11ytable(mtcars))

})

test_that("class validation works", {

  expect_length(suppressWarnings(as_a11ytable(mtcars_df3)), 7)

  expect_error(as_a11ytable(1))
  expect_error(as_a11ytable("x"))
  expect_error(as_a11ytable(list()))
  expect_error(as_a11ytable(data.frame()))

  x <- mtcars_df3
  names(x)[1] <- "foo"
  expect_error(as_a11ytable(x))

  x <- mtcars_df3
  x[["table"]] <- as.character(x[["table"]])
  expect_error(as_a11ytable(x))

  x <- mtcars_df3[, 1:4]
  expect_error(as_a11ytable(x))

  x <- mtcars_df3[1, ]
  expect_error(as_a11ytable(x))

  x <- mtcars_df3
  x[x$sheet_type %in% c("cover", "contents"), "sheet_type"] <- "foo"
  expect_error(as_a11ytable(x))

  x <- mtcars_df3
  x[x$tab_title == "Table_2", "sheet_type"] <- "foo"
  expect_error(as_a11ytable(x))

  x <- mtcars_df3
  x$sheet_type <- NA_character_
  expect_error(as_a11ytable(x))

  x <- mtcars_df3
  x[x$tab_title == "Table_2", "tab_title"] <-
    "Lorem_ipsum_dolor_sit_amet__consectetur_adipiscing"
  expect_warning(as_a11ytable(x))

  x <- mtcars_df3
  x[x$sheet_type == "notes", "table"][[1]] <-
    list(
      data.frame(
        "Note number" = "[note 1]",
        "Note text" = "US gallons.",
        check.names = FALSE
      )
    )
  expect_warning(as_a11ytable(x))

})

test_that("summary method works", {

  x <- suppressWarnings(as_a11ytable(mtcars_df3))
  expect_output(summary(x))

})

test_that("absence of note sheets doesn't prevent a11ytable formation", {

  df <- mtcars_df3[mtcars_df3$sheet_type != "notes", ]
  suppressWarnings(x <- as_a11ytable(df))

  expect_s3_class(x, "a11ytable")
  expect_s4_class(generate_workbook(x), "Workbook")

})

test_that("tab_titles are unique", {

  mtcars_df3[mtcars_df3$tab_title == "Table_2", "tab_title"] <- "Table_1"

  expect_error(
    with(
      mtcars_df3,
      create_a11ytable(
        tab_titles   = tab_title,
        sheet_types  = sheet_type,
        sheet_titles = sheet_title,
        blank_cells  = blank_cells,
        sources      = source,
        tables       = table
      )
    )
  )

})

test_that("tbl output looks as intended", {

  x <- create_a11ytable(
    tab_titles = LETTERS[1:3],
    sheet_type = c("cover", "contents", "tables"),
    sheet_titles = LETTERS[1:3],
    sources = c(rep(NA_character_, 2), "x."),
    tables = list(
      data.frame(x = "x"),
      data.frame(tab = "x", title = "x"),
      mtcars
    )
  )

  expect_snapshot_output(as_a11ytable(x))

})

test_that("input other than data.frame is intercepted during validation", {

  expect_error(.validate_a11ytable("x"))

  x <- mtcars_df3; x[, "table"] <- "x"
  expect_error(
    as_a11ytable(x),
    "Column 'table' must be a listcol of data.frame objects."
  )

  y <- subset(mtcars_df3, select = -table)
  y[, "table"] <- list(rep(list("x"), nrow(y)))
  expect_error(
    as_a11ytable(y),
    "List-column 'table' must contain data.frame objects only."
  )

})

test_that("only one cover, contents, notes can be used", {

  cover_dupe <-
    rbind(mtcars_df3, mtcars_df3[mtcars_df3$sheet_type == "cover", ])
  contents_dupe <-
    rbind(mtcars_df3, mtcars_df3[mtcars_df3$sheet_type == "contents", ])
  notes_dupe <-
    rbind(mtcars_df3, mtcars_df3[mtcars_df3$sheet_type == "notes", ])

  expect_error(as_a11ytable(cover_dupe))
  expect_error(as_a11ytable(contents_dupe))
  expect_error(as_a11ytable(notes_dupe))

})

test_that("NAs in certain columns cause failure", {

  tab_na   <- mtcars_df3; tab_na$tab_title     <- NA_character_
  type_na  <- mtcars_df3; type_na$sheet_type   <- NA_character_
  title_na <- mtcars_df3; title_na$sheet_title <- NA_character_
  table_na <- mtcars_df3; table_na$table       <- NA_character_

  expect_error(as_a11ytable(tab_na))
  expect_error(as_a11ytable(type_na))
  expect_error(as_a11ytable(title_na))
  expect_error(as_a11ytable(table_na))

})

test_that("Note mismatch is caught", {

  x <- mtcars_df3[!mtcars_df3$tab_title == "Table_1", ]
  x[x$sheet_type == "contents", "table"][[1]] <-
    list(data.frame(x = c("x", "y"), y = c("x", "y")))

  expect_warning(as_a11ytable(x), "You have a 'notes' sheet")

  # y <- mtcars_df3[!mtcars_df3$tab_title == "Table_2", ]
  # y[y$sheet_type == "contents", "table"][[1]] <-
  #   list(data.frame(x = c("x", "y"), y = c("x", "y")))
  # table_extra_note <- y[y$tab_title == "Table_1", "table"][[1]]
  # names(table_extra_note)[1] <- "Car [note 3]"
  # y[y$tab_title == "Table_1", "table"][[1]] <- list(table_extra_note)
  #
  # expect_warning(as_a11ytable(y), "Some notes are in the tables")

  z <- mtcars_df3[!mtcars_df3$tab_title == "Table_2", ]
  z[z$sheet_type == "contents", "table"][[1]] <-
    list(data.frame(x = c("x", "y"), y = c("x", "y")))
  z[z$sheet_type == "notes", "table"][[1]] <- list(
    data.frame(
      `Note number` = paste0("[note ", 1:3, "]"),
      `Note text` = "x",
      check.names = FALSE
    )
  )

  expect_warning(as_a11ytable(z), "Some notes are in the notes sheet")

})


test_that("warning is raised if a source statement is missing", {

  mtcars_df3[mtcars_df3$tab_title == "Table_1", "source"] <- NA_character_
  expect_warning(
    as_a11ytable(mtcars_df3),
    "One of your tables is missing a source statement."
  )

})

test_that("warning is raised if there's no blank cells but there is a reason", {

  mtcars_df3[mtcars_df3$tab_title == "Table_2", "blank_cells"] <- "x"
  expect_warning(
    as_a11ytable(mtcars_df3),
    "There's no blank cells in these tables"
  )

})

test_that("period added to end of text if needed", {

  expect_identical(.append_period("Test"), "Test.")
  expect_identical(.append_period("Test."), "Test.")
  expect_identical(.append_period(NA), NA)

  expect_identical(
    .append_period(c("Test", "Test.", NA_character_)),
    c("Test.", "Test.", NA)
  )

})

test_that("tab titles are cleaned and warnings provided", {

  long_title <- "12345678901234567890123456789012"

  expect_warning(.clean_tab_titles("Table 1"))
  expect_warning(.clean_tab_titles(c("Table 1", "Table 2")))
  expect_warning(.clean_tab_titles(c("Table_1", "Table 2")))
  expect_warning(.clean_tab_titles("Table!@£#$%^&*(){}[]-=+;:'\"\\|<>,.~`/?1"))
  expect_warning(.clean_tab_titles(long_title))

  x <- mtcars_df3
  x[1, "tab_title"] <- long_title
  expect_warning(as_a11ytable(x))

  y <- mtcars_df3
  y[1, "tab_title"] <- "Cover!"
  expect_warning(as_a11ytable(y))

})

test_that("input column names are okay", {

  names(mtcars_df3)[1] <- "x"
  expect_error(as_a11ytable(mtcars_df3))

})

test_that("character class columns are caught if not character class", {

  mtcars_df3[, "sheet_type"] <- 1:nrow(mtcars_df3)
  expect_error(as_a11ytable(mtcars_df3))

})
