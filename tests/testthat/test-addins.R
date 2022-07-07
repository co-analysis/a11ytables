
test_that("string_new_a11ytable skeleton is okay", {
  expect_snapshot_output(string_new_a11ytable())
})

test_that("string_tables_tibble skeleton is okay", {
  expect_snapshot_output(string_tables_tibble())
})

test_that("string_tables_df skeleton is okay", {
  expect_snapshot_output(string_tables_df())
})
