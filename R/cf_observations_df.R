

#' Download CalFlora observations
#'
#' Download observation records from the CalFlora API.
#'
#' @param params A named list of query parameters to pass to the CalFlora
#'   observations API. See the examples for commonly used parameters.
#' @param api_key Your CalFlora API key. By default, the function looks for
#'   an API key stored in the `CALFLORA_API_KEY` environment variable.
#'
#' @returns A data frame containing observation records returned by the
#'   CalFlora API.
#'
#' @details
#' The CalFlora observations API limits individual requests to 2,000
#' records. To download more than 2,000 records, use additional query
#' parameters to divide the request into smaller chunks and combine the
#' resulting data frames.
#'
#' @examples
#' \dontrun{
#' my_params <- list(
#'   shapeId = "rs1515",
#'   dateAfter = "1960-01-01",
#'   dateBefore = "2025-12-31",
#'   csetId = "ACR-WT",
#'   projectIds = "pr940"
#' )
#'
#' observations <- cf_observations_df(params = my_params)
#' }
#'
#' @export
cf_observations_df <- function(
    params,
    api_key = Sys.getenv("CALFLORA_API_KEY")
) {
  resp <- httr2::request("https://api.calflora.org/observations") |>
    httr2::req_headers(
      `X-Api-Key` = api_key
    ) |>
    httr2::req_url_query(!!!params) |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)
}











