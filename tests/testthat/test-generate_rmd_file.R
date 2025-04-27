
testthat::test_that("Everything works with default parameters", {

    exp1 <- readLines(testthat::test_path("template_rmd", "default",
                                          "template_word.Rmd"))
    obj1_a <- generate_rmd_file(
        output_format = "word",
        content = "plot(AirPassengers)"
    )
    obj1_b <- generate_rmd_file(
        output_format = "word_document",
        content = "plot(AirPassengers)"
    )

    testthat::expect_identical(object = obj1_a, expected = exp1)
    testthat::expect_identical(object = obj1_b, expected = exp1)


    exp2 <- readLines(testthat::test_path("template_rmd", "default",
                                          "template_html.Rmd"))
    obj2_a <- generate_rmd_file(output_format = "html",
                                content = "plot(AirPassengers)")
    obj2_b <- generate_rmd_file(output_format = "html_document",
                                content = "plot(AirPassengers)")

    testthat::expect_identical(object = obj2_a, expected = exp2)
    testthat::expect_identical(object = obj2_b, expected = exp2)


    exp3 <- readLines(testthat::test_path(
        "template_rmd",
        "default",
        paste0("template_pdf.Rmd")
    ))
    obj3_a <- generate_rmd_file(
        output_format = "pdf",
        content = "plot(AirPassengers)"
    )
    obj3_b <- generate_rmd_file(
        output_format = "pdf_document",
        content = "plot(AirPassengers)"
    )

    testthat::expect_identical(object = obj3_a, expected = exp3)
    testthat::expect_identical(object = obj3_b, expected = exp3)
})

testthat::test_that("Everything works with custom parameters", {

    exp1 <- readLines(testthat::test_path("template_rmd", "custom",
                                          "template_word_1.Rmd"))
    obj1_a <- generate_rmd_file(
        output_format = "word",
        content = "Bonjour tout le monde",
        code = FALSE
    )
    obj1_b <- generate_rmd_file(
        output_format = "word_document",
        content = "Bonjour tout le monde",
        code = FALSE
    )

    testthat::expect_identical(object = obj1_a, expected = exp1)
    testthat::expect_identical(object = obj1_b, expected = exp1)


    exp2 <- readLines(testthat::test_path("template_rmd", "custom",
                                          "template_html_1.Rmd"))
    obj2_a <- generate_rmd_file(output_format = "html",
                                content = "Bonjour tout le monde",
                                code = FALSE)
    obj2_b <- generate_rmd_file(output_format = "html_document",
                                content = "Bonjour tout le monde",
                                code = FALSE)

    testthat::expect_identical(object = obj2_a, expected = exp2)
    testthat::expect_identical(object = obj2_b, expected = exp2)


    exp3 <- readLines(testthat::test_path(
        "template_rmd",
        "custom",
        paste0("template_pdf_1.Rmd")
    ))
    obj3_a <- generate_rmd_file(
        output_format = "pdf",
        content = "Bonjour tout le monde",
        code = FALSE
    )
    obj3_b <- generate_rmd_file(
        output_format = "pdf_document",
        content = "Bonjour tout le monde",
        code = FALSE
    )

    testthat::expect_identical(object = obj3_a, expected = exp3)
    testthat::expect_identical(object = obj3_b, expected = exp3)


    exp4 <- readLines(testthat::test_path("template_rmd", "custom",
                                          "template_word_2.Rmd"))
    obj4_a <- generate_rmd_file(
        output_format = "word",
        content = "plot(AirPassengers)",
        eval = TRUE
    )
    obj4_b <- generate_rmd_file(
        output_format = "word_document",
        content = "plot(AirPassengers)",
        eval = TRUE
    )

    testthat::expect_identical(object = obj4_a, expected = exp4)
    testthat::expect_identical(object = obj4_b, expected = exp4)


    exp5 <- readLines(testthat::test_path("template_rmd", "custom",
                                          "template_html_2.Rmd"))
    obj5_a <- generate_rmd_file(output_format = "html",
                                content = "plot(AirPassengers)",
                                eval = TRUE)
    obj5_b <- generate_rmd_file(output_format = "html_document",
                                content = "plot(AirPassengers)",
                                eval = TRUE)

    testthat::expect_identical(object = obj5_a, expected = exp5)
    testthat::expect_identical(object = obj5_b, expected = exp5)


    exp6 <- readLines(testthat::test_path(
        "template_rmd",
        "custom",
        paste0("template_pdf_2.Rmd")
    ))
    obj6_a <- generate_rmd_file(
        output_format = "pdf",
        content = "plot(AirPassengers)",
        eval = TRUE
    )
    obj6_b <- generate_rmd_file(
        output_format = "pdf_document",
        content = "plot(AirPassengers)",
        eval = TRUE
    )

    testthat::expect_identical(object = obj6_a, expected = exp6)
    testthat::expect_identical(object = obj6_b, expected = exp6)
})
