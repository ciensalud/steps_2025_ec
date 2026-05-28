# HTA Ecuador Audit

Initial reproducible audit for STEPS Ecuador 2025 hypertension inputs.

This module is intentionally limited to privacy controls, input validation,
preliminary hypertension derivation, and a Quarto audit report. Predictive
models are out of scope for this phase.

## Privacy

Raw microdata must remain local. Do not commit `ECU_data.xlsx`, other
`ECU_*.xlsx` files, `ECU-*.xlsx` files, or sensitive/private output folders.
The repository `.gitignore` protects these paths explicitly.

## Requirements

- R
- Quarto
- R packages: `readxl`, `knitr`

The scripts do not install packages automatically. Install missing packages in
your local R environment before rendering.

## Data Path

Set the local path to the raw workbook with the `STEPS_ECU_DATA` environment
variable. If it is not set, the audit looks for `ECU_data.xlsx` at the
repository root.

PowerShell example:

```powershell
$env:STEPS_ECU_DATA = "C:\Users\mario.felix\Documents\GitHub\steps_2025_ec\ECU_data.xlsx"
quarto render analysis/hta_ecu/reports/hta_audit.qmd
```

## Outputs

The report is rendered by Quarto. This phase does not save `.rds` artifacts,
trained models, or derived microdata.

## Scope

Included:

- Input file existence and schema checks.
- Row/column count validation.
- Key variable validation for survey design, blood pressure readings, and
  hypertension history/treatment variables.
- Preliminary completeness tables for blood pressure readings.
- Preliminary mean SBP/DBP and `hta_140_90_or_meds` derivation.

Excluded:

- Predictive modeling.
- Model artifacts.
- Changes to the original WHO/STEPS pipeline under `STEPS_data_analysis/`.
