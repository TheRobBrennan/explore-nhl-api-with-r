# Installing the packages
# install.packages("httr")
# install.packages("jsonlite")
# install.packages("dplyr")    # The %>% is no longer natively supported by
# install.packages("tibble")

# Loading packages
library(httr)
library(jsonlite)
library(dplyr)
library(tibble)

# Build the URL to load our live game data from HockeyTech
HOCKEYTECH_API_PUBLIC_KEY <- "41b145a848f4bd67"
HOCKEYTECH_BASE_API_URL_GAME_CENTER <- "https://cluster.leaguestat.com/feed/index.php?feed=gc"
HOCKEYTECH_BASE_API_URL_MODULE_KIT <- "https://lscluster.hockeytech.com/feed/index.php?feed=modulekit"
HOCKEYTECH_CLIENT_CODE <- "whl"
HOCKEYTECH_LANGUAGE_CODE <- "en"
HOCKEYTECH_SITE_ID <- 2

HOCKEYTECH_VIEW_GAME_CENTER_TAB_CLOCK <- "clock"
HOCKEYTECH_VIEW_GAME_CENTER_TAB_GAME_SUMMARY <- "gamesummary"
HOCKEYTECH_VIEW_GAME_CENTER_TAB_PLAY_BY_PLAY <- "pxpverbose"
HOCKEYTECH_VIEW_GAME_CENTER_TAB_PREVIEW <- "preview"

HOCKEYTECH_VIEW_MODULE_KIT_SCOREBAR <- "scorebar"
HOCKEYTECH_VIEW_MODULE_KIT_SCOREBAR_NUMBER_OF_DAYS_AHEAD <- 3
HOCKEYTECH_VIEW_MODULE_KIT_SCOREBAR_NUMBER_OF_DAYS_BACK <- 0

# 2023.02.20 => SEA @ VIC - https://whl.ca/gamecentre/1019195/preview
HOCKEYTECH_GAME_ID <- 1019195

# ==============================================================================
# WHL Scorebar - https://lscluster.hockeytech.com/feed/index.php?feed=modulekit&key=41b145a848f4bd67&site_id=2&client_code=whl&lang=en&view=scorebar&numberofdaysahead=3&numberofdaysback=0&league_code=&fmt=json
# ==============================================================================
WHL_SCOREBAR_URL <- sprintf(
  "%s&key=%s&site_id=%d&client_code=%s&lang=%s&view=%s&numberofdaysahead=%s&numberofdaysback=%s&league_code=&fmt=json",
  HOCKEYTECH_BASE_API_URL_MODULE_KIT,
  HOCKEYTECH_API_PUBLIC_KEY,
  HOCKEYTECH_SITE_ID,
  HOCKEYTECH_CLIENT_CODE,
  HOCKEYTECH_LANGUAGE_CODE,
  HOCKEYTECH_VIEW_MODULE_KIT_SCOREBAR,
  HOCKEYTECH_VIEW_MODULE_KIT_SCOREBAR_NUMBER_OF_DAYS_AHEAD,
  HOCKEYTECH_VIEW_MODULE_KIT_SCOREBAR_NUMBER_OF_DAYS_BACK
)

# Load data from the API
whl_scorebar_details <- GET(url = WHL_SCOREBAR_URL)
whl_scorebar_text <- content(whl_scorebar_details, "text", encoding = "UTF-8") # Convert response
whl_scorebar_json <- fromJSON(whl_scorebar_text) # Parse JSON

# Convert data into dataframes
whl_scorebar_dataframe <- as.data.frame(whl_scorebar_json$SiteKit)
whl_scorebar_dataframe_raw <- enframe(unlist(whl_scorebar_json)) # Use Tibble to generate a LONG list of all the data

# ==============================================================================

# ==============================================================================
# Example 2 - https://cluster.leaguestat.com/feed/index.php?feed=gc&key=41b145a848f4bd67&client_code=whl&game_id=1019157&lang_code=en&fmt=json&tab=preview
# ==============================================================================
# HOCKEYTECH_VIEW_GAME_CENTER_TAB_PREVIEW
EXPLORE_2_URL <- sprintf(
  "%s&key=%s&client_code=%s&game_id=%d&lang_code=%s&fmt=json&tab=%s",
  HOCKEYTECH_BASE_API_URL_GAME_CENTER,
  HOCKEYTECH_API_PUBLIC_KEY,
  HOCKEYTECH_CLIENT_CODE,
  HOCKEYTECH_GAME_ID,
  HOCKEYTECH_LANGUAGE_CODE,
  HOCKEYTECH_VIEW_GAME_CENTER_TAB_PREVIEW
)

# Load data from the API
example_2_details <- GET(url = EXPLORE_2_URL)
example_2_text <- content(example_2_details, "text", encoding = "UTF-8") # Convert response
example_2_json <- fromJSON(example_2_text) # Parse JSON

# Convert data into dataframes
example_2_dataframe <- as.data.frame(example_2_json$GC$Preview$current_season)
example_2_dataframe_raw <- enframe(unlist(example_2_json)) # Use Tibble to generate a LONG list of all the data

# ==============================================================================

