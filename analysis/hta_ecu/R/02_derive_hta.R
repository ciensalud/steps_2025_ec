# Preliminary hypertension derivation helpers.

hta_numeric_clean <- function(x, missing_codes = hta_config$missing_codes) {
  out <- suppressWarnings(as.numeric(x))
  out[out %in% missing_codes] <- NA_real_
  out
}

hta_clean_bp_readings <- function(data) {
  out <- data

  for (var in hta_bp_vars) {
    out[[var]] <- hta_numeric_clean(out[[var]])
  }

  if ("m7" %in% names(out)) {
    out[["m7"]] <- hta_numeric_clean(out[["m7"]])
  }

  out
}

hta_row_mean <- function(data, vars) {
  values <- data[vars]
  counts <- rowSums(!is.na(values))
  means <- rowMeans(values, na.rm = TRUE)
  means[counts == 0] <- NA_real_
  means
}

hta_derive_preliminary <- function(data) {
  out <- hta_clean_bp_readings(data)

  out$sbp_valid_readings <- rowSums(!is.na(out[hta_bp_sbp_vars]))
  out$dbp_valid_readings <- rowSums(!is.na(out[hta_bp_dbp_vars]))
  out$bp_any_valid <- (out$sbp_valid_readings + out$dbp_valid_readings) > 0

  out$sbp_mean_prelim <- hta_row_mean(out, hta_bp_sbp_vars)
  out$dbp_mean_prelim <- hta_row_mean(out, hta_bp_dbp_vars)

  measured_hta <- (!is.na(out$sbp_mean_prelim) & out$sbp_mean_prelim >= 140) |
    (!is.na(out$dbp_mean_prelim) & out$dbp_mean_prelim >= 90)

  on_meds <- !is.na(out$m7) & out$m7 == 1

  out$hta_140_90_or_meds <- ifelse(
    measured_hta | on_meds,
    1L,
    ifelse(out$bp_any_valid | !is.na(out$m7), 0L, NA_integer_)
  )

  out
}
