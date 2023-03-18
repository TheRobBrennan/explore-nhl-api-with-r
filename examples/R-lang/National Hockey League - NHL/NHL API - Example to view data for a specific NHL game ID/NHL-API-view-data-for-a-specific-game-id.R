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

# Click on an individual game in the scorebar at https://www.nhl.com to get the game ID
NHL_GAME_ID <- 2022021098

# Build the URL to load our live game data
NHL_BASE_API_URL <- "https://statsapi.web.nhl.com/api/v1"
NHL_LIVE_GAME_URL <- sprintf("%s/game/%d/feed/live", NHL_BASE_API_URL, NHL_GAME_ID)

# Build the URL to loud our NHL schedule data
NHL_SCHEDULE_START_DATE <- Sys.Date() # "2023-02-25"
NHL_SCHEDULE_END_DATE <- Sys.Date() # "2023-02-25"
NHL_SCHEDULE_URL <- sprintf(
  "%s/schedule?startDate=%s&endDate=%s&hydrate=team,linescore,broadcasts(all),tickets,game(content(media(epg)),seriesSummary),radioBroadcasts,metadata,seriesSummary(series)&site=en_nhl&teamId=&gameType=&timecode=",
  NHL_BASE_API_URL,
  NHL_SCHEDULE_START_DATE,
  NHL_SCHEDULE_END_DATE
)

# Call our API to load schedule details
schedule_details <- GET(url = NHL_SCHEDULE_URL)
schedule_details_text <- content(schedule_details, "text", encoding = "UTF-8") # Convert response
schedule_details_json <- fromJSON(schedule_details_text) # Parse JSON

# Convert data into dataframes
schedule_details_dataframe <- as.data.frame(schedule_details_json$dates)

schedule_details_games_dataframe <- as.data.frame(schedule_details_json$dates$games)
# schedule_details_games_dataframe_raw <- enframe(unlist(schedule_details_json$dates$games)) # Use Tibble to generate a LONG list of all the data

schedule_details_games_dataframe_filtered <- schedule_details_games_dataframe %>%
  as_tibble() %>%
  select(gamePk, gameDate, status, teams, linescore) %>%
  unnest(status) %>%
  unnest(teams) %>%
  select(gamePk, gameDate, abstractGameState, detailedState, everything())

try(
  nhl_scoreboard_dataframe <- schedule_details_games_dataframe_filtered %>%
    unnest(away, names_sep = ".") %>%
    unnest(away.team, names_sep = ".") %>%
    unnest(home, names_sep = ".") %>%
    unnest(home.team, names_sep = ".") %>%
    unnest(linescore, names_sep = ".") %>%
    select(
      linescore.currentPeriodOrdinal,
      linescore.currentPeriodTimeRemaining,
      away.team.name, away.score,
      home.team.name, home.score,
      gamePk, gameDate,
      linescore.teams
    ),
  silent = TRUE
)

# OPTIONAL: Convert our filtered data frame to JSON
# schedule_details_games_dataframe_filtered_toJSON <- toJSON(schedule_details_games_dataframe_filtered, pretty = TRUE)

# Call our API to load the game_details
game_details <- GET(url = NHL_LIVE_GAME_URL)
game_details_text <- content(game_details, "text", encoding = "UTF-8") # Convert response
game_details_json <- fromJSON(game_details_text) # Parse JSON

# Convert data into dataframes

# Away team
try(awayteam_dataframe <- as.data.frame(game_details_json$liveData$boxscore$teams$away$team), silent = TRUE) # Team name, short code
try(awayteamStats_dataframe <- as.data.frame(game_details_json$liveData$boxscore$teams$away$teamStats), silent = TRUE) # Summary of goals, PIM, shots, power play by the numbers, hits, blocked shots, takeaways, giveaways, etc.

# Home team
try(hometeam_dataframe <- as.data.frame(game_details_json$liveData$boxscore$teams$home$team), silent = TRUE) # Team name, short code
try(hometeamStats_dataframe <- as.data.frame(game_details_json$liveData$boxscore$teams$home$teamStats), silent = TRUE) # Summary of goals, PIM, shots, power play by the numbers, hits, blocked shots, takeaways, giveaways, etc.

# Game data will error out here if we are looking at a scheduled game.
# All other data frame examples work just fine for scheduled or live/completed games.
try(gameData_dataframe <- as.data.frame(game_details_json$gameData), silent = TRUE)
try(allPlays_dataframe <- as.data.frame(game_details_json$liveData$plays$allPlays), silent = TRUE) # All plays for the game
try(linescore_dataframe <- as.data.frame(game_details_json$liveData$linescore), silent = TRUE) # Line score
try(decisions_dataframe <- as.data.frame(game_details_json$liveData$decisions), silent = TRUE) # Decisions
