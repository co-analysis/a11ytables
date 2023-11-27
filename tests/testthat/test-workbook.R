test_that("workbook object is created", {

  x <- suppressWarnings(generate_workbook(as_a11ytable(mtcars_df)))

  expect_s4_class(x, class = "Workbook")
  expect_identical(class(x)[1], "Workbook")

})

test_that("a11ytable is passed", {

  x <- suppressWarnings(as_a11ytable(mtcars_df))

  expect_error(generate_workbook("x"))
  expect_error(generate_workbook(1))
  expect_error(generate_workbook(list()))
  expect_error(generate_workbook(data.frame()))

})

test_that(".stop_bad_input works as intended", {

  wb <- openxlsx::createWorkbook()
  a11ytable <- as_a11ytable(mtcars_df)

  expect_error(.stop_bad_input("x", a11ytable, "cover"))
  expect_error(.stop_bad_input(wb, a11ytable, 1))

})

test_that("hyperlinks are generated on the cover page", {

  # mtcars_df demo dataset does not contain any hyperlinks on the cover
  x <- suppressWarnings(generate_workbook(as_a11ytable(mtcars_df)))
  expect_length(x$worksheets[[1]]$hyperlinks, 0)

  # mtcars_df2 demo dataset has two hyperlinks on the cover
  y <- suppressWarnings(generate_workbook(as_a11ytable(mtcars_df2)))
  expect_length(y$worksheets[[1]]$hyperlinks, 2)

})
