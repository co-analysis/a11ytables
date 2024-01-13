test_that("vector elements are converted to sentence form", {
  expect_equal(.vector_to_sentence(LETTERS[1]), "A")
  expect_equal(.vector_to_sentence(LETTERS[1:2]), "A and B")
  expect_equal(.vector_to_sentence(LETTERS[1:3]), "A, B and C")
})
