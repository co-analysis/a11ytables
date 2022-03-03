
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

An R package to help you create spreadsheets that adhere to the latest
guidance (June 2021) on [releasing statistics in
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

## Install

Install the package from GitHub using
[{remotes}](https://remotes.r-lib.org/).
[{openxlsx}](https://ycphs.github.io/openxlsx/) and
[{pillar}](https://pillar.r-lib.org/) will also be installed.

``` r
install.packages("remotes")  # if not already installed
remotes::install_github("co-analysis/a11ytables")
```

To create a spreadsheet:

1.  Use `new_a11ytable()` to create a special dataframe of your data
2.  Use `create_a11y_wb()` to add styles and workbook structure
3.  Use `openxlsx::saveWorkbook()` to write an xlsx file

Visit [the quickstart
vignette](https://co-analysis.github.io/a11ytables/articles/quickstart.html)
to get going.

See the [‘Construct an
a11ytable’](https://co-analysis.github.io/a11ytables/articles/construct.html)
vignette for greater depth, or the [‘Accessbility guidance
checklist’](https://co-analysis.github.io/a11ytables/articles/quickstart.html)
vignette to see how the package complies with guidance.

## Related projects

BPID released [a Python package called
‘gptables’](https://github.com/best-practice-and-impact/gptables) but
[it needs to be
updated](https://github.com/best-practice-and-impact/gptables/issues/145).
There’s no companion R package at time of writing, but {a11ytables}
fills this gap.

The package can help you fulfil a [Reproducible Analytical
Pipeline](https://dataingovernment.blog.gov.uk/2017/03/27/reproducible-analytical-pipeline/)
by automating the generation of compliant spreadsheets for publication.

## Code of Conduct

Please note that the {a11ytables} project is released with a
[Contributor Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
Cabinet Office users, please adhere to [the co-analysis Git and GitHub
code of conduct and usage
policy](https://docs.google.com/document/d/1CuNgKla1BwSVOmGkPmsq0S-OM4emP-iXrgnm7EeILWM/edit?usp=sharing).

## Copyright

Copyright (c) 2022 Crown Copyright (Cabinet Office). The code in this
repository is released under the MIT license as per [The GDS
Way](https://gds-way.cloudapps.digital/manuals/licensing.html#use-mit).
