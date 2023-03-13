DELAY_IN_SECONDS <- 15
THREE_MINUTES_IN_SECONDS <- 60 * 3

# Load scoreboards
NHL_SCOREBOARD_SCRIPT <- sprintf("%s/examples/R-lang/National Hockey League - NHL/NHL API - Example to view data for a specific NHL game ID/NHL-API-view-data-for-a-specific-game-id.R", getwd())
WHL_SCOREBOARD_SCRIPT <- sprintf("%s/examples/R-lang/Western Hockey League - WHL/WHL API - Initial data exploration/WHL-API-view-data-for-a-specific-game-id.R", getwd())

while (TRUE) {
  print(paste("Refreshing NHL and WHL scoreboard data at", Sys.time()))

  # Read in the source files
  source(NHL_SCOREBOARD_SCRIPT)
  source(WHL_SCOREBOARD_SCRIPT)

  # View the data frame - focused on NHL updates
  View(whl_scorebar_dataframe_filtered)
  View(schedule_details_games_dataframe_filtered)
  View(nhl_scoreboard_dataframe)
  
  # Wait for at least X seconds
  Sys.sleep(THREE_MINUTES_IN_SECONDS)
}
