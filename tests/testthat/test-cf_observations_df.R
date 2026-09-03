# This test asks: Does cf_observations_df() create an appropriate URL from
# the user's query parameters in order to make a valid API request?

test_that("cf_observations_df passes query parameters to the API", {

  my_mock <- function(req) {

    # Check that the expected URL was constructed.
    expect_equal(
      req$url,
      "https://api.calflora.org/observations?county=SON&csetId=b"
    )

    # Return a minimal valid API response so the function can finish.
    httr2::response(
      status_code = 200,
      headers = list(`Content-Type` = "application/json"),
      body = charToRaw('[{"ID":"test"}]')
    )
  }

  httr2::with_mocked_responses(
    my_mock,
    cf_observations_df(
      params = list(
        county = "SON",
        csetId = "b"
      ),
      api_key = "fake-key"
    )
  )
})



# This test asks: Does cf_observations_df() pass the API key
# to the API in the X-Api-Key request header?

test_that("cf_observations_df passes the API key in the request header", {

  my_mock <- function(req) {

    # Check that the API key was added to the request header.
    expect_equal(
      req$headers[["X-Api-Key"]],
      "fake-key"
    )

    # Return a minimal valid API response so the function can finish.
    httr2::response(
      status_code = 200,
      headers = list(`Content-Type` = "application/json"),
      body = charToRaw('[{"ID":"test"}]')
    )
  }

  httr2::with_mocked_responses(
    my_mock,
    cf_observations_df(
      params = list(
        county = "SON"
      ),
      api_key = "fake-key"
    )
  )
})



# this test asks: Given a valid API response, does cf_observations_df() return the data correctly?

test_that("cf_observations_df handles an API response", {


  # The mock creates 2 lines of what CalFlora's observations table with the basic column set.
  # Checks that cf_observations_df parses that information and returns the expected dataframe.
  my_mock <- function(req) {
    httr2::response(
      status_code = 200,
      headers = list(`Content-Type` = "application/json"),
      body = charToRaw(
        '[{"Access":"z", "Common Name":"Yellow starthistle", "Date":"2026-09-01", "Group":211, "ID":"mg327473", "Latitude":38.40522, "Location":"", "Description":null, "Longitude":-122.6892, "Observer": "Scott Jennings", "Taxon":"Centaurea solstitialis"},
          {"Access":"z", "Common Name":"Yellow starthistle", "Date":"2026-08-01", "Group":211, "ID":"mg327472", "Latitude":38.40622, "Location":"", "Description":null, "Longitude":-122.6492, "Observer": "Scott Jennings", "Taxon":"Centaurea solstitialis"}]'
      )
    )
  }

  result <- httr2::with_mocked_responses(
    my_mock,
    cf_observations_df(params = list(
      county = "SON",
      csetId = "b"
    ), api_key = "fake-key")
  )

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 2)
  expect_equal(
    result$ID,
    c("mg327473", "mg327472")
  )
  expect_equal(
    result$Observer,
    c("Scott Jennings", "Scott Jennings")
  )
  expect_equal(
    result$Description,
    c(NA, NA)
  )
})
