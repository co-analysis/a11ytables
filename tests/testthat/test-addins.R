
test_that("string_create_a11ytable skeleton is okay", {
  expect_snapshot_output(string_create_a11ytable())
})

test_that("string_tables_tibble skeleton is okay", {
  expect_snapshot_output(string_tables_tibble())
})
