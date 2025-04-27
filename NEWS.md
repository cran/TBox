# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres
to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed

* lint package
* Solve bug related to font Fira on pdf

### Changed

* The rendering calls new Pandoc args for PDF and use the word template for word

### Added

* New function to detect latex-engine
* New function to create preamble.tex
* Checks for render_code
* tests for render_code
* style.css file
* Ligature added in Word and HTML files


## [0.2.1] - 2025-03-25

### Changed

* add `keep-tex` to keep the .tex filegenerated with pdf output


## [0.2.0] - 2025-01-22

### Fixed

* Linting

### Changed

* Minimal R version for tests (devel)

### Added

* New functions to import and export data in csv format


## [0.1.3] - 2024-08-23

### Removed

* pipe usage for R versions older than 4.1

### Added 

* new tests for all functions
* new inputs checks for `render_code()`
* test coverage with complete tests
* new argument `open` to open  (or not) the generated document
* template for word generated files


## [0.1.2] - 2024-06-14

### Added 

* hidden functions `generate_chunk_header()` and `generate_rmd_file()` to refactor the code and simplify the visibility.
* hidden functions `get_fira_path()` to get the path to the folder which contains the `.ttf` files
* new tests
* test coverage with `pandoc`, **{tinytex}** and `xclip` (for **Ubuntu**) installed


## [0.1.1] - 2024-06-13

### Changed

* `render_code()` now accept **knitr** chunk option as function arguments
* Add new dependencies: **knitr**` and **checkmate** to get all the different knitr options and to check the inputs of our functions


## [0.1.0] - 2024-06-13

### Added

* Initial commit [CRAN release]
* new function render_code to render some code on-the-fly to produce PDF, HTML, word and other format quickly by using the clickboard


[Unreleased]: https://github.com/TanguyBarthelemy/TBox/compare/v0.2.1...HEAD
[0.2.1]: https://github.com/TanguyBarthelemy/TBox/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/TanguyBarthelemy/TBox/compare/v0.1.3...v0.2.0
[0.1.3]: https://github.com/TanguyBarthelemy/TBox/compare/v0.1.2...v0.1.3
[0.1.2]: https://github.com/TanguyBarthelemy/TBox/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/TanguyBarthelemy/TBox/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/TanguyBarthelemy/TBox/releases/tag/v0.1.0
