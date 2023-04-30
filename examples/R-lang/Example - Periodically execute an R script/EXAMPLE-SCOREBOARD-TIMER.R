# Installing the packages
# install.packages("httr")
# install.packages("jsonlite")
# install.packages("dplyr")    # The %>% is no longer natively supported by the R language
# install.packages("tibble")
# install.packages("tidyr")

# Loading packages
library(httr)
library(jsonlite)
library(dplyr)
library(tibble)
library(tidyr)

THREE_MINUTES_IN_SECONDS <- 60 * 3
DELAY_IN_SECONDS <- THREE_MINUTES_IN_SECONDS
EXECUTION_ATTEMPTS <- 1
EMPTY_SPACES <- "    "

# Load scoreboards
NHL_SCOREBOARD_SCRIPT <- sprintf("%s/examples/R-lang/National Hockey League - NHL/NHL API - Example to view data for a specific NHL game ID/NHL-API-view-data-for-a-specific-game-id.R", getwd())
WHL_SCOREBOARD_SCRIPT <- sprintf("%s/examples/R-lang/Western Hockey League - WHL/WHL API - Initial data exploration/WHL-API-view-data-for-a-specific-game-id.R", getwd())

while (TRUE) {
  print(paste("Refreshing NHL and WHL scoreboard data at", Sys.time(), "- Attempt #", EXECUTION_ATTEMPTS))

  # Remove data frames before refreshing scoreboard data
  if (exists("whl_scorebar_dataframe_filtered")) {
    try(rm(whl_scorebar_dataframe_filtered), silent = TRUE)
  }

  # Remove data frames before refreshing scoreboard data
  if (exists("nhl_scoreboard_dataframe")) {
    try(rm(nhl_scoreboard_dataframe), silent = TRUE)
  }

  if (exists("nhl_schedule_details_games_dataframe_filtered")) {
    try(rm(nhl_schedule_details_games_dataframe_filtered), silent = TRUE)
  }
  
  # Read in the source files
  source(NHL_SCOREBOARD_SCRIPT)
  source(WHL_SCOREBOARD_SCRIPT)

  # View the data frame - focused on NHL updates
  if (exists("whl_scorebar_dataframe_filtered")) {
    # Check if the data frame contains at least one row of data (fixes a bug where a day range is specified where games do NOT exist - 2023.04.07 is an example)
    if (nrow(whl_scorebar_dataframe_filtered) > 0) {
      print(paste(EMPTY_SPACES, "-> WHL scoreboard available at", Sys.time()))
      View(whl_scorebar_dataframe_filtered)
    } else {
      # print("The whl_scorebar_dataframe_filtered data frame exists, but it does not contain any data.")
    }
  }

  if (exists("nhl_scoreboard_dataframe")) {
    # Check if the data frame contains at least one row of data (fixes a bug where a day range is specified where games do NOT exist - 2023.04.07 is an example)
    if (nrow(nhl_scoreboard_dataframe) > 0) {
      print(paste(EMPTY_SPACES, "-> NHL scoreboard available at", Sys.time()))
      View(nhl_scoreboard_dataframe)
    } else {
      # print("The nhl_scoreboard_dataframe data frame exists, but it does not contain any data.")
    }
  }

  # Wait for at least X seconds
  Sys.sleep(DELAY_IN_SECONDS)

  # Increment our counter
  EXECUTION_ATTEMPTS <- EXECUTION_ATTEMPTS + 1
}
