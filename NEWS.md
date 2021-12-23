# a11ytables 0.0.0.9004

* BREAKING CHANGE: the `add_*()` function family for building a workbook are retired, given the introduction of `create_a11y_wb()`
* Introduced S3 class 'a11ytable', including exported functions to generate (`new_a11ytable()`, `as_a11ytable`) and test (`is_a11ytable`) objects of this class

# a11ytables 0.0.0.9002

* Simplify all `add_*()` functions to a single `create_a11y_wb()` function (moving towards #15), though `add_*()` functions are all still exported
* Split supplied data into two, with and without sub-table examples: `lfs_tables` and `lfs_subtables`, respectively
* Update README to detail simplified approach

# a11ytables 0.0.0.9001

* Added un-exported `.style_*()` utils functions to style worksheets (#1)
* Incorporated style functions into `add_*table()*` functions
* Updated README
* Basic tests, defensive stops (#10, #11)
* Added GitHub Actions for RMD check, coverage and {pkgdown} (#7)
* Transferred ownership from matt-dray to co-analysis (#9)

# a11ytables 0.0.0.9000

* Added a `NEWS.md`, `CODE_OF_CONDUCT.md`, `README.Rmd`
* Added exported `add_*()` functions to create different tab types (cover, contents, notes, tables)
* Added un-exported `.insert_*()` utils functions to insert within-sheet elements
* Added MIT license with `LICENSE.md`
