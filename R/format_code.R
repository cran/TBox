
#' @title The latex engine
#'
#' @description
#' This function returns the latex engine available to render .tex file into
#' pdf.
#'
#' @returns a character vector of length 1 representing the latex engine.
#'
#' @details
#' If several latex engine are available, the choice will be done in this order:
#'
#' \itemize{
#' \item xelatex;
#' \item lualatex;
#' \item pdflatex;
#' \item tectonic.
#' }
#'
#' @export
#'
#' @examples
#' get_latex_engine()
#'
get_latex_engine <- function() {
    if (nzchar(Sys.which("xelatex"))) {
        return("xelatex")
    } else if (nzchar(Sys.which("lualatex"))) {
        return("lualatex")
    } else if (nzchar(Sys.which("pdflatex"))) {
        return("pdflatex")
    } else if (nzchar(Sys.which("tectonic"))) {
        return("tectonic")
    } else {
        return("")
    }
}

#' @title Create preamble .tex for code font
#'
#' @param font_size a numeric. The font size, only available in pdf format.
#' @param monofont_path a string. The path to the font used to render code
#' chunks. It should link to a \code{.ttf} file. Only available in pdf format.
#'
#' @returns a vector of characters representing an Rmd file (each element being
#' a line)
#'
#' @export
#'
#' @examples
#'
#' create_preamble_tex()
#' create_preamble_tex(font_size = 18.0)
#'
create_preamble_tex <- function(
        font_size = 12.0,
        monofont_path = get_fira_path()) {

    # Check
    checkmate::assert_number(x = font_size, lower = 1L, na.ok = FALSE,
                             null.ok = FALSE, finite = TRUE)
    monofont_path <- normalizePath(monofont_path, winslash = "/",
                                   mustWork = TRUE)

    latex_engine <- get_latex_engine()
    preamble_tex <- paste0("\\fontsize{", font_size, "}{", font_size, "}")
    if (latex_engine %in% c("xelatex", "lualatex")) {
        font_dir <- dirname(monofont_path)
        font_file <- basename(monofont_path)
        preamble_tex <- c(
            preamble_tex,
            paste0(
                "\\setmonofont[ExternalLocation=",
                font_dir, "/]{", font_file, "}"
            ),
            "\\makeatletter",
            "\\def\\verbatim@nolig@list{}",
            "\\makeatother"
        )
    }

    return(preamble_tex)
}

#' @title The path to the font Fira Code
#'
#' @description
#' This function returns the path to the font Fira Code installed with
#' the package TBox.
#'
#' @returns a character vector of length 1 representing the path
#'
#' @details
#' This function helps the other functions to find the path to the font Fira
#' Code to render documents and use this font by default for code chunks.
#'
#' @export
#'
#' @examples
#' get_fira_path()
#'
get_fira_path <- function() {
    fira_path <- system.file("extdata", "FiraCode", "FiraCode-Regular.ttf",
                             package = "TBox")
    fira_path <- normalizePath(fira_path, winslash = "/", mustWork = FALSE)
    return(fira_path)
}

#' @title The path to the word template
#'
#' @description
#' This function returns the path to the word template installed with
#' the package TBox.
#'
#' @returns a character vector of length 1 representing the path
#'
#' @details
#' This function helps the other functions to find the template of the word
#' document used to render in \code{.docx} output.
#'
#' @export
#'
#' @examples
#' get_word_template_path()
#'
get_word_template_path <- function() {
    word_template_path <- system.file("extdata", "template.docx",
                                      package = "TBox")
    word_template_path <- normalizePath(word_template_path,
                                        winslash = "/",
                                        mustWork = FALSE)
    return(word_template_path)
}

