# Input validation helpers for the STEPS Ecuador HTA audit.

hta_read_ecu_data <- function(path = hta_config$data_path) {
  if (!file.exists(path)) {
    stop(
      "ECU_data.xlsx was not found. Set STEPS_ECU_DATA to the local workbook path ",
      "or place ECU_data.xlsx at the repository root. Checked path: ",
      normalizePath(path, winslash = "/", mustWork = FALSE),
      call. = FALSE
    )
  }

  hta_check_packages("readxl")

  data <- readxl::read_excel(path)
  names(data) <- tolower(names(data))
  as.data.frame(data, stringsAsFactors = FALSE)
}

hta_validate_dimensions <- function(data,
                                    expected_rows = hta_config$expected_rows,
                                    expected_cols = hta_config$expected_cols) {
  observed <- dim(data)
  checks <- data.frame(
    check = c("rows", "columns"),
    expected = c(expected_rows, expected_cols),
    observed = c(observed[1], observed[2]),
    passed = c(observed[1] == expected_rows, observed[2] == expected_cols)
  )

  checks
}

hta_validate_key_variables <- function(data,
                                       key_variables = hta_config$key_variables) {
  data.frame(
    variable = key_variables,
    present = key_variables %in% names(data),
    stringsAsFactors = FALSE
  )
}

hta_assert_valid_inputs <- function(data) {
  dimension_checks <- hta_validate_dimensions(data)
  variable_checks <- hta_validate_key_variables(data)

  if (!all(dimension_checks$passed)) {
    failed <- dimension_checks[!dimension_checks$passed, , drop = FALSE]
    stop(
      "Unexpected ECU_data.xlsx dimensions. Failed check(s): ",
      paste(
        paste0(failed$check, " expected ", failed$expected, " observed ", failed$observed),
        collapse = "; "
      ),
      call. = FALSE
    )
  }

  if (!all(variable_checks$present)) {
    missing <- variable_checks$variable[!variable_checks$present]
    stop(
      "ECU_data.xlsx is missing required variable(s): ",
      paste(missing, collapse = ", "),
      call. = FALSE
    )
  }

  invisible(list(dimensions = dimension_checks, variables = variable_checks))
}
