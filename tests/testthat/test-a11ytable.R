
test_that("a11ytable can be created by hand", {

  x <- suppressWarnings(
    new_a11ytable(
      tab_titles   = mtcars_df$tab_title,
      sheet_types  = mtcars_df$sheet_type,
      sheet_titles = mtcars_df$sheet_title,
      sources      = mtcars_df$source,
      tables       = mtcars_df$table
    )
  )

  expect_s3_class(x, class = "a11ytable")
  expect_identical(class(x), c("a11ytable", "tbl", "data.frame"))

  expect_error(
    suppressWarnings(
      new_a11ytable(
        tab_titles      = mtcars_df$tab_title,
        sheet_types     = "x",
        sheet_titles    = mtcars_df$sheet_title,
        sources         = mtcars_df$source,
        tables          = mtcars_df$table
      )
    )
  )

})

test_that("suitable objects can be coerced", {

  x <- suppressWarnings(
    as_a11ytable(mtcars_df)
  )

  expect_s3_class(x, class = "a11ytable")
  expect_identical(class(x), c("a11ytable", "tbl", "data.frame"))

  expect_identical(is_a11ytable(x), TRUE)
  expect_identical(is_a11ytable("x"), FALSE)

  expect_identical(
    structure(x, class = "data.frame"),
    structure(mtcars_df, class = "data.frame")
  )

  expect_true(is_a11ytable(x))
  expect_false(is_a11ytable(mtcars))

})

test_that("class validation works", {

  expect_length(suppressWarnings(as_a11ytable(mtcars_df)), 6)

  expect_error(as_a11ytable(1))
  expect_error(as_a11ytable("x"))
  expect_error(as_a11ytable(list()))
  expect_error(as_a11ytable(data.frame()))

  x <- mtcars_df
  names(x)[1] <- "foo"
  expect_error(as_a11ytable(x))

  x <- mtcars_df
  x[["table"]] <- as.character(x[["table"]])
  expect_error(as_a11ytable(x))

  x <- mtcars_df[, 1:4]
  expect_error(as_a11ytable(x))

  x <- mtcars_df[1, ]
  expect_error(as_a11ytable(x))

  x <- mtcars_df
  x[1] <- 1:nrow(x)
  expect_error(as_a11ytable(x))

  x <- mtcars_df
  x[x$sheet_type %in% c("cover", "contents"), "sheet_type"] <- "foo"
  expect_error(as_a11ytable(x))

  x <- mtcars_df
  x$sheet_type <- NA_character_
  expect_error(as_a11ytable(x))

})

test_that("summary method works", {

  x <- suppressWarnings(
    as_a11ytable(mtcars_df)
  )

  expect_output(summary(x))

})

test_that("absence of note sheets doesn't prevent a11ytable formation", {

  df <- mtcars_df[mtcars_df$sheet_type != "notes", ]
  suppressWarnings(x <- as_a11ytable(df))

  expect_s3_class(x, "a11ytable")
  expect_s4_class(create_a11y_wb(x), "Workbook")

})

test_that("tab_titles are unique", {

  mtcars_df[mtcars_df$tab_title == "Table 2", "tab_title"] <- "Table 1"

  expect_error(
    with(
      mtcars_df,
      new_a11ytable(
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

  x <- new_a11ytable(
    tab_titles = LETTERS[1:3],
    sheet_type = c("cover", "contents", "tables"),
    sheet_titles = LETTERS[1:3],
    sources = c(rep(NA_character_, 2), "x"),
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

  x <- mtcars_df; x[, "table"] <- "x"
  expect_error(
    as_a11ytable(x),
    "Column 'table' must be a listcol of data.frame objects."
  )

  y <- subset(mtcars_df, select = -table)
  y[, "table"] <- list(rep(list("x"), nrow(y)))
  expect_error(
    as_a11ytable(y),
    "List-column 'table' must contain data.frame objects only."
  )

})

test_that("only one cover, contents, notes can be used", {

  cover_dupe <-
    rbind(mtcars_df, mtcars_df[mtcars_df$sheet_type == "cover", ])
  contents_dupe <-
    rbind(mtcars_df, mtcars_df[mtcars_df$sheet_type == "contents", ])
  notes_dupe <-
    rbind(mtcars_df, mtcars_df[mtcars_df$sheet_type == "notes", ])

  expect_error(as_a11ytable(cover_dupe))
  expect_error(as_a11ytable(contents_dupe))
  expect_error(as_a11ytable(notes_dupe))

})

test_that("NAs in certain columns cause failure", {

  tab_na   <- mtcars_df; tab_na$tab_title     <- NA_character_
  type_na  <- mtcars_df; type_na$sheet_type   <- NA_character_
  title_na <- mtcars_df; title_na$sheet_title <- NA_character_
  table_na <- mtcars_df; table_na$table       <- NA_character_

  expect_error(as_a11ytable(tab_na))
  expect_error(as_a11ytable(type_na))
  expect_error(as_a11ytable(title_na))
  expect_error(as_a11ytable(table_na))

})

test_that("Note mismatch is caught", {

  x <- mtcars_df[!mtcars_df$tab_title == "Table 1", ]
  x[x$sheet_type == "contents", "table"][[1]] <-
    list(data.frame(x = c("x", "y"), y = c("x", "y")))

  expect_warning(as_a11ytable(x), "You have a 'notes' sheet")

  # y <- mtcars_df[!mtcars_df$tab_title == "Table 2", ]
  # y[y$sheet_type == "contents", "table"][[1]] <-
  #   list(data.frame(x = c("x", "y"), y = c("x", "y")))
  # table_extra_note <- y[y$tab_title == "Table 1", "table"][[1]]
  # names(table_extra_note)[1] <- "Car [note 3]"
  # y[y$tab_title == "Table 1", "table"][[1]] <- list(table_extra_note)
  #
  # expect_warning(as_a11ytable(y), "Some notes are in the tables")

  z <- mtcars_df[!mtcars_df$tab_title == "Table 2", ]
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

  mtcars_df[mtcars_df$tab_title == "Table 1", "source"] <- NA_character_
  expect_warning(
    as_a11ytable(mtcars_df),
    "One of your tables is missing a source statement."
  )

})

test_that("warning is raised if there's no blank cells but there is a reason", {

  mtcars_df[mtcars_df$tab_title == "Table 2", "blank_cells"] <- "x"
  expect_warning(
    as_a11ytable(mtcars_df),
    "There's no blank cells in these tables"
  )

})