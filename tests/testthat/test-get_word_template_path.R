testthat::test_that("path is correct", {
    testthat::expect_no_condition(object = {
        template_path <- get_word_template_path()
    })
    checkmate::expect_character(template_path)
    testthat::expect_no_condition(normalizePath(template_path,
                                                mustWork = TRUE))
    testthat::expect_identical(
        object = tools::file_ext(template_path),
        expected = "docx"
    )
})
