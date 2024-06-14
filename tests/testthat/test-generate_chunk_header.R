
## Test qui fonctionnent

testthat::test_that("The header is well generated", {
    testthat::expect_identical(
        object = generate_chunk_header(eval = TRUE),
        expected = "```{r, eval = TRUE}"
    )
    testthat::expect_identical(
        object = generate_chunk_header(eval = TRUE, echo = FALSE),
        expected = "```{r, eval = TRUE, echo = FALSE}"
    )
    testthat::expect_identical(
        object = generate_chunk_header(eval = TRUE, echo = FALSE,
                                       include = TRUE),
        expected = "```{r, eval = TRUE, echo = FALSE, include = TRUE}"
    )
    testthat::expect_identical(
        object = generate_chunk_header(error = TRUE, results = "asis",
                                       comment = "##", background = "#E7E7E7"),
        expected = paste0("```{r, error = TRUE, results = \"asis\", ",
                          "comment = \"##\", background = \"#E7E7E7\"}")
    )
    testthat::expect_identical(
        object = generate_chunk_header(fig.width = 8.2, fig.height = 10,
                                       dpi = 124, warning = FALSE),
        expected = paste0("```{r, fig.width = 8.2, fig.height = 10, ",
                          "dpi = 124, warning = FALSE}")
    )
})

## Tests qui échouent

testthat::test_that("The header is well generated", {
    testthat::expect_error(object = generate_chunk_header(eval = TRUE,
                                                          eval = FALSE))
    testthat::expect_error(object = generate_chunk_header(Eval = FALSE))
    testthat::expect_error(object = generate_chunk_header(result = "markup"))
})
