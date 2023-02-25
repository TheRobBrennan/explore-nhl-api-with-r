# Installing the packages
# install.packages("httr")
# install.packages("jsonlite")
# install.packages("dplyr")    # The %>% is no longer natively supported by the R language
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

# 2023.02.25 => POR @ SEA - https://whl.ca/gamecentre/1019217/preview
HOCKEYTECH_GAME_ID <- 1019217

# =============================================================================
# WHL Scorebar - https://lscluster.hockeytech.com/feed/index.php?feed=modulekit&key=41b145a848f4bd67&site_id=2&client_code=whl&lang=en&view=scorebar&numberofdaysahead=3&numberofdaysback=0&league_code=&fmt=json
# =============================================================================
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
# =============================================================================

# =============================================================================
# WHL game preview & HockeyTech configuration - https://cluster.leaguestat.com/feed/index.php?feed=gc&key=41b145a848f4bd67&client_code=whl&game_id=1019195&lang_code=en&fmt=json&tab=preview
# =============================================================================
WHL_GAME_PREVIEW_AND_HOCKEYTECH_CONFIGURATION_URL <- sprintf(
  "%s&key=%s&client_code=%s&game_id=%d&lang_code=%s&fmt=json&tab=%s",
  HOCKEYTECH_BASE_API_URL_GAME_CENTER,
  HOCKEYTECH_API_PUBLIC_KEY,
  HOCKEYTECH_CLIENT_CODE,
  HOCKEYTECH_GAME_ID,
  HOCKEYTECH_LANGUAGE_CODE,
  HOCKEYTECH_VIEW_GAME_CENTER_TAB_PREVIEW
)

# Load data from the API
whl_game_preview_and_hockeytech_configuration_details <- GET(url = WHL_GAME_PREVIEW_AND_HOCKEYTECH_CONFIGURATION_URL)
whl_game_preview_and_hockeytech_configuration_text <- content(whl_game_preview_and_hockeytech_configuration_details, "text", encoding = "UTF-8") # Convert response
whl_game_preview_and_hockeytech_configuration_json <- fromJSON(whl_game_preview_and_hockeytech_configuration_text) # Parse JSON

# Convert data into dataframes
whl_game_and_hockeytech_configuration_dataframe_raw <- enframe(unlist(whl_game_preview_and_hockeytech_configuration_json)) # Use Tibble to generate a LONG list of all the data
whl_game_and_hockeytech_configuration_dataframe <- as.data.frame(whl_game_preview_and_hockeytech_configuration_json$GC$Preview$current_season) # TODO - This will be great to explore in the future
# =============================================================================

# =============================================================================
# WHL play-by-play - https://cluster.leaguestat.com/feed/index.php?feed=gc&key=41b145a848f4bd67&client_code=whl&game_id=1019195&lang_code=en&fmt=json&tab=pxpverbose
# =============================================================================
WHL_PLAY_BY_PLAY_URL <- sprintf(
  "%s&key=%s&client_code=%s&game_id=%d&lang_code=%s&fmt=json&tab=%s",
  HOCKEYTECH_BASE_API_URL_GAME_CENTER,
  HOCKEYTECH_API_PUBLIC_KEY,
  HOCKEYTECH_CLIENT_CODE,
  HOCKEYTECH_GAME_ID,
  HOCKEYTECH_LANGUAGE_CODE,
  HOCKEYTECH_VIEW_GAME_CENTER_TAB_PLAY_BY_PLAY
)

# Load data from the API
whl_play_by_play_details <- GET(url = WHL_PLAY_BY_PLAY_URL)
whl_play_by_play_text <- content(whl_play_by_play_details, "text", encoding = "UTF-8") # Convert response
whl_play_by_play_json <- fromJSON(whl_play_by_play_text) # Parse JSON

