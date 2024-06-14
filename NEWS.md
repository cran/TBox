# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres
to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added 

* hidden functions `generate_chunk_header()` and `generate_rmd_file()` to refactor the code and simplify the visibility.
* hidden functions `get_fira_path()` to get the path to the folder which contains the `.ttf` files
* new tests
* test coverage with pandoc, tinytex and xclip (for ubuntu) installed


## [0.1.1]

### Changed

* `render_code` now accept **knitr** chunk option as function arguments
* Add new dependencies: **knitr**` and **checkmate** to get all the different knitr options and to check the inputs of our functions


## [0.1.0] - CRAN release

### Added

* Initial commit
* new function render_code to render some code on-the-fly to produce PDF, HTML, word and other format quickly by using the clickboard


[Unreleased]: https://github.com/TanguyBarthelemy/TBox/compare/v0.1.1...HEAD
[0.1.1]: https://github.com/TanguyBarthelemy/TBox/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/TanguyBarthelemy/TBox/releases/tag/v0.1.0
