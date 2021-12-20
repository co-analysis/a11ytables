
test_that("add_tabs() works", {

  wb <- openxlsx::createWorkbook()
  wb_tabs <- add_tabs(wb, lfs_tables)
  tab_names <- c("cover", "contents", "notes", "1", "2")

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

  lfs_tables_misnamed <- lfs_tables
  names(lfs_tables_misnamed)[1] <- "foo"

  lfs_tables_bad_table <- lfs_tables
  lfs_tables_bad_table$table <- rep("foo", nrow(lfs_tables_bad_table))

  lfs_tables_nonchar <- lfs_tables
  lfs_tables_nonchar$tab_title <- 1:nrow(lfs_tables_nonchar)

  lfs_tables_bad_listcol <- lfs_tables
  lfs_tables_bad_listcol$table[[1]] <- list("foo")

  lfs_tables_wrong_tabnames <- lfs_tables
  lfs_tables_wrong_tabnames$tab_title[1:3] <- c("foo", "bar", "baz")

  lfs_tables_na <- lfs_tables
  lfs_tables_na[1, c(1:3, 7)] <- NA

  expect_equal(class(wb_tabs)[1], "Workbook")

  expect_error(add_tables("x", lfs_tables, table_name))
  expect_error(add_tables(wb, "x", table_name))
  # expect_error(add_tables(wb, lfs_tables, c("x", "y")))  # warning
  expect_error(add_tables(wb, lfs_tables, 1))

  expect_error(add_tables(wb, beaver1, table_name))
  expect_error(add_tables(wb, lfs_tables_misnamed, table_name))
  expect_error(add_tables(wb, lfs_tables_bad_table, table_name))
  expect_error(add_tables(wb, lfs_tables_nonchar, table_name))
  expect_error(add_tables(wb, lfs_tables_bad_listcol, table_name))
  expect_error(add_tables(wb, lfs_tables_wrong_tabnames, table_name))
  expect_error(add_tables(wb, lfs_tables_na, table_name))

})
