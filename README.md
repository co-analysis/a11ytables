
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
[{openxlsx}](https://ycphs.github.io/openxlsx/) that aims to comply with
the latest guidance (June 2021) on [releasing statistics in
spreadsheets](https://gss.civilservice.gov.uk/policy-store/releasing-statistics-in-spreadsheets/)
from the [Best Practice and Impact
Division](https://github.com/best-practice-and-impact?language=html)
(BPID) of the UK’s [Government Statistical
Service](https://gss.civilservice.gov.uk/).

Features are in-development and opinionated. Certain things may not work
as you intend and you may need to tweak your final workbook object after
creation. The onus is on the user to check their work. See [the package
website](https://co-analysis.github.io/a11ytables/) for online
documentation.

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

## Install and use

You can install {a11ytables} from GitHub. using {remotes}.

``` r
install.packages("remotes")
remotes::install_github("co-analysis/a11ytables")
library(a11ytables)
```

The package depends on {openxlsx} for constructing workbooks and {purrr}
for readable function iteration. Both are imported with {a11ytables}.
The {magrittr} pipe (`%>%`) is exported for convenience.

At time of writing, you would do something like this to generate a
publication:

``` r
example_wb <- openxlsx::createWorkbook() %>% 
  add_tabs(lfs_tables) %>% 
  add_cover(lfs_tables) %>% 
  add_contents(lfs_tables) %>% 
  add_notes(lfs_tables) %>% 
  add_tables(lfs_tables, table_name = "Labour_market_summary_for_16_and_over") %>%
  add_tables(lfs_tables, table_name = "Labour_market_activity_groups_16_and_over")

openxlsx::openXL(example_wb)  # optionally open temp copy
openxlsx::saveWorkbook(example_wb, "publication.xlsx")
```

In other words, you create an {openxlsx} Workbook-class object, then add
each sheet one by one with {allytables} functions. An important user
input is the information required to populate each sheet, which must be
provided in a particular format. The package’s built-in `lfs_tables`
data set provides an example (see the next section for a preview).

## Concept

A *workbook* is made of *sheets*. There are two types of sheet: *meta*
(*cover*, *contents* and optional *notes*) and *tables*.

Sheets are built from *elements*, which includes the title, an
announcement on the number of tables/presence of notes, an announcement
of the source, and the tables themselves

You can build each *sheet* type using the `add_*()` functions. Each one
creates a sheet that is inserted into a named {openxlsx} Workbook-class
object using data from a user-supplied *contents* object.

The *contents* object has a very strict format. It’s a
data.frame/tibble-class object that contains the information needed to
construct each sheet. The columns and certain contents must follow
particular requirements.

The package contains a dummy dataset with the correct format; it’s a
truncated version of the example provided in [the
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
lfs_tables %>% 
  dplyr::filter(tab_title == "1a") %>%
  dplyr::pull("table") %>% 
  `[[`(., 1) %>%  # extract from list form
  dplyr::select(1:3)  # first few cols
#> # A tibble: 6 × 3
#>   `Time period and dataset code row` `Number of people (… `Economically active\…
#>   <chr>                                             <dbl>                  <dbl>
#> 1 Mar to May 2020                               53534074.              34127374.
#> 2 Apr to Jun 2020                               53556401.              34051489.
#> 3 May to Jul 2020                               53579793.              34116254.
#> 4 Jun to Aug 2020                               53603157.              34112847.
#> 5 Jul to Sep 2020                               53626130               34130192.
#> 6 Aug to Oct 2020                               53649283               34213332.
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
