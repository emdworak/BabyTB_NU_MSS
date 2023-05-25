Sit and Stand Scoring Certification Shiny App
================
Elizabeth Dworak
24 May, 2023

- <a href="#overview" id="toc-overview">Overview</a>
- <a href="#folder-organization" id="toc-folder-organization">Folder
  organization</a>

# Overview

Welcome to the NBT Sit and Stand (SaS) Scoring Certification folder
(`sas_scoring_certification`). This folder includes code used for the
additional training certification of SaS via a Shiny application. This
application is intended to examine how examiners perform on a new set of
SaS measures from the NBT.

# Folder organization

As of May 2023, this folder contains a limited number of files used to
create, score, and collect data from the Shiny application. Below is a
brief description of the organization of the files and folders:

- `app.R` - This file contains the primary code to run, score, and
  collect data from the Shiny application designed for scoring
  re-certification of SaS measures for those undergoing training on the
  NBT.

- `deploy.R` - This file contains a the code used for deploying and
  terminating the Shiny application.

- `authentication_files` - This folder contains hidden files for
  authenticating the Shiny application for data collection. The file
  will appear blank on GitHub to keep the authentication information
  confidential. However, the file has been uploaded to show the
  structure to those interested in creating their own Shiny application.

- `sas_scoring_input` - This folder contains code to clean, (re)score,
  and analyze SaS scoring certification data. The code in this file will
  not only produce an overall table to tell the individual overseeing
  certification how trainees are doing, but will also create individual
  reports that can be returned to the trainee.
