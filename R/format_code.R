
get_fira_path <- function() {
    return(system.file("extdata", "FiraCode", package = "TBox"))
}

generate_chunk_header <- function(...) {
    yaml_begining <- "```{r"
    yaml_ending <- "}"

    additional_args <- vapply(
        X = list(...),
        FUN = deparse,
        FUN.VALUE = character(1L)
    )

    # Check additionnal argument as knitr options
    checkmate::assert_character(
        x = names(additional_args),
        unique = TRUE, null.ok = TRUE
    )
    vapply(
        X = names(additional_args),
        FUN =  checkmate::assert_choice,
        choices = names(knitr::opts_chunk$get()),
        FUN.VALUE = character(1)
    )

    yaml_inter <- ifelse(
        test = length(additional_args) > 0L,
        yes = paste(",", names(additional_args),
                    "=", additional_args, collapse = ""),
        no = ""
    )

    return(paste0(
        yaml_begining,
        yaml_inter,
        yaml_ending
    ))
}

generate_rmd_file <- function(content,
                              output = "word",
                              font_size = 12,
                              code = TRUE,
                              fira_path = get_fira_path(),
                              ...) {

    has_xelatex <- nchar(Sys.which("xelatex")) > 0

    rmd_header <- paste0(
        "---\ntitle: \"Format code\"\noutput:\n  ",
        output,
        "_document:\n    highlight: arrow\n",
        ifelse(
            test = (output != "pdf"),
            yes = "monofont: \"Fira Code\"\n",
            no = ""
        ),
        ifelse(
            test = (output == "pdf" && has_xelatex),
            yes = "    latex_engine: xelatex\n",
            no = ""
        ),
        "code-block-bg: true\n",
        "code-block-border-left: \"#31BAE9\"\n",
        "---\n"
    )
    rmd_font_size <- ifelse(
        test = (output == "pdf"),
        yes = paste0("\n\\fontsize{", font_size, "}{", font_size, "}\n"),
        no = ""
    )
    rmd_monofont <- ifelse(
        test = (output == "pdf" && has_xelatex),
        yes = paste0(
            "\\setmonofont[ExternalLocation=",
            fira_path,
            "/]{FiraCode-Regular.ttf}\n"
        ),
        no = ""
    )

    rmd_body <- paste0(
        c(
            "\n## Running Code\n",
            ifelse(
                test = code,
                yes = generate_chunk_header(...),
                no = ""
            ),
            content,
            ifelse(
                test = code,
                yes = "```",
                no = ""
            )
        ),
        collapse = "\n"
    )

    return(paste0(rmd_header, rmd_font_size, rmd_monofont, rmd_body, "\n"))
}

#' @title Generate a file with formatted code
#' @description
#' Format a piece of code to copy it into an email, a pdf, a document, etc.
#'
#' @param output a string. The output format ("pdf", "html" or "word" are
#' accepted)
#' @param browser a string. The path to the browser which will open the
#' generated file format
#' @param font_size a numeric. The font size in pdf format.
#' @param code a boolean. Does the copied content is
#' @param ... other arguments passed to R chunk (for example eval = TRUE,
#' echo = FALSE...)
#'
#' @details
#' This function allows the user to generate formatted code (for email,
#' document, copy, message, etc.) on the fly.
#'
#' It accepts mainly word, pdf and html formats, but any format accepted by
#' rmarkdown on the computer.
#'
#' To use this function, simply copy a piece of code and run
#' \code{render_code()} with the arguments that interest us.
#' If you want content that is not R code, use the \code{code} argument to
#' \code{FALSE}.
#' In pdf format, you can change the font size using the \code{font_size}
#' argument.
#' Also, you can change the browser that opens the file by default with the
#' \code{browser} argument.
#' With the argument \dots, you can specify knitr arguments to be included in
#' the chunk. For example, you can add \code{eval = TRUE} (if you want the R
#' code to be evaluated (and the result displayed)), \code{echo = FALSE} (if
#' you don't want to display the code)... More information in the function
#' \code{\link[knitr]{opts_chunk}} or directly
#' \url{https://yihui.org/knitr/options/#chunk-options} to see all available
#' options and their descriptions.
#'
#' @returns This function returns invisibly (with \code{invisible()})
#' \code{NULL}.
#'
#' @export
#' @examples
#' # Copy a snippet of code
#' if (clipr::clipr_available()) {
#'     clipr::write_clip("plot(AirPassengers)", allow_non_interactive = TRUE)
#' }
#'
#' render_code(
#'     output = "word",
#'     echo = TRUE
#' )
#'
#' render_code(
#'     output = "html",
#'     eval = FALSE
#' )
#'
#' \donttest{
#' render_code(
#'     output = "pdf",
#'     eval = TRUE,
#'     font_size = 16
#' )
#' }
render_code <- function(output = "word",
                        browser = getOption("browser"),
                        font_size = 12,
                        code = TRUE,
                        ...) {

    if (!clipr::clipr_available()) {
        return(clipr::dr_clipr())
    }

    content <- clipr::read_clip(allow_non_interactive = TRUE) |>
        paste(collapse = "\n")

    rmd_content <- generate_rmd_file(
        content = content,
        output = output,
        font_size = font_size,
        code = code,
        ...
    )

    ext <- switch(
        output,
        word = ".docx",
        html = ".html",
        pdf = ".pdf"
    )

    rmd_file <- tempfile(pattern = "template", fileext = ".Rmd")
    out_file <- tempfile(pattern = "output", fileext = ext)

    write(rmd_content, file = rmd_file)
    rmarkdown::render(
        input = rmd_file,
        output_file = basename(out_file),
        output_dir = tempdir()
    )
    utils::browseURL(
        url = out_file |> normalizePath(mustWork = TRUE),
        browser = browser
    )

    return(invisible(NULL))
}
