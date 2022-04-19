
test_that("workbook object is created", {

  x <- suppressWarnings(
    create_a11y_wb(as_a11ytable(mtcars_df))
  )

  expect_s4_class(x, class = "Workbook")
  expect_identical(class(x)[1], "Workbook")

})

test_that("a11ytable is passed", {

  x <- suppressWarnings(
    as_a11ytable(mtcars_df)
  )

  expect_error(create_a11y_wb("x"))
  expect_error(create_a11y_wb(1))
  expect_error(create_a11y_wb(list()))
  expect_error(create_a11y_wb(data.frame()))

})

test_that("sheet_type notes is handled appropriately", {

  df <- mtcars_df[mtcars_df$sheet_type != "notes", ]
  # expect_warning(as_a11ytable(df))
  suppressWarnings(x <- as_a11ytable(df))
  expect_s3_class(x, "a11ytable")
  expect_s4_class(create_a11y_wb(x), "Workbook")

})
