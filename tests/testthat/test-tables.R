
test_that("workbook object is created", {

  x <- create_a11y_wb(as_a11ytable(lfs_tables))

  expect_s4_class(x, class = "Workbook")
  expect_identical(class(x)[1], "Workbook")

})

test_that("a11ytable is passed", {

  x <- as_a11ytable(lfs_tables)

  expect_error(create_a11y_wb("x"))
  expect_error(create_a11y_wb(1))
  expect_error(create_a11y_wb(list()))
  expect_error(create_a11y_wb(data.frame()))

})

test_that("sheet_type notes is handled appropriately", {

  x <- as_a11ytable(lfs_tables[lfs_tables$sheet_type != "notes", ])
  expect_s3_class(x, "a11ytable")
  expect_s4_class(create_a11y_wb(x), "Workbook")

  # x <- lfs_tables
  # y <- data.frame(`V1 [note 1]` = "x", check.names = FALSE)
  # x[4, 8][[1]][[1]] <- y
  # z1 <- as_a11ytable(x)
  # z2 <- create_a11y_wb(z1)
  # expect_s3_class(z1, "a11ytable")
  # expect_s4_class(z2, "Workbook")

})
