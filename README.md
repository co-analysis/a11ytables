
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
[{openxlsx}](https://ycphs.github.io/openxlsx/) that aims helps you
comply with the latest guidance (June 2021) on [releasing statistics in
spreadsheets](https://gss.civilservice.gov.uk/policy-store/releasing-statistics-in-spreadsheets/)
from the [Best Practice and Impact
Division](https://github.com/best-practice-and-impact?language=html)
(BPID) of the UK’s [Government Statistical
Service](https://gss.civilservice.gov.uk/).

Visit [the {a11ytables}
website](https://co-analysis.github.io/a11ytables/) for documentation.

The code is under development and current API features may change in
future releases. Please see [the NEWS
file](https://co-analysis.github.io/a11ytables/news/index.html) for
details.

## Install and use

You can install {a11ytables} from GitHub using {remotes}. The {openxlsx}
package will be installed too.

``` r
install.packages("remotes")
remotes::install_github("co-analysis/a11ytables")
library(a11ytables)
```

To use:

1.  Get your data into an a11ytables-class object using
    `new_a11ytable()`, or create a data.frame in the required format and
    coerce it with `as_a11ytable()`
2.  Pass your a11ytables-class object to `create_a11y_wb()` to populate
    an {openxlsx} Workbook-class object
3.  Write the workbook to a spreadsheet output with
    `openxlsx::saveWorkbook()`

See [the ‘construct an a11ytable’
vignette](https://co-analysis.github.io/a11ytables/articles/construct.html)
to see how to set up an a11ytable-class object. See [the ‘accessibilty
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

There’s a built-in demo dataset—`lfs_tables`, adapted from [the
releasing statistics in spreadsheets
guidance](https://gss.civilservice.gov.uk/policy-store/releasing-statistics-in-spreadsheets/)—that
is already in the correct data.frame format.

``` r
str(lfs_tables, max.level = 2)
#> Classes 'tbl_df', 'tbl' and 'data.frame':    5 obs. of  6 variables:
#>  $ tab_title  : chr  "cover" "contents" "notes" "1" ...
#>  $ sheet_type : chr  "cover" "contents" "notes" "tables" ...
#>  $ sheet_title: chr  "Labour market overview data tables, UK, December 2020 (accessibility example)" "Table of contents" "Notes" "Number and percentage of population aged 16 and over in each labour market activity group, UK, seasonally adjusted" ...
#>  $ source     : chr  NA NA NA "Labour Force Survey" ...
#>  $ table_name : chr  "Cover_content" "Table_of_contents" "Notes_table" "Labour_market_summary_for_16_and_over" ...
#>  $ table      :List of 5
#>   ..$ :Classes 'tbl_df', 'tbl' and 'data.frame': 8 obs. of  2 variables:
#>   ..$ :Classes 'tbl_df', 'tbl' and 'data.frame': 2 obs. of  5 variables:
#>   ..$ :Classes 'tbl_df', 'tbl' and 'data.frame': 11 obs. of  2 variables:
#>   ..$ :Classes 'tbl_df', 'tbl' and 'data.frame': 6 obs. of  10 variables:
#>   ..$ :Classes 'tbl_df', 'tbl' and 'data.frame': 6 obs. of  9 variables:
```

It can be coerced to a11ytable class with `as_a11ytable()`, since it’s
already structured correctly.

``` r
lfs_a11ytable <- as_a11ytable(lfs_tables)
class(lfs_a11ytable)  # see classes
#> [1] "a11ytable"  "tbl"        "data.frame"
is_a11ytable(lfs_a11ytable)  # check if a11ytable class
#> [1] TRUE
```

Note that the object also has class ‘data.frame’ and can be manipulated
as such.

The `new_a11ytable()` and `as_a11ytable()` functions will run validation
on the generated object to ensure it meets the requirements of the
a11ytable class.

The object is pretty-printed in {tibble} style thanks to the imported
{pillar} package and the inheritance of the ‘tbl’ class.

``` r
lfs_a11ytable
#> # a11ytables: 5 x 6
#>   tab_title sheet_type sheet_title                    source table_name table   
#>   <chr>     <chr>      <chr>                          <chr>  <chr>      <list>  
#> 1 cover     cover      Labour market overview data t… <NA>   Cover_con… <tbl_df>
#> 2 contents  contents   Table of contents              <NA>   Table_of_… <tbl_df>
#> 3 notes     notes      Notes                          <NA>   Notes_tab… <tbl_df>
#> 4 1         tables     Number and percentage of popu… Labou… Labour_ma… <tbl_df>
#> 5 2         tables     Number and percentage of popu… Labou… Labour_ma… <tbl_df>
```

### 2. Convert to workbook

We can pass this a11ytable-class object to `create_a11y_wb()`, which
constructs an {openxlsx} Workbook-class object with
accessibility-appropriate styling.

``` r
lfs_wb <- create_a11y_wb(lfs_a11ytable)
```

<details>
<summary>
Click here to view the contents of the workbook
</summary>

``` r
lfs_wb
#> A Workbook object.
#>  
#> Worksheets:
#>  Sheet 1: "cover"
#>  
#>  Custom row heights (row: height)
#>   2: 34, 4: 34, 6: 34, 8: 34, 10: 34, 12: 34, 14: 34, 16: 34 
#>  Custom column widths (column: width)
#>    1: 80 
#>  
#> 
#>  Sheet 2: "contents"
#>  
#>  Custom column widths (column: width)
#>    1: 30, 2: 30, 3: 30, 4: 30, 5: 30 
#>  
#> 
#>  Sheet 3: "notes"
#>  
#>  Custom column widths (column: width)
#>    1: 15, 2: 80 
#>  
#> 
#>  Sheet 4: "1"
#>  
#>  Custom column widths (column: width)
#>    1: 16, 2: 16, 3: 16, 4: 16, 5: 16, 6: 16, 7: 16, 8: 16, 9: 16, 10: 16 
#>  
#> 
#>  Sheet 5: "2"
#>  
#>  Custom column widths (column: width)
#>    1: 16, 2: 16, 3: 16, 4: 16, 5: 16, 6: 16, 7: 16, 8: 16, 9: 16 
#>  
#> 
#>  
#>  Worksheet write order: 1, 2, 3, 4, 5
#>  Active Sheet 1: "cover" 
#>  Position: 1
```

</details>
<p>

### 3. Save

This output can be written to disk or opened temporarily with
spreadsheet software.

``` r
openxlsx::openXL(lfs_wb)  # optionally open temp copy
openxlsx::saveWorkbook(lfs_wb, "publication.xlsx")
```

## Similar projects

BPID have themselves released [a Python package called
‘gptables’](https://github.com/best-practice-and-impact/gptables) to
help users produce such spreadsheets, but it’s based on a prior version
of the guidance. [That package will be
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

Copyright (c) 2021 Crown Copyright (Cabinet Office).

The code in this repository is released under the MIT license as per
[The GDS
Way](https://gds-way.cloudapps.digital/manuals/licensing.html#use-mit).
