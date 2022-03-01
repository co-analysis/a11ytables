
<!-- README.md is generated from README.Rmd. Please edit that file -->

# {a11ytables}

<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![CRAN
status](https://www.r-pkg.org/badges/version/a11ytables)](https://CRAN.R-project.org/package=a11ytables)
[![R-CMD-check](https://github.com/co-analysis/a11ytables/workflows/R-CMD-check/badge.svg)](https://github.com/co-analysis/a11ytables/actions)
[![Codecov test
coverage](https://codecov.io/gh/co-analysis/a11ytables/branch/main/graph/badge.svg)](https://codecov.io/gh/co-analysis/a11ytables?branch=main)
<!-- badges: end -->

## Purpose

{a11ytables} is a work-in-progress R package built around
[{openxlsx}](https://ycphs.github.io/openxlsx/) that aims to help you
comply with the latest guidance (June 2021) on [releasing statistics in
spreadsheets](https://gss.civilservice.gov.uk/policy-store/releasing-statistics-in-spreadsheets/)
from the [Best Practice and Impact
Division](https://github.com/best-practice-and-impact?language=html)
(BPID) of the UK’s [Government Statistical
Service](https://gss.civilservice.gov.uk/).

Visit [the {a11ytables}
website](https://co-analysis.github.io/a11ytables/) for documentation.

The package is under development. Please see [the NEWS
file](https://co-analysis.github.io/a11ytables/news/index.html) for
changes.

## How to use

You can install {a11ytables} from GitHub using {remotes}. The {openxlsx}
and {pillar} packages will be installed too.

``` r
install.packages("remotes")  # if not already installed
remotes::install_github("co-analysis/a11ytables")
library(a11ytables)
```

The package is designed with simplicity and minimal user input in mind.
There are only three steps to creating your output workbook:

1.  Create an a11ytable-class object by either:
    1.  passing data as arguments to `new_a11ytable()` (recommended)
    2.  creating a dataframe in the correct format and coercing it with
        `as_a11ytable()`
2.  Pass your a11ytables-class object to `create_a11y_wb()` to generate
    an {openxlsx} Workbook-class object with the required styling
3.  Write the workbook to a spreadsheet output with
    `openxlsx::saveWorkbook()`

Visit [the ‘construct an a11ytable’
vignette](https://co-analysis.github.io/a11ytables/articles/construct.html)
to see how to set up an a11ytable-class object. Visit [the ‘accessibilty
guidance checklist’
vignette](https://co-analysis.github.io/a11ytables/articles/accessibility.html)
to see how well the package adheres [to best
practice](https://gss.civilservice.gov.uk/policy-store/making-spreadsheets-accessible-a-brief-checklist-of-the-basics/).

## Example

### 1. Create a11ytable object

First, use `new_a11ytable()` to construct a special a11ytable-class
object, which is just a data.frame with strict requirements. It must
have a row per sheet, specific columns for meta information (e.g. sheet
titles, data sources) and a list-column of data.frames that contain the
actual data; run `?new_a11ytable` for details.

There’s a built-in demo dataset—`mtcars_df`, adapted from R’s built-in
mtcars demo dataset—that is already in the correct data.frame format
with the appropriate variables and content.

``` r
str(mtcars_df, max.level = 2)
# Classes 'tbl_df', 'tbl' and 'data.frame': 4 obs. of  6 variables:
#  $ tab_title  : chr  "Cover" "Contents" "Notes" "Table 1"
#  $ sheet_type : chr  "cover" "contents" "notes" "tables"
#  $ sheet_title: chr  "The mtcars demo datset: 'Motor Trend Car Road Tests'" "Table of contents" "Notes" "Motor Trend Car Road Tests"
#  $ source     : chr  NA NA NA "Motor Trend (1974)"
#  $ table_name : chr  "cover_sheet" "table_of_contents" "notes_table" "car_scores"
#  $ table      :List of 4
#   ..$ :'data.frame':  2 obs. of  2 variables:
#   ..$ :'data.frame':  2 obs. of  2 variables:
#   ..$ :'data.frame':  5 obs. of  2 variables:
#   ..$ :'data.frame':  32 obs. of  6 variables:
```

It can be coerced to a11ytable class with `as_a11ytable()`, since it’s
already structured correctly.

``` r
mtcars_a11ytable <- as_a11ytable(mtcars_df)
```

The `new_a11ytable()` and `as_a11ytable()` functions will run validation
on the generated object to ensure it meets the requirements of the
a11ytable class.

Note that the a11ytable object also has class ‘data.frame’ and can be
manipulated as such.

``` r
class(mtcars_a11ytable)  # see classes
# [1] "a11ytable"  "tbl"        "data.frame"
is_a11ytable(mtcars_a11ytable)  # check if a11ytable class
# [1] TRUE
```

The object also has class ‘tbl’, so it’s pretty-printed in {tibble}
style thanks to the imported {pillar} package.

``` r
mtcars_a11ytable
# # a11ytables: 4 x 6
#   tab_title sheet_type sheet_title                       source table_name table
#   <chr>     <chr>      <chr>                             <chr>  <chr>      <lis>
# 1 Cover     cover      The mtcars demo datset: 'Motor T… <NA>   cover_she… <df> 
# 2 Contents  contents   Table of contents                 <NA>   table_of_… <df> 
# 3 Notes     notes      Notes                             <NA>   notes_tab… <df> 
# 4 Table 1   tables     Motor Trend Car Road Tests        Motor… car_scores <df>
```

### 2. Convert to workbook

We can pass this a11ytable-class object to `create_a11y_wb()`, which
constructs an {openxlsx} Workbook-class object with appropriate styling
and markup.

``` r
mtcars_wb <- create_a11y_wb(mtcars_a11ytable)
```

<details>
<summary>
Click here to view the contents of the workbook
</summary>

``` r
mtcars_wb
# A Workbook object.
#  
# Worksheets:
#  Sheet 1: "Cover"
#  
#   Custom row heights (row: height)
#    2: 34, 4: 34 
#   Custom column widths (column: width)
#     1: 80 
#  
# 
#  Sheet 2: "Contents"
#  
#   Custom column widths (column: width)
#     1: 30, 2: 30 
#  
# 
#  Sheet 3: "Notes"
#  
#   Custom column widths (column: width)
#     1: 15, 2: 80 
#  
# 
#  Sheet 4: "Table 1"
#  
#   Custom column widths (column: width)
#     1: 16, 2: 16, 3: 16, 4: 16, 5: 16, 6: 16 
#  
# 
#  
#  Worksheet write order: 1, 2, 3, 4
#  Active Sheet 1: "Cover" 
#   Position: 1
```

</details>
<p>

### 3. Save

The Workbook-class object can be written to disk or opened temporarily
with spreadsheet software.

``` r
openxlsx::openXL(mtcars_wb)  # optionally open temp copy
openxlsx::saveWorkbook(mtcars_wb, "publication.xlsx")
```

The {a11ytables} packaged is designed for general use and to minimise
user interaction. As a result of this interface, the final output may
not suit your needs exactly and you may need to tweak it. It’s
recommended for maximum reproducibility that you record your adjustments
as code, rather than changing the content of the output file.

## Similar projects

BPID have themselves released [a Python package called
‘gptables’](https://github.com/best-practice-and-impact/gptables) to
help users produce such spreadsheets, but it’s based on a prior version
of the bset practice guidance. [That package will be
updated](https://github.com/best-practice-and-impact/gptables/issues/145),
but there’s a gap for this functionality—and for a dedicated R
package—at the time of writing (August 2021).

{a11ytables} is being developed with specific statistical releases in
mind, but the goal is to generalise it and perhaps have some
functionality absorbed into the development of
[gptables](https://github.com/best-practice-and-impact/gptables) in some
way.

## Code of Conduct

Please note that the {a11ytables} project is released with a
[Contributor Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

Cabinet Office users, please adhere to [the co-analysis Git and GitHub
code of conduct and usage
policy](https://docs.google.com/document/d/1CuNgKla1BwSVOmGkPmsq0S-OM4emP-iXrgnm7EeILWM/edit?usp=sharing).

Please [file an
issue](https://github.com/co-analysis/csstatsbulletin/issues) where
possible and provide meaningful commentary in any commits and pull
requests.

## Copyright

Copyright (c) 2022 Crown Copyright (Cabinet Office).

The code in this repository is released under the MIT license as per
[The GDS
Way](https://gds-way.cloudapps.digital/manuals/licensing.html#use-mit).
