# Audit table helpers for the STEPS Ecuador HTA report.

hta_bp_completeness_table <- function(data) {
  data.frame(
    variable = hta_bp_vars,
    non_missing = vapply(data[hta_bp_vars], function(x) sum(!is.na(x)), integer(1)),
    missing = vapply(data[hta_bp_vars], function(x) sum(is.na(x)), integer(1)),
    completeness_pct = round(
      100 * vapply(data[hta_bp_vars], function(x) mean(!is.na(x)), numeric(1)),
      1
    ),
    stringsAsFactors = FALSE
  )
}

hta_bp_reading_count_table <- function(data) {
  sbp_tab <- as.data.frame(table(data$sbp_valid_readings, useNA = "ifany"))
  dbp_tab <- as.data.frame(table(data$dbp_valid_readings, useNA = "ifany"))

  names(sbp_tab) <- c("valid_readings", "sbp_records")
  names(dbp_tab) <- c("valid_readings", "dbp_records")

  merge(sbp_tab, dbp_tab, by = "valid_readings", all = TRUE)
}

hta_preliminary_summary_table <- function(data) {
  hta_flag <- data$hta_140_90_or_meds

  data.frame(
    metric = c(
      "records",
      "records_with_any_valid_bp",
      "records_with_preliminary_sbp_dbp",
      "preliminary_hta_positive",
      "preliminary_hta_negative",
      "preliminary_hta_missing",
      "preliminary_hta_positive_pct_among_classified"
    ),
    value = c(
      nrow(data),
      sum(data$bp_any_valid, na.rm = TRUE),
      sum(!is.na(data$sbp_mean_prelim) & !is.na(data$dbp_mean_prelim)),
      sum(hta_flag == 1, na.rm = TRUE),
      sum(hta_flag == 0, na.rm = TRUE),
      sum(is.na(hta_flag)),
      round(100 * mean(hta_flag == 1, na.rm = TRUE), 1)
    ),
    stringsAsFactors = FALSE
  )
}

hta_variable_presence_table <- function(data) {
  hta_validate_key_variables(data)
}
