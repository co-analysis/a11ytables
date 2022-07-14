
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

The package is under (opinionated) active development. Please see [the
NEWS file](https://co-analysis.github.io/a11ytables/news/index.html) for
the latest changes. Please [leave your ideas as
issues](https://github.com/co-analysis/a11ytables/issues) or raise a
pull request.

## Install

Install the package from GitHub using
[{remotes}](https://remotes.r-lib.org/).
[{openxlsx}](https://ycphs.github.io/openxlsx/) and
[{pillar}](https://pillar.r-lib.org/) will also be installed.

``` r
install.packages("remotes")  # if not already installed
remotes::install_github("co-analysis/a11ytables")
```

## Use

To create a spreadsheet:

1.  Use `create_a11ytable()` to build a special dataframe of your data
2.  Use `generate_workbook()` to add styles and workbook structure
3.  Use `openxlsx::saveWorkbook()` to write an xlsx file

You can read the:

-   [introductory
    vignette](https://co-analysis.github.io/a11ytables/articles/a11ytables.html)
    to get started
-   [accessbility guidance
    checklist](https://co-analysis.github.io/a11ytables/articles/checklist.html)
    vignette to see how the package complies with best-practice guidance
-   [terminology
    vignette](https://co-analysis.github.io/a11ytables/articles/terminology)
    to understand the nomenclature of spreadsheet terms as used in this
    package
-   [package structure
    vignette](https://co-analysis.github.io/a11ytables/articles/structure)
    to see how the package works under the hood

This package also includes [an RStudio
Addin](https://rstudio.github.io/rstudioaddins/) that inserts pre-filled
demo skeletons of the {a11ytables} workflow.

## Related projects

BPID released [a Python package called
‘gptables’](https://github.com/best-practice-and-impact/gptables) that
has [been updated given the latest best-practice
guidance](https://dataingovernment.blog.gov.uk/2022/06/24/automatically-produce-best-practice-spreadsheets/).
{a11ytables} offers a native R solution that is very similar to gptables
in its outputs, though there are some differences in implementation. You
can always use gptables in R [via the {reticulate}
package](https://gptables.readthedocs.io/en/latest/usage.html#r-usage).

{a11ytables} can help you fulfill a [Reproducible Analytical
Pipeline](https://analysisfunction.civilservice.gov.uk/policy-store/reproducible-analytical-pipelines-strategy/)
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
