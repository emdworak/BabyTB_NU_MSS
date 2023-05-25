Scoring Certification Reports
================
Elizabeth Dworak
20 April, 2023

- <a href="#overview" id="toc-overview">Overview</a>
- <a href="#folder-organization" id="toc-folder-organization">Folder
  organization</a>

# Overview

Welcome to the NBT Scoring Certification Reports folder
(`scoring_input`). This folder includes code used for cleaning,
(re)scoring, ana analyzing the data collected from the training
certification Shiny application.

# Folder organization

As of April 2023, this folder contains a limited number of files used to
clean, (re)score, and analyze data from the Shiny application. Likewise,
code in this folder creates individualized reports for those undergoing
scoring certification. Below is a brief description of the organization
of the files and folders:

- `certification_results.Rmd` - This file contains the primary code to
  run, (re)score, and analyze data from the NBT training certification
  Shiny application and is intended to give those overseeing training an
  overview of how trainees are performing. When cleaning the data, this
  code will tell you 1) who was inconsistent when entering their name
  and make corrections to these errors; 2) who took an assessment
  multiple times and drop duplicates; and 3) who has completed all the
  required assessments verses who has missing scoring certification
  data. As there were errors during the initial deployment of the
  training certification Shiny application, this code will also correct
  input errors and rescore the data to get an accurate representation of
  how trainees are performing. After cleaning and scoring the data, it
  then generates subsections to tell those certifying trainees how their
  overall (i.e., assessment) and item level performance was.

- `individual_results.Rmd` - This file contains a the code used to
  generate individual PDF reports that can be returned to the trainees
  undergoing scoring certification. These reports include how the
  trainee’s overall (i.e., assessment) and item level performance was.
  This includes listing out the measure, question, video, response,
  answer key, and score.

- `data` - This folder contains the unprocessed and processed data
  produced by the Shiny application. Data from this folder are required
  in order to run the `certification_results.Rmd` and
  `individual_results.Rmd`. The file has been uploaded to show the
  structure to those interested in creating their own Shiny application.
  For those on the NBT team interested in obtaining the data, please
  contact someone on the NBT data team.

- `individual_reports` - This folder contains the individual reports
  produced by `individual_results.Rmd` organized by collection site. The
  file has been uploaded to show the structure to those interested in
  creating their own Shiny application.
