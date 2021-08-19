
test_that("add_tabs() works", {

  wb <- openxlsx::createWorkbook()
  wb_tabs <- add_tabs(wb, lfs_tables)
  tab_names <- c("cover", "contents", "notes", "1a", "2")

  expect_equal(class(wb_tabs)[1], "Workbook")
  expect_equal(wb_tabs$sheet_names, tab_names)

  expect_error(add_tabs("x", lfs_tables))
  expect_error(add_tabs(wb, "x"))

})

test_that("Custom workbook fonts work", {

  wb <- openxlsx::createWorkbook()
  wb_tabs <- add_tabs(wb, lfs_tables)
  wb_cover <- add_cover(wb_tabs, lfs_tables)

  expect_true(grepl("12.*Arial", wb_cover$styles$fonts))

})

test_that("add_cover() works", {

  wb <- openxlsx::createWorkbook()
  wb_tabs <- add_tabs(wb, lfs_tables)
  wb_cover <- add_cover(wb_tabs, lfs_tables)

  expect_equal(class(wb_cover)[1], "Workbook")

  expect_error(add_cover("x", lfs_tables))
  expect_error(add_cover(wb, "x"))

})

test_that("add_contents() works", {

  wb <- openxlsx::createWorkbook()
  wb_tabs <- add_tabs(wb, lfs_tables)
  wb_contents <- add_contents(wb_tabs, lfs_tables)

  expect_equal(class(wb_contents)[1], "Workbook")

  expect_error(add_contents("x", lfs_tables))
  expect_error(add_contents(wb, "x"))

})

test_that("add_notes() works", {

  wb <- openxlsx::createWorkbook()
  wb_tabs <- add_tabs(wb, lfs_tables)
  wb_notes <- add_notes(wb_tabs, lfs_tables)

  expect_equal(class(wb_notes)[1], "Workbook")

  expect_error(add_notes("x", lfs_tables))
  expect_error(add_notes(wb, "x"))

})

test_that("add_tables() works", {

  table_name <- "Labour_market_summary_for_16_and_over"

  wb <- openxlsx::createWorkbook()
  wb_tabs <- add_tabs(wb, lfs_tables)
  wb_table <- add_tables(wb_tabs, lfs_tables, table_name)

  expect_equal(class(wb_tabs)[1], "Workbook")

  expect_error(add_tables("x", lfs_tables, table_name))
  expect_error(add_tables(wb, "x", table_name))
  expect_error(add_tables(wb, lfs_tables, c("x", "y")))
  expect_error(add_tables(wb, lfs_tables, 1))

})
