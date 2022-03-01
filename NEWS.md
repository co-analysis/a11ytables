# a11ytables 0.0.0.90010

* Added warnings if issues are detected when making an a11ytables-class object (#34)
* Added a modified-mtcars example dataset, `mtcars_df` (#20)
* Expunged `lfs_tables` (#20)
* Added 'Crown Copyright' to authors as the copyright holder 
* Updated README and vignettes given these changes
* Handle plurals and periods in meta sheet elements, update detection of notes in column headers

# a11ytables 0.0.0.9009

* Converted the `print` method to a `summary` method, as suggested by @TimTaylor (#23)
* Imported {pillar} for {tibble}-style printing, as suggested by @TimTaylor (#26)
* Added @TimTaylor as a contributor
* Updated vignettes and README
* HOTFIX: corrected `.detect_notes()` so it actually works

# a11ytables 0.0.0.9008

* Ensured numeric columns (even if they contain a string like '[c]' to indicate a suppressed value) are right-aligned (#32)
* Isolated out `.insert_*()` functions for table count and note presence from `.insert_prelim_a11y()`, for clarity

# a11ytables 0.0.0.9007

* BREAKING CHANGE: removed subtables because they're not being used for now and are confusing
* Added the first draft vignettes on how to create an a11ytable and an accessibility guidance checklist (#22)

# a11ytables 0.0.0.9006

* HOTFIX: fixed a problem where the `tab_title` was being used to filter when it should have been `sheet_type`

# a11ytables 0.0.0.9005

* BREAKING CHANGE: the user-supplied table for the cover sheet should now be supplied as a tidy two-column data.frame with a row per subsection, with columns for the 'subsection title' and 'subsection body'
* Updated the `lfs_tables` and `lfs_subtables` example datasets given the above; for an example see `lfs_tables[lfs_tables$sheet_type == "cover", "table"][[1]]`

# a11ytables 0.0.0.9004

* BREAKING CHANGE: switched to using the `sheet_type` column of an a11ytable-class object to infer the sheet type as 'cover', 'contents', 'notes' or 'tables' (replacing 'meta'); it's no longer the `tab_title` that serves this role (#18).
* Ensured styles and `.add_*()` now make internal references to `sheet_type` rather than `tab_title`

# a11ytables 0.0.0.9003

* BREAKING CHANGE: retired fully the `add_*()` function family for building a workbook 'by hand', given the introduction of `create_a11y_wb()`
* Introduced S3 class 'a11ytable', including exported functions to generate (`new_a11ytable()`, `as_a11ytable()`) and test (`is_a11ytable()`) objects of this class

# a11ytables 0.0.0.9002

* Simplified all `add_*()` functions to a single `create_a11y_wb()` function (moving towards #15), though `add_*()` functions are all still exported
* Split supplied data into two, with and without sub-table examples: `lfs_tables` and `lfs_subtables`, respectively
* Updated README to detail simplified approach

# a11ytables 0.0.0.9001

* Added un-exported `.style_*()` utils functions to style worksheets (#1)
* Incorporated style functions into `add_*table()*` functions
* Updated README
* Added basic tests, defensive stops (#10, #11)
* Added GitHub Actions for RMD check, coverage and {pkgdown} (#7)
* Transferred ownership from matt-dray to co-analysis (#9)

# a11ytables 0.0.0.9000

* Added a `NEWS.md`, `CODE_OF_CONDUCT.md`, `README.Rmd`
* Added exported `add_*()` functions to create different tab types (cover, contents, notes, tables)
* Added un-exported `.insert_*()` utils functions to insert within-sheet elements
* Added MIT license with `LICENSE.md`
