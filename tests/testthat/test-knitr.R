context("Knitr")

test_that("Defaults", {
  expect_that(knitr::opts_chunk$get("fig.path"),
              equals("figure/"))
})

test_that("Build Rmd works", {
  cleanup()
  m <- remake("knitr.yml")
  remake_make(m, "knitr.md")
  expect_that(file.exists("knitr.md"), is_true())
  expect_that(is_directory("figure"), is_true())
  expect_that(file.exists("figure/unnamed-chunk-2-1.png"),
              is_true())
  expect_that(knitr::opts_chunk$get("fig.path"),
              equals("figure/"))
  cleanup()
})

test_that("Build Rnw works", {
  cleanup()
  m <- remake("knitr.yml")
  ## TODO: This gives a warning because knitr is trying to look for
  ## framed.sty and doing a pretty terrible job at it.  This also
  ## produces the warning about
  ##   sh: 1: kpsewhich: not found
  ## which can't be suppressed.
  suppressWarnings(remake_make(m, "knitr.tex"))
  expect_that(file.exists("knitr.tex"), is_true())
  expect_that(is_directory("figure"), is_true())
  expect_that(file.exists("figure/unnamed-chunk-2-1.pdf"),
              is_true())
  expect_that(knitr::opts_chunk$get("fig.path"),
              equals("figure/"))
  cleanup()
})

test_that("Script", {
  cleanup()
  m <- remake("knitr.yml")
  src <- remake_script(m, "knitr.md")
  expect_that(last(src), equals('knitr::knit("knitr.Rmd", "knitr.md")'))
})

test_that("knitr depends (file only)", {
  cleanup()
  m <- remake("knitr_file_dep.yml")
  expect_that(file.exists("data.csv"), is_false())
  remake_make(m)
  expect_that(file.exists("data.csv"), is_true())
})

test_that("knitr options", {
  cleanup()
  m <- remake("knitr_opts.yml")
  remake_make(m, "knitr.md")

  ## Check I have the default knitr options:
  expect_that(knitr::opts_chunk$get("fig.path"), equals("figure/"))
  expect_that(knitr::opts_chunk$get("tidy"), is_false())

  ## This should dump out figures in a special place because the
  ## fig.path option was set:
  expect_that(dir("figure"), equals("myprefix_unnamed-chunk-2-1.png"))

  ## But leaves the gloal options unchanged:
  expect_that(knitr::opts_chunk$get("fig.path"), equals("figure/"))
  expect_that(knitr::opts_chunk$get("tidy"), is_false())

  cleanup()
})

test_that("Option sets", {
  cleanup()
  m <- remake("knitr_options.yml")
  t <- m$targets[["knitr.md"]]
  dat <- yaml_read("knitr_options.yml")
  cmp <- c(dat$knitr_options$mystyle, list(input="knitr.Rmd"))
  cmp$options$error <- FALSE
  expect_that(t$knitr, equals(cmp))
})

test_that("auto_figure_prefix", {
  cleanup()
  m <- remake("knitr_prefix.yml")
  remake_make(m, "knitr.md")
  expect_that(file.exists("knitr.md"), is_true())
  expect_that(is_directory("figure"), is_true())
  expect_that(file.exists("figure/knitr__unnamed-chunk-2-1.png"),
              is_true())
  ## Knitr options reset:
  expect_that(knitr::opts_chunk$get("fig.path"),
              equals("figure/"))
  cleanup()
})

test_that("Errors during compilation propagate", {
  cleanup()
  m <- remake("knitr_error.yml")
  expect_that(remake_make(m, "knitr_rename.md"), throws_error())
  t <- m$targets[["knitr_rename.md"]]
  expect_that(t$knitr$options$error, is_false())
  t$knitr$options$error <- TRUE
  m$targets[["knitr_rename.md"]] <- t
  expect_that(remake_make(m, "knitr_rename.md"), not(throws_error()))
})

test_that("Renaming exported objects", {
  cleanup()
  m <- remake("knitr_rename.yml")
  remake_make(m, "knitr_rename.md")
})