# Convert data into dataframes
whl_play_by_play_dataframe <- as.data.frame(whl_play_by_play_json$GC$Pxpverbose)
whl_play_by_play_dataframe_raw <- enframe(unlist(whl_play_by_play_json)) # Use Tibble to generate a LONG list of all the data
# =============================================================================

# =============================================================================
# WHL game center clock and quick links - https://cluster.leaguestat.com/feed/index.php?feed=gc&key=41b145a848f4bd67&client_code=whl&game_id=1019195&lang_code=en&fmt=json&tab=clock
# =============================================================================
WHL_GAME_CENTER_CLOCK_AND_QUICK_LINKS_URL <- sprintf(
  "%s&key=%s&client_code=%s&game_id=%d&lang_code=%s&fmt=json&tab=%s",
  HOCKEYTECH_BASE_API_URL_GAME_CENTER,
  HOCKEYTECH_API_PUBLIC_KEY, HOCKEYTECH_CLIENT_CODE,
  HOCKEYTECH_GAME_ID,
  HOCKEYTECH_LANGUAGE_CODE,
  HOCKEYTECH_VIEW_GAME_CENTER_TAB_CLOCK
)

# Load data from the API
whl_game_center_clock_and_quick_links_details <- GET(url = WHL_GAME_CENTER_CLOCK_AND_QUICK_LINKS_URL)
whl_game_center_clock_and_quick_links_text <- content(whl_game_center_clock_and_quick_links_details, "text", encoding = "UTF-8") # Convert response
whl_game_center_clock_and_quick_links_json <- fromJSON(whl_game_center_clock_and_quick_links_text) # Parse JSON

# Convert data into dataframes
whl_game_center_clock_and_quick_links_dataframe <- as.data.frame(whl_game_center_clock_and_quick_links_json$GC$Clock)
whl_game_center_clock_and_quick_links_dataframe_raw <- enframe(unlist(whl_game_center_clock_and_quick_links_json)) # Use Tibble to generate a LONG list of all the data
# =============================================================================

# =============================================================================
# WHL game summary - https://cluster.leaguestat.com/feed/index.php?feed=gc&key=41b145a848f4bd67&client_code=whl&game_id=1019195&lang_code=en&fmt=json&tab=gamesummary
# =============================================================================
WHL_GAME_SUMMARY_URL <- sprintf(
  "%s&key=%s&client_code=%s&game_id=%d&lang_code=%s&fmt=json&tab=%s",
  HOCKEYTECH_BASE_API_URL_GAME_CENTER,
  HOCKEYTECH_API_PUBLIC_KEY, HOCKEYTECH_CLIENT_CODE,
  HOCKEYTECH_GAME_ID,
  HOCKEYTECH_LANGUAGE_CODE,
  HOCKEYTECH_VIEW_GAME_CENTER_TAB_GAME_SUMMARY
)

# Load data from the API
whl_game_summary_details <- GET(url = WHL_GAME_SUMMARY_URL)
whl_game_summary_text <- content(whl_game_summary_details, "text", encoding = "UTF-8") # Convert response
whl_game_summary_json <- fromJSON(WHL_GAME_SUMMARY_URL) # Parse JSON

# Convert data into dataframes
whl_game_summary_dataframe <- as.data.frame(whl_game_summary_json$GC$Gamesummary$meta)
whl_game_summary_dataframe_raw <- enframe(unlist(whl_game_summary_json)) # Use Tibble to generate a LONG list of all the data

# You can also use select() to create a dataframe with a subset of variables
whl_game_summary_dataframe_filtered <- whl_game_summary_dataframe %>%
  select(visiting_goal_count, home_goal_count, period, game_clock)

# Let's grab some data
whl_game_summary_shots_by_period_dataframe <- as.data.frame(whl_game_summary_json$GC$Gamesummary$shotsByPeriod)
whl_game_summary_total_shots_dataframe <- as.data.frame(whl_game_summary_json$GC$Gamesummary$totalShots)
# =============================================================================