#' @title Generate R chunk header
#'
#' @description
#' Function to generate R chunk header for rmarkdown rendering in different
#' output
#'
#' @param ... The different options for R code chunks.
#'
#' @returns a string of length 1
#'
#' @details
#' To get the list of all accepted options, you can call
#' \code{names(knitr::opts_chunk$get())} and to get the default values you can
#' call \code{knitr::opts_chunk$get()}.
#'
#' More information in the function #' \code{\link[knitr]{opts_chunk}} or
#' directly \url{https://yihui.org/knitr/options/#chunk-options} to see all
#' available options and their descriptions.
#'
#' @export
#'
#' @examples
#'
#' generate_chunk_header()
#' generate_chunk_header(eval = TRUE, echo = TRUE)
#' generate_chunk_header(results = "asis")
#' generate_chunk_header(fig.width = "4px", fig.height = "3px")
#'
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
        choices = names(knitr::opts_chunk[["get"]]()),
        FUN.VALUE = character(1L)
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

#' @title Generate Rmd file
#' @description
#' This function creates the Rmd file which will be rendered in a specific
#' format.
#'
#' @param content a string. The body of the Rmd file (for example code or text)
#' @param output_format a string representing the output format. The values
#' \code{"pdf"}, \code{"html"} or \code{"word"} and their knitr equivalent
#' \code{"pdf_document"}, \code{"html_document"} or \code{"word_document"} are
#' accepted.
#' @param code a boolean. Should the \code{content} string have to be inserted
#' in R chunk or is it just text? Default is TRUE (so the \code{content} will be
#' inserted in R chunk).
#' @param \dots other arguments passed to R chunk (for example
#' \code{eval = TRUE}, \code{echo = FALSE}...)
#'
#' @returns a vector of characters representing an Rmd file (each element being
#' a line)
#'
#' @details
#' More information about the argument \dots in the  documentation of the
#' function \code{\link[TBox]{render_code}}.
#'
#' @export
#'
#' @examples
#'
#' generate_rmd_file(content = "Bonjour tout le monde",
#'                   code = FALSE,
#'                   output_format = "word")
#' generate_rmd_file(content = "print(AirPassengers)",
#'                   code = TRUE,
#'                   output_format = "pdf",
#'                   eval = TRUE,
#'                   echo = FALSE)
#' generate_rmd_file(content = "plot(AirPassengers)",
#'                   code = TRUE,
#'                   output_format = "html_document",
#'                   eval = FALSE,
#'                   echo = TRUE)
#'
generate_rmd_file <- function(
        content,
        output_format = c("word", "pdf", "html",
                          "word_document", "pdf_document", "html_document"),
        code = TRUE,
        ...) {

    output_format <- match.arg(output_format)
    output_format <- gsub(x = output_format,
                          pattern = "_document$",
                          replacement = "",
                          perl = TRUE, fixed = FALSE)

    # Check content
    checkmate::assert_character(content)
    # Check code
    checkmate::assert_logical(code)

    rmd_header <- c(
        "---",
        "title: \"Format code\"",
        paste0("output: ", output_format, "_document"),
        "code-block-bg: true",
        "code-block-border-left: \"#31BAE9\"",
        "---",
        ""
    )

    rmd_body <- c(
        "",
        "## Running Code",
        "",
        ifelse(test = code, yes = generate_chunk_header(...), no = ""),
        content,
        ifelse(test = code, yes = "```", no = "")
    )

    return(c(rmd_header, rmd_body))
}

