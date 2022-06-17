
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
