Dry Run Data Analyses
================
Elizabeth Dworak
20 April, 2023

- <a href="#overview" id="toc-overview">Overview</a>
- <a href="#folder-organization" id="toc-folder-organization">Folder
  organization</a>
  - <a href="#data-cleaning" id="toc-data-cleaning">Data Cleaning</a>
  - <a href="#data-analysis" id="toc-data-analysis">Data Analysis</a>

# Overview

Welcome to the NBT Dry Run Data Analyses folder (`dry_run`). This folder
includes code for cleaning and analyzing data from the NBT Dry Run
(collected in March 2023).

# Folder organization

As of April 2023, this folder contains a number of files used to clean
and analyze data collected from the NBT Dry Run. Below is a brief
description of the organization of the files and folders:

## Data Cleaning

- `combine_ItemExportNarrow.R` - This file contains the primary code to
  combine and create a single long format file of the ItemExportNarrow
  export files.

- `combine_Registration_Age.R` - This file contains the primary code to
  combine and create a single long format file of the age information
  from the Registration export files.

- `combine_ScoreExportNarrow.R` - This file contains the primary code to
  combine and create a single long format file of the ScoreExportNarrow
  export files.

- `data_cleaning_DP4.R` - This file contains the primary code to clean
  the DP4 data.

- `Items_dryrun_for_sharing.R` - This file contains the code for
  combining, pivoting, and splitting the item level Dry Run responses,
  response time, and scores data for the 6 domains. These data are
  intended to be shared with the NBT Domain managers and teams to help
  with discussions about scoring.

## Data Analysis

- `dryrun_analyses.R` - This file contains the initial draft code for
  cleaning and analyzing the Dry Run data. More recent and updated code
  are contained in: `EFCog_dryrun_20230329.Rmd`,
  `Items_dryrun_results.Rmd`, and `Scores_dryrun_results.Rmd`.

- `EFCog_dryrun_20230329.Rmd` - This file contains the code for cleaning
  and analyzing the EF Cog data collected during Dry Run. These analyses
  were used to determine if we would use two different batteries in
  norming for ages 16-21 or not based on the assessments that used touch
  vs. gaze.

- `EFCog_dryrun_20230331.html` - This file is a knit HTML file
  containing the output created by `EFCog_dryrun_20230329.Rmd`.

- `Items_dryrun_results.Rmd` - This file contains the code for cleaning
  and analyzing the item level score data collected during Dry Run.

- `Items_dryrun_results.html` - This file is a knit HTML file containing
  the output created by `Items_dryrun_results.Rmd`.

- `Scores_dryrun_results.Rmd` - This file contains the code for cleaning
  and analyzing the assessment level score data collected during Dry
  Run.

- `Scores_dryrun_results.html` - This file is a knit HTML file
  containing the output created by `Scores_dryrun_results.Rmd`.
