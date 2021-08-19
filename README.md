
<!-- README.md is generated from README.Rmd. Please edit that file -->

# {a11ytables}

<!-- badges: start -->

[![Project Status: Concept – Minimal or no implementation has been done
yet, or the repository is only intended to be a limited example, demo,
or
proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
<!-- badges: end -->

{a11ytables} is a work-in-progress R package to construct spreadsheets
that comply with the latest guidance (June 2021) on [releasing
statistics in
spreadsheets](https://gss.civilservice.gov.uk/policy-store/releasing-statistics-in-spreadsheets/)
from the Best Practice and Impact Division (BPID) of the UK’s Government
Statistical Service.

BPID have themselves released [a Python package called
‘gptables’](https://github.com/best-practice-and-impact/gptables) to
help users produce such spreadsheets, but it’s based on a prior version
of the guidance. [That package will be
updated](https://github.com/best-practice-and-impact/gptables/issues/145),
but there’s a gap for this functionality—and for a dedicated R
package—at the time of writing (August 2021).

{a11ytables} is being developed with Cabinet Office statistical releases
in mind, but the goal is to generalise it and perhaps have some
functionality absorbed into the development of
[gptables](https://github.com/best-practice-and-impact/gptables) in some
way.

## Install

You can install the in-development version of {a11ytables} from GitHub.
The remotes package is a good way to achieve this.

``` r
install.packages("remotes")
remotes::install_github("co-analysis/a11ytables")
library(a11ytables)
```

The package depends on {openxlsx} for constructing workbooks and {purrr}
for readable function iteration. Both are imported with {a11ytables}.

At time of writing, you would do something like this to generate a
publication:

``` r
example_wb <- openxlsx::createWorkbook() |>
  add_tabs(lfs_tables) |>
  add_cover(lfs_tables) |>
  add_contents(lfs_tables) |>
  add_notes(lfs_tables) |>
  add_tables(lfs_tables, "1a")

openxlsx::saveWorkbook(example_wb, "output/publication.xlsx")
```

## Concept

A *workbook* is made of *sheets*. There are two types of sheet: *meta*
(*cover*, *contents* and optional *notes*) and *tables*. Sheets are
built from *elements*, which includes the title, an announcement on the
number of tables/presence of notes, an announcement of the source, and
the tables themselves

You can build each *sheet* type using the `add_*()` functions. Each one
creates a sheet that is inserted into a named {openxlsx} Workbook-class
object using data from a user-supplied *contents* object.

The *contents* object has a very particular format. It’s a
data.frame/tibble-class object that contains the information needed to
construct each sheet. The package contains a dummy dataset with the
correct format; it’s a truncated version of the example provided in [the
guidance](https://gss.civilservice.gov.uk/policy-store/releasing-statistics-in-spreadsheets/).

``` r
tibble::tibble(lfs_tables)
#> # A tibble: 6 × 8
#>   tab_title sheet_type sheet_title source subtable_num subtable_title table_name
#>   <chr>     <chr>      <chr>       <chr>  <chr>        <chr>          <chr>     
#> 1 cover     meta       Labour mar… <NA>   <NA>         <NA>           Cover_con…
#> 2 contents  meta       Table of c… <NA>   <NA>         <NA>           Table_of_…
#> 3 notes     meta       Notes       <NA>   <NA>         <NA>           Notes_tab…
#> 4 1a        tables     Number and… Labou… <NA>         <NA>           Labour_ma…
#> 5 2         tables     Number and… Labou… a            Number and pe… Labour_ma…
#> 6 2         tables     Number and… Labou… b            Number and pe… Labour_ma…
#> # … with 1 more variable: table <list>
```

Each row is a table to insert into the output. `tab_title` is needed to
name the tabs in the workbook; `sheet_title` is inserted as the first
sheet *element*; if there’s more than one table in a sheet (try to avoid
this), you need a `subtable_num` and `subtable_title`; a `table_name`
which is a ‘hidden’ title applied to the marked-up cells of table; and
`table`, which is a listcol containing the data as a rectangular
data.frame/tibble-class object. For example:

``` r
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

lfs_tables %>% 
  filter(tab_title == "1a") %>%
  pull("table")
#> [[1]]
#> # A tibble: 6 × 10
#>   `Time period and d… `Number of people… `Economically acti… `Employment\nlevel…
#>   <chr>                            <dbl>               <dbl>               <dbl>
#> 1 Mar to May 2020              53534074.           34127374.           32743577.
#> 2 Apr to Jun 2020              53556401.           34051489.           32670800.
#> 3 May to Jul 2020              53579793.           34116254.           32665420.
#> 4 Jun to Aug 2020              53603157.           34112847.           32590593.
#> 5 Jul to Sep 2020              53626130            34130192.           32506683.
#> 6 Aug to Oct 2020              53649283            34213332.           32521742.
#> # … with 6 more variables: Unemployment
#> level
#> (thousands) [note 2] <dbl>,
#> #   Economically inactive (thousands) [note 3] <dbl>,
#> #   Economically active rate
#> (%)
#>  <dbl>, Employment
#> rate
#> (%)
#> [note 4] <dbl>,
#> #   Unemployment rate
#> (%)
#> [note 4] <dbl>,
#> #   Economically inactive rate
#> (%)
#> [note 4] <dbl>
```

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
