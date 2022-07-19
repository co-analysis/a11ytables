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
