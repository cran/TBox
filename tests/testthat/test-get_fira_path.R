testthat::test_that("path is correct", {
    testthat::expect_no_condition(object = {
        fira_path <- get_fira_path()
    })
    checkmate::expect_character(fira_path)
    testthat::expect_no_condition(normalizePath(fira_path,
                                                mustWork = TRUE))

    testthat::expect_identical(
        object = tools::file_ext(fira_path),
        expected = "ttf"
    )
})