# ==============================================================================
# Example 3 - https://cluster.leaguestat.com/feed/index.php?feed=gc&key=41b145a848f4bd67&client_code=whl&game_id=1019157&lang_code=en&fmt=json&tab=pxpverbose
# ==============================================================================
# HOCKEYTECH_VIEW_GAME_CENTER_TAB_PLAY_BY_PLAY
EXPLORE_3_URL <- sprintf(
  "%s&key=%s&client_code=%s&game_id=%d&lang_code=%s&fmt=json&tab=%s",
  HOCKEYTECH_BASE_API_URL_GAME_CENTER,
  HOCKEYTECH_API_PUBLIC_KEY,
  HOCKEYTECH_CLIENT_CODE,
  HOCKEYTECH_GAME_ID,
  HOCKEYTECH_LANGUAGE_CODE,
  HOCKEYTECH_VIEW_GAME_CENTER_TAB_PLAY_BY_PLAY
)

# Load data from the API
example_3_details <- GET(url = EXPLORE_3_URL)
example_3_text <- content(example_3_details, "text", encoding = "UTF-8") # Convert response
example_3_json <- fromJSON(example_3_text) # Parse JSON

# Convert data into dataframes
example_3_dataframe <- as.data.frame(example_3_json$GC$Pxpverbose)
example_3_dataframe_raw <- enframe(unlist(example_3_json)) # Use Tibble to generate a LONG list of all the data

# ==============================================================================

# ==============================================================================
# Example 4 - https://cluster.leaguestat.com/feed/index.php?feed=gc&key=41b145a848f4bd67&client_code=whl&game_id=1019157&lang_code=en&fmt=json&tab=clock
# ==============================================================================
# HOCKEYTECH_VIEW_GAME_CENTER_TAB_CLOCK
EXPLORE_4_URL <- sprintf(
  "%s&key=%s&client_code=%s&game_id=%d&lang_code=%s&fmt=json&tab=%s",
  HOCKEYTECH_BASE_API_URL_GAME_CENTER,
  HOCKEYTECH_API_PUBLIC_KEY, HOCKEYTECH_CLIENT_CODE,
  HOCKEYTECH_GAME_ID,
  HOCKEYTECH_LANGUAGE_CODE,
  HOCKEYTECH_VIEW_GAME_CENTER_TAB_CLOCK
)

# Load data from the API
example_4_details <- GET(url = EXPLORE_4_URL)
example_4_text <- content(example_4_details, "text", encoding = "UTF-8") # Convert response
example_4_json <- fromJSON(example_4_text) # Parse JSON

# Convert data into dataframes
example_4_dataframe <- as.data.frame(example_4_json$GC$Clock)
example_4_dataframe_raw <- enframe(unlist(example_4_json)) # Use Tibble to generate a LONG list of all the data

# ==============================================================================

# ==============================================================================
# Example 5 - https://cluster.leaguestat.com/feed/index.php?feed=gc&key=41b145a848f4bd67&client_code=whl&game_id=1019157&lang_code=en&fmt=json&tab=gamesummary
# ==============================================================================
# HOCKEYTECH_VIEW_GAME_CENTER_TAB_GAME_SUMMARY
EXPLORE_5_URL <- sprintf(
  "%s&key=%s&client_code=%s&game_id=%d&lang_code=%s&fmt=json&tab=%s",
  HOCKEYTECH_BASE_API_URL_GAME_CENTER,
  HOCKEYTECH_API_PUBLIC_KEY, HOCKEYTECH_CLIENT_CODE,
  HOCKEYTECH_GAME_ID,
  HOCKEYTECH_LANGUAGE_CODE,
  HOCKEYTECH_VIEW_GAME_CENTER_TAB_GAME_SUMMARY
)

# Load data from the API
example_5_details <- GET(url = EXPLORE_5_URL)
example_5_text <- content(example_5_details, "text", encoding = "UTF-8") # Convert response
example_5_json <- fromJSON(EXPLORE_5_URL) # Parse JSON

# Convert data into dataframes
example_5_dataframe <- as.data.frame(example_5_json$GC$Gamesummary$meta)
example_5_dataframe_raw <- enframe(unlist(example_5_json)) # Use Tibble to generate a LONG list of all the data

# You can also use select() to create a dataframe with a subset of variables
filtered_example_5_dataframe <- example_5_dataframe %>%
  select(visiting_goal_count, home_goal_count, period, game_clock)

# Let's grab some data
shots_by_period <- as.data.frame(example_5_json$GC$Gamesummary$shotsByPeriod)
total_shots <- as.data.frame(example_5_json$GC$Gamesummary$totalShots)

# ==============================================================================

# ==============================================================================
# Additional functionality to incorporate - inspired by the hockeytech Node.js
# module at https://github.com/jonathas/hockeytech/blob/develop/index.js
# ==============================================================================
# getDailySchedule
# getGamesPerDay
# getRoster
# getScorebar
# getPlayerProfileBio
# getPlayerProfileMedia
# getPlayerProfileStatsBySeason
# getPlayerProfileGameByGameStats
# getPlayerProfileCurrentSeasonStats
# getSeasonList
# getTeamsBySeason
# getSeasonSchedule
# getStandingTypes
# getStandings
# getLeadersSkaters
# getLeadersGoalies
# getTopSkaters
# getTopGoalies
# getSkatersByTeam
# getGoaliesByTeam
# getStreaks
# getTransactions
# getPlayoff
# searchPerson
# getGamePreview
# getGamePlayByPlay
# getGameClock
# getGameSummary
# ==============================================================================
