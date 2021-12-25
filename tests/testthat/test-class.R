
test_that("a11ytable can be created by hand", {

  x <- new_a11ytable(
    tab_titles      = lfs_tables$tab_title,
    sheet_types     = lfs_tables$sheet_type,
    sheet_titles    = lfs_tables$sheet_title,
    sources         = lfs_tables$source,
    subtable_nums   = lfs_tables$subtable_num,
    subtable_titles = lfs_tables$subtable_title,
    table_names     = lfs_tables$table_name,
    tables          = lfs_tables$table
  )

  expect_s3_class(x, class = "a11ytable")
  expect_identical(class(x), c("a11ytable", "data.frame"))

  expect_error(
    new_a11ytable(
      tab_titles      = lfs_tables$tab_title,
      sheet_types     = "x",
      sheet_titles    = lfs_tables$sheet_title,
      sources         = lfs_tables$source,
      subtable_nums   = lfs_tables$subtable_num,
      subtable_titles = lfs_tables$subtable_title,
      table_names     = lfs_tables$table_name,
      tables          = lfs_tables$table
    )
  )

})

test_that("suitable objects can be coerced", {

  x <- as_a11ytable(lfs_tables)

  expect_s3_class(x, class = "a11ytable")
  expect_identical(class(x), c("a11ytable", "data.frame"))

  expect_identical(is_a11ytable(x), TRUE)
  expect_identical(is_a11ytable("x"), FALSE)

  expect_identical(
    structure(x, class = "data.frame"),
    structure(lfs_tables, class = "data.frame")
  )

  expect_true(is_a11ytable(x))
  expect_false(is_a11ytable(mtcars))

})

test_that("class validation works", {

  expect_length(as_a11ytable(lfs_tables), 8)

  expect_error(as_a11ytable(1))
  expect_error(as_a11ytable("x"))
  expect_error(as_a11ytable(list()))
  expect_error(as_a11ytable(data.frame()))

  x <- lfs_tables; names(x)[1] <- "foo"
  expect_error(as_a11ytable(x))

  x <- lfs_tables; x[["table"]] <- as.character(x[["table"]])
  expect_error(as_a11ytable(x))

  x <- lfs_tables[, 1:7]
  expect_error(as_a11ytable(x))

  x <- lfs_tables[1, ]
  expect_error(as_a11ytable(x))

  x <- lfs_tables; x[1] <- 1:nrow(x)
  expect_error(as_a11ytable(x))

  x <- lfs_tables; x[x$sheet_type %in% c("cover", "contents"), "sheet_type"] <- "foo"
  expect_error(as_a11ytable(x))

  x <- lfs_tables; x$sheet_type <- NA_character_
  expect_error(as_a11ytable(x))

})

test_that("print method works", {

  x <- as_a11ytable(lfs_tables)

  expect_output(print(x))

})
