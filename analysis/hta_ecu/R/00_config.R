# Configuration shared by the STEPS Ecuador HTA audit.

hta_required_packages <- c("readxl", "knitr")

hta_check_packages <- function(packages = hta_required_packages) {
  missing <- packages[!vapply(packages, requireNamespace, logical(1), quietly = TRUE)]

  if (length(missing) > 0) {
    stop(
      "Missing required R package(s): ",
      paste(missing, collapse = ", "),
      ". Install them before rendering the HTA audit report.",
      call. = FALSE
    )
  }

  invisible(TRUE)
}

hta_find_repo_root <- function(start = getwd()) {
  current <- normalizePath(start, winslash = "/", mustWork = TRUE)

  repeat {
    if (dir.exists(file.path(current, ".git")) ||
        file.exists(file.path(current, "STEPS.Rproj"))) {
      return(current)
    }

    parent <- dirname(current)
    if (identical(parent, current)) {
      stop(
        "Could not locate the repository root. Run Quarto from the repo or set STEPS_ECU_DATA.",
        call. = FALSE
      )
    }
    current <- parent
  }
}

hta_repo_root <- hta_find_repo_root()
hta_analysis_dir <- file.path(hta_repo_root, "analysis", "hta_ecu")
hta_output_dir <- file.path(hta_analysis_dir, "outputs")
hta_figure_dir <- file.path(hta_output_dir, "figures")
hta_table_dir <- file.path(hta_output_dir, "tables")

hta_data_path <- Sys.getenv(
  "STEPS_ECU_DATA",
  unset = file.path(hta_repo_root, "ECU_data.xlsx")
)

hta_expected_rows <- 4791L
hta_expected_cols <- 277L

hta_key_variables <- c(
  "stratum", "psu", "wstep1", "wstep2", "wstep3",
  "m4a", "m4b", "m5a", "m5b", "m6a", "m6b",
  "h1", "h2a", "h3", "m7"
)

hta_bp_sbp_vars <- c("m4a", "m5a", "m6a")
hta_bp_dbp_vars <- c("m4b", "m5b", "m6b")
hta_bp_vars <- c(hta_bp_sbp_vars, hta_bp_dbp_vars)
hta_missing_codes <- c(77, 88, 777, 888, 999)

hta_config <- list(
  repo_root = hta_repo_root,
  analysis_dir = hta_analysis_dir,
  output_dir = hta_output_dir,
  figure_dir = hta_figure_dir,
  table_dir = hta_table_dir,
  data_path = hta_data_path,
  expected_rows = hta_expected_rows,
  expected_cols = hta_expected_cols,
  key_variables = hta_key_variables,
  missing_codes = hta_missing_codes
)
