if (interactive()) {
  devtools::load_all("../../")
  library(testthat)
  source("helper-maker.R")
}

context("Quiet")

test_that("Quieten targets", {
  cleanup()
  m <- maker$new("quiet.yml")
  m$load_sources(FALSE)

  msg <- "make some noise"

  t <- m$get_target("noisy_message")
  expect_that(t$quiet, is_false())
  expect_that(t$run(),            shows_message(msg))
  expect_that(t$run(quiet=TRUE),  not(shows_message()))
  expect_that(t$run(quiet=FALSE), shows_message(msg))

  t <- m$get_target("noisy_cat")
  expect_that(t$quiet, is_false())
  expect_that(t$run(),            prints_text(msg))
  expect_that(t$run(quiet=TRUE),  not(prints_text(msg)))
  expect_that(t$run(quiet=FALSE), prints_text(msg))

  t <- m$get_target("noisy_warning")
  expect_that(t$quiet, is_false())
  expect_that(t$run(),            gives_warning(msg))
  expect_that(t$run(quiet=TRUE),  gives_warning(msg))
  expect_that(t$run(quiet=FALSE), gives_warning(msg))

  t <- m$get_target("noisy_error")
  expect_that(t$quiet, is_false())
  expect_that(t$run(),            throws_error(msg))
  expect_that(t$run(quiet=TRUE),  throws_error(msg))
  expect_that(t$run(quiet=FALSE), throws_error(msg))
})

test_that("Quiet targets", {
  cleanup()
  m <- maker$new("quiet.yml")
  m$load_sources(FALSE)

  msg <- "make some noise"

  t <- m$get_target("quiet_message")
  expect_that(t$quiet, is_true())
  expect_that(t$run(),            not(shows_message()))
  expect_that(t$run(quiet=TRUE),  not(shows_message()))
  expect_that(t$run(quiet=FALSE), not(shows_message()))

  t <- m$get_target("quiet_cat")
  expect_that(t$quiet, is_true())
  expect_that(t$run(),            not(prints_text(msg)))
  expect_that(t$run(quiet=TRUE),  not(prints_text(msg)))
  expect_that(t$run(quiet=FALSE), not(prints_text(msg)))

  t <- m$get_target("quiet_warning")
  expect_that(t$quiet, is_true())
  expect_that(t$run(),            gives_warning(msg))
  expect_that(t$run(quiet=TRUE),  gives_warning(msg))
  expect_that(t$run(quiet=FALSE), gives_warning(msg))

  t <- m$get_target("quiet_error")
  expect_that(t$quiet, is_true())
  expect_that(t$run(),            throws_error(msg))
  expect_that(t$run(quiet=TRUE),  throws_error(msg))
  expect_that(t$run(quiet=FALSE), throws_error(msg))
})

test_that("From maker", {
  msg <- "make some noise"
  cleanup()
  m <- maker$new("quiet.yml", verbose=FALSE)

  expect_that(m$make("noisy_message"), shows_message(msg))
  m$remove_target("noisy_message")
  expect_that(m$make("noisy_message", quiet_target=TRUE),
              not(shows_message()))
  m$remove_target("noisy_message")
  expect_that(m$make("noisy_message", quiet_target=FALSE),
              shows_message(msg))

  m$remove_target("noisy_cat")
  expect_that(m$make("noisy_cat"), prints_text(msg))
  m$remove_target("noisy_cat")
  expect_that(m$make("noisy_cat", quiet_target=TRUE),
              not(prints_text(msg)))
  m$remove_target("noisy_cat")
  expect_that(m$make("noisy_cat", quiet_target=FALSE),
              prints_text(msg))
})

test_that("Quiet maker", {
  msg <- "make some noise"
  cleanup()
  m <- maker$new("quiet.yml", verbose=FALSE)

  ## Next create a maker instance that suppresses output:
  m <- maker$new("quiet.yml", verbose=FALSE, quiet_target=TRUE)
  m$remove_target("noisy_message")
  expect_that(m$make("noisy_message"), not(shows_message()))
  m$remove_target("noisy_message")
  expect_that(m$make("noisy_message", quiet_target=FALSE),
              shows_message(msg))

  m$remove_target("noisy_cat")
  expect_that(m$make("noisy_cat"), not(prints_text(msg)))
  m$remove_target("noisy_cat")
  expect_that(m$make("noisy_cat", quiet_target=FALSE),
              prints_text(msg))
})

if (FALSE) {
test_that("Quiet chain", {
  cleanup()
  m <- maker$new("quiet.yml", verbose=FALSE)
  m$load_sources(FALSE)

  msg <- "make some noise"
  msg2 <- "make some more noise"
  msg_chain <- paste(msg, msg2, sep="\n")
  msg_chain <- c(msg, msg2)

  ## Shows both messages:
  m$remove_target("noisy_chain")
  expect_that(m$make("noisy_chain"), shows_message(msg))
  m$remove_target("noisy_chain")
  expect_that(m$make("noisy_chain"), shows_message(msg2))
  m$remove_target("noisy_chain")
  expect_that(m$make("noisy_chain", quiet_target=TRUE), not(shows_message()))
  m$remove_target("noisy_chain")
  expect_that(m$make("noisy_chain", quiet_target=FALSE), shows_message(msg))
  m$remove_target("noisy_chain")
  expect_that(m$make("noisy_chain", quiet_target=FALSE), shows_message(msg2))

  ## Shows no message
  m$remove_target("quiet_chain")
  expect_that(m$make("quiet_chain"), not(shows_message()))
  m$remove_target("quiet_chain")
  expect_that(m$make("quiet_chain", quiet_target=FALSE), not(shows_message()))
  m$remove_target("quiet_chain")
  expect_that(m$make("quiet_chain", quiet_target=TRUE), not(shows_message()))
})
}