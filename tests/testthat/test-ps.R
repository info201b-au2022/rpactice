
# testthat::test_file("tests/testthat/test-ps.R")


t <- ps_update_learner_answer("t_01", "10+100+1000")
a <- ps_get_learner_answer("t_01")

test_that("Basic numeric", {
  expect_equal(a, "10+100+1000")
})
