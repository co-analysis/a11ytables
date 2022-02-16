# a11ytables 0.0.0.9006

* HOTFIX: fixed a problem where the `tab_title` was being used to filter when it should have been `sheet_type`

# a11ytables 0.0.0.9005

* BREAKING CHANGE: the user-supplied table for the cover sheet should now be supplied as a tidy two-column data.frame with a row per subsection, with columns for the `subsection_title` and `subsection_body` (suggesetd names)
* The `lfs_tables` and `lfs_subtables` example datasets have been updated accordingly; for an example see `lfs_tables[lfs_tables$sheet_type == "cover", "table"][[1]]`

# a11ytables 0.0.0.9004

* BREAKING CHANGE: the `sheet_type` column of an a11ytable-class object is now used to infer the sheet type as 'cover', 'contents', 'notes' or 'tables' (replacing 'meta'); it's no longer the `tab_title` that serves this role (#18).
* Ensured styles and `.add_*()` now make internal references to `sheet_type` rather than `tab_title`

# a11ytables 0.0.0.9003

* BREAKING CHANGE: fully retired the `add_*()` function family for building a workbook 'by hand', given the introduction of `create_a11y_wb()`
* Introduced S3 class 'a11ytable', including exported functions to generate (`new_a11ytable()`, `as_a11ytable()`) and test (`is_a11ytable()`) objects of this class

# a11ytables 0.0.0.9002

* Simplified all `add_*()` functions to a single `create_a11y_wb()` function (moving towards #15), though `add_*()` functions are all still exported
* Split supplied data into two, with and without sub-table examples: `lfs_tables` and `lfs_subtables`, respectively
* Updated README to detail simplified approach

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