#' @title Generate a file with formatted code
#' @description
#' Format a piece of code to copy it into an email, a pdf, a document, etc.
#'
#' @param output_format a string representing the output format. The values
#' "pdf", "html" or "word" and their knitr equivalent "pdf_document",
#' "html_document" or "word_document" are accepted.
#' @param browser a string. The path to the browser which will open the
#' generated file format
#' @param code a boolean. Should the copied content have to be inserted in R
#' chunk or is it just text? Default is TRUE (so the copied content will be
#' inserted in R chunk).
#' @param open a boolean. Default is TRUE meaning that the document will open
#' automatically after being generated.
#' @param word_template_path a string. The path to the word template file used
#' when rendering with word. By default, the template used is the one included
#' in the package. Only used with word output.
#' @param ... other arguments passed to R chunk (for example eval = TRUE,
#' echo = FALSE...)
#' @inheritParams create_preamble_tex
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
#'
#' With the argument \dots, you can specify knitr arguments to be included in
#' the chunk. For example, you can add \code{eval = TRUE} (if you want the R
#' code to be evaluated (and the result displayed)), \code{echo = FALSE} (if
#' you don't want to display the code)...
#'
#' More information in the function \code{\link[knitr]{opts_chunk}} or directly
#' \url{https://yihui.org/knitr/options/#chunk-options} to see all available
#' options and their descriptions.
#'
#' If the \code{open} argument is set to \code{FALSE} then the \code{browser}
#' argument will be ignored.
#'
#' @returns This function returns invisibly (with \code{invisible()}) a vector
#' of length two with two element:
#'
#' \itemize{
#' \item the path of the created rmarkdown (template) document (\code{.Rmd});
#' \item the path of the created output (in the format \code{.pdf},
#' \code{.docx} or \code{.html}).
#' }
#'
#' @export
#' @examples
#' # Copy a snippet of code
#' if (clipr::clipr_available()) {
#'     clipr::write_clip("plot(AirPassengers)", allow_non_interactive = TRUE)
#' }
#'
#' render_code(
#'     output_format = "word",
#'     echo = TRUE
#' )
#'
#' render_code(
#'     output_format = "html",
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
render_code <- function(
        output_format = c("word", "pdf", "html",
                          "word_document", "pdf_document", "html_document"),
        browser = getOption("browser"),
        font_size = 12.0,
        code = TRUE,
        open = TRUE,
        monofont_path = get_fira_path(),
        word_template_path = get_word_template_path(),
        ...) {

    if (!clipr::clipr_available()) {
        return(clipr::dr_clipr())
    }

    # Check
    checkmate::assert_number(x = font_size, lower = 1L, na.ok = FALSE,
                             null.ok = FALSE, finite = TRUE)
    monofont_path <- normalizePath(monofont_path, winslash = "/",
                                   mustWork = TRUE)
    word_template_path <- normalizePath(word_template_path, winslash = "/",
                                        mustWork = TRUE)

    output_format <- match.arg(output_format)
    output_format <- gsub(x = output_format,
                          pattern = "_document$",
                          replacement = "",
                          perl = TRUE, fixed = FALSE)

    checkmate::assert_logical(code)
    checkmate::assert_logical(open)

    ext <- switch(
        output_format,
        word = ".docx",
        html = ".html",
        pdf = ".pdf"
    )

    out_dir <- tempfile(pattern = "render_code", fileext = "")
    dir.create(out_dir, showWarnings = TRUE, recursive = TRUE)

    rmd_file <- file.path(out_dir, "template.Rmd")
    out_file <- file.path(out_dir, paste0("output", ext))

    if (output_format == "pdf") {
        latex_engine <- get_latex_engine()
        preamble_tex <- create_preamble_tex(font_size, monofont_path)
        preamble_file <- file.path(out_dir, "preamble.tex")
        write(preamble_tex, file = preamble_file)
    }
    if (output_format == "html") {
        style_file <-  system.file("extdata", "style.css", package = "TBox")
        style_file <- normalizePath(style_file, winslash = "/", mustWork = TRUE)
    }

    content <- clipr::read_clip(allow_non_interactive = TRUE)
    rmd_content <- generate_rmd_file(
        content = content,
        output_format = output_format,
        code = code,
        ...
    )

    write(rmd_content, file = rmd_file)

    rmarkdown::render(
        input = rmd_file,
        output_file = basename(out_file),
        output_dir = out_dir,
        output_format = switch(
            output_format,
            pdf = rmarkdown::pdf_document(
                highlight = "arrow",
                fig_crop = TRUE,
                keep_tex = TRUE,
                latex_engine = latex_engine,
                includes = rmarkdown::includes(before_body = preamble_file)
            ),
            word = rmarkdown::word_document(
                highlight = "arrow",
                reference_docx = word_template_path
            ),
            html = rmarkdown::html_document(
                highlight = "arrow",
                css = style_file
            )
        )
    )

    if (interactive() && open) {
        utils::browseURL(
            url = normalizePath(out_file, mustWork = TRUE),
            browser = browser # nolint undesirable_function_linter
        )
    }

    return(invisible(normalizePath(out_dir, mustWork = TRUE)))
}
