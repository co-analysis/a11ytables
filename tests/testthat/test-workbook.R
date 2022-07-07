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

test_that(".stop_bad_input works as intended", {

  wb <- openxlsx::createWorkbook()
  a11ytable <- as_a11ytable(mtcars_df)

  expect_error(.stop_bad_input("x", a11ytable, "cover"))
  expect_error(.stop_bad_input(wb, a11ytable, 1))

})

test_that("Period not added to end of source message if it already has one", {

  mtcars_df[mtcars_df$tab_title == "Table 1", "source"] <- "x."
  mtcars_df[mtcars_df$tab_title == "Table 1", "blank_cells"] <- "x"
  a11ytable <- as_a11ytable(mtcars_df)
  wb <- create_a11y_wb(a11ytable)

  expect_s4_class(wb, class = "Workbook")

})