
# why is the expect_equal chunk inside the my_mock for the endpoint test but outside my_mock for the parsing test?
# Because the two expect_equal() calls are testing different things at different points in the process.
# the general rule is: If you're testing something about the request, test it inside the mock. If you're testing something about the function's output, test it after the mocked call.


# this test asks: Given a valid API response, does cf_get() return the data correctly?

test_that("cf_get handles an API response", {


  # The mock creates 2 lines of what CalFlora's project metadata table.
  # Checks that cf_get parses that information and returns the expected dataframe.
  my_mock <- function(req) {
    httr2::response(
      status_code = 200,
      headers = list(`Content-Type` = "application/json"),
      body = charToRaw(
        '[{"id":"pr1273","gid":228,"name":"MGP - Native Plants","description":null,"plantlistID":"px7"},
          {"id":"pr1313","gid":228,"name":"Fire Forward Learning ISED","description":"For experimenting/learning","plantlistID":"px6"}]'
      )
    )
  }

  result <- httr2::with_mocked_responses(
    my_mock,
    cf_get("projects", api_key = "fake-key")
  )

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 2)
  expect_equal(
    result$id,
    c("pr1273", "pr1313")
  )
  expect_equal(
    result$name,
    c("MGP - Native Plants", "Fire Forward Learning ISED")
  )
})


# this tests: When I give cf_get() "projects", does it construct the request for https://api.calflora.org/projects?
test_that("cf_get uses what_to_get to construct the endpoint", {


  # The mock receives the HTTP request before it is sent.
  # Check that what_to_get was used to construct the URL.
  my_mock <- function(req) {

    expect_equal(
      req$url,
      "https://api.calflora.org/projects"
    )

    # Return a minimal valid API response so the function can finish.
    httr2::response(
      status_code = 200,
      headers = list(`Content-Type` = "application/json"),
      body = charToRaw(
        '[{"id":"pr1273","name":"MGP - Native Plants"}]'
      )
    )
  }

  httr2::with_mocked_responses(
    my_mock,
    cf_get("projects", api_key = "fake-key")
  )
})
