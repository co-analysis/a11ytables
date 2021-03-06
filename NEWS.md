# a11ytables 0.1.0

## Breaking changes

* Renamed the `new_a11ytable()` function to `create_a11ytable()` (#27)
* Renamed the `create_a11y_wb()` function to `generate_workbook()` and changed the main argument from 'content' to 'a11ytable' (#27)
* Removed the 'table_names' argument to `create_a11ytable()` and instead autogenerate them from the user-provided 'tab_title' (#61)
* Introduced the `blank_cells` argument to `create_a11ytable()` so the user can provide a table-by-table reason for why cells might be empty (#62)
* Adjusted the in-built `mtcars_df` dataset to better fit the changes to the functions

## Docs

* Added a vignette to provide an overview of the code underlying the package so that it's easier for developers to contribute (#58)
* Added a vignette to explain the terminology of a spreadsheet, as used in the package (#58)
* Refer to the updated gptables Python package and the best practice spreadsheet guidance on the Analysis Function website (#73)
* Add hex logo (#81)
* Updated README and other vignettes to reflect changes to the function API
* Corrected various typos

## Miscellaneous

* Increased test coverage (#63)
* Updated user-input sanitising: it now removes punctuation in 'tab_title', inserts underscores in place of spaces and adds full-stops to blank_cells and source data (#78)
* Consolidated all a11ytable-class-related functioning into `as_a11ytable()` so that `create_a11ytable()` only has to build a data.frame from supplied arguments and apply `as_a11ytable()` to it (#80)
* Added warning for user if the 'blank_cells' argument is provided to `create_a11ytable()` but there are no blank cells in the table, and vice versa
* Updated content of RStudio Addins to reflect function and argument changes
* Adjusted default column widths in notes and contents
* Renamed files in R/ for consistency and clarity
* Switched to `inherits()` for class detection in `if()` statements

## Bugfixes

* Provided a warning, rather than error, if you don't provide any 'source' argument to `create_a11ytable()`.

# a11ytables 0.0.0.90015

* Added and improved warnings and errors (#34)
* Simplified the in-built dataset so it matches the 'get started' vignette
* Updated the gif used in the 'get started' vignette

# a11ytables 0.0.0.90014

* Added explanations to the accessibility checklist vignette
* Converted the 'quickstart' vignette to 'get started', used a simpler example, added gif
* Removed the 'construct' vignette
* Used 'reference' in _pkgdown.yaml to better separate functions on the site

# a11ytables 0.0.0.90013

* Added an RStudio Addin to insert code for an {a11ytables} workflow (#54)

# a11ytables 0.0.0.90012

* Made source, notes and table insertion dynamic, so the row of insertion of each is dependent on the others (#33)
* Applied table styling based on dynamic table placement (#33)

# a11ytables 0.0.0.90011

* Prevented the tab title being pasted into the titles of tables sheets (#48)
* Made sure to wrap non-header cells in tables sheets (#41)
* Provided an auto-column-width adjustment in tables where cell content or headers is long (#41)

# a11ytables 0.0.0.90010

* Added warnings if issues are detected when making an a11ytables-class object (#34)
* Added a modified mtcars example dataset, `mtcars_df` (#20)
* Expunged `lfs_tables` (#20)
* Added 'Crown Copyright' to authors as the copyright holder 
* Updated README and vignettes given these changes
* Added new quickstart vignette and simplified README (#43)
* Handled plurals and periods in meta sheet elements, update detection of notes in column headers

# a11ytables 0.0.0.9009

* HOTFIX: corrected `.detect_notes()` so it actually works
* Converted the `print` method to a `summary` method, as suggested by @TimTaylor (#23)
* Imported {pillar} for {tibble}-style printing, as suggested by @TimTaylor (#26)
* Added @TimTaylor as a contributor
* Updated vignettes and README

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
