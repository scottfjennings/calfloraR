
# calfloraR

<!-- badges: start -->
<!-- badges: end -->

The goal of calfloraR is to provide access to CalFlora data via an API. It provides functions for retrieving CalFlora metadata and observation records. No data visualization, summary, mapping, or other capacity is built in to this package.

## Installation

You can install the development version of calfloraR from [GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("scottfjennings/calfloraR")
```

## API key

calfloraR requires a CalFlora API key. Store your key in your .Renviron file as CALFLORA_API_KEY so it is available to the package without putting the key directly in your R code.

You can edit your .Renviron file with:

`usethis::edit_r_environ()`

Add:

`CALFLORA_API_KEY=your_api_key_here`

Restart R, then verify that the key is available with `Sys.getenv("CALFLORA_API_KEY")`.

See the Getting Started vignette for more details.

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(calfloraR)
# view a list of available projects
projects <- cf_get("projects")

# download some observations
observations <- cf_observations_df(
  params = list(
    county = "SON",
    csetId = "b"
  )
)
```


## Available functions

all function names start with cf_ to aid workflows with RStudio autofill.

cf_get() — provides generic access to any endpoint in the CalFlora API; will most often be used to view what the API expects in queries fed to the more specific access functions

cf_observations_df() — convenience function to access the observations endpoint in the CalFlora API. Allows the user to feed API query parameters in a more human-friendly format.

## Documentation

See the getting-started vignette for more information and an example workflow.
See also:
`?cf_get()`
`?cf_observations_df()`



