
# {a11ytables2}

<!-- badges: start -->
[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
<!-- badges: end -->

This package is an experimental work-in-progress update of [{a11ytables}](https://co-analysis.github.io/a11ytables/).

Like {a11ytables}, {a11ytables2} is:

> An R package to help automatically create reproducible spreadsheets that adhere to the latest guidance on [releasing statistics in spreadsheets](https://analysisfunction.civilservice.gov.uk/policy-store/releasing-statistics-in-spreadsheets/) from the UK government's [Analysis Function Central Team](https://analysisfunction.civilservice.gov.uk/), with a focus on accessibility ('a11y'). 

The plan is for {a11ytables2} to:

* be built on {openxlsx2} instead of {openxlsx}
* take advantage of a 'YAML blueprint' system for specifying a11ytables-class objects
* take advantage of tools like {cli} and {fs} for better messaging and file handling
