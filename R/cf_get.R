


#' Download CalFlora metadata
#'
#' Download basic metadata for different types of CalFlora data.
#'
#' @param what_to_get A character string specifying which CalFlora API
#'   endpoint to query. See the CalFlora API documentation for available
#'   endpoints. For example, use `"columnsets"` to retrieve column-set
#'   metadata used by the observations endpoint.
#' @param api_key Your CalFlora API key. By default, the function looks for
#'   an API key stored in the `CALFLORA_API_KEY` environment variable.
#'
#' @returns A data frame containing metadata returned by the CalFlora API.
#'
#' @details
#' This function is useful for retrieving information about available
#' values for query parameters used when downloading CalFlora data.
#'
#' @examples
#' \dontrun{
#' calflora_columnsets <- cf_get("columnsets")
#'
#' calflora_projects <- cf_get("projects")
#' }
#'
#' @export
cf_get <- function(
    what_to_get,
    api_key = Sys.getenv("CALFLORA_API_KEY")
) {
  dat <- httr2::request(
    paste0("https://api.calflora.org/", what_to_get)
  ) |>
    httr2::req_headers(`X-Api-Key` = api_key) |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)

  dat
}










