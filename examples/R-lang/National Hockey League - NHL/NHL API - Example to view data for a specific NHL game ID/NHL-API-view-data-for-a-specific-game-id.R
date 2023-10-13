# Installing the packages
# install.packages("httr")
# install.packages("jsonlite")
# install.packages("dplyr")    # The %>% is no longer natively supported by the R language
# install.packages("tibble")
# install.packages("tidyr")
# install.packages("lubridate")
# install.packages("purrr")

# Loading packages
library(httr)
library(jsonlite)
library(dplyr)
library(tibble)
library(tidyr)
library(lubridate)
library(purrr)

try(
  {
    # Click on an individual game in the scorebar at https://www.nhl.com to get the game ID
    NHL_GAME_ID <- 2022030324

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
    nhl_schedule_details <- GET(url = NHL_SCHEDULE_URL)
    nhl_schedule_details_text <- content(nhl_schedule_details, "text", encoding = "UTF-8") # Convert response
    nhl_schedule_details_json <- fromJSON(nhl_schedule_details_text) # Parse JSON

    # Convert data into dataframes
    nhl_schedule_details_dataframe <- as.data.frame(nhl_schedule_details_json$dates)

    nhl_schedule_details_games_dataframe <- as.data.frame(nhl_schedule_details_json$dates$games)
    # nhl_schedule_details_games_dataframe_raw <- enframe(unlist(nhl_schedule_details_json$dates$games)) # Use Tibble to generate a LONG list of all the data

    nhl_schedule_details_games_dataframe_filtered <- nhl_schedule_details_games_dataframe %>%
      as_tibble() %>%
      select(gamePk, gameDate, status, teams, linescore) %>%
      unnest(status) %>%
      unnest(teams) %>%
      mutate(
        # ymd_hms is used to convert the gameDate column in the dataframe to a date-time object
        gameDateYMDHMS = ymd_hms(gameDate), # 2023-05-13 02:00:00
        gameDateFormatted = format(
          # with_tz is used to convert the date-time object to the local time zone - which is "America/Los_Angeles" for Seattle WA
          with_tz(gameDateYMDHMS, Sys.timezone()),
          # format is used to format the date-time object to the desired output format ("%Y-%m-%d %I:%M%p %Z") which gives the date and time in the format "YYYY-MM-DD hh:mmAM/PM Timezone"
          # %I will display a twelve-hour time value with a leading zero. In this case, I want to use %l so we see the desired value
          format = "%Y-%m-%d %l:%M %p %Z" # 2023-05-12  7:00 PM PDT
        )
      ) %>%
      select(gamePk, gameDate, gameDateFormatted, everything())

    nhl_scoreboard_dataframe <- nhl_schedule_details_games_dataframe_filtered %>%
      unnest(away, names_sep = ".") %>%
      unnest(away.team, names_sep = ".") %>%
      unnest(home, names_sep = ".") %>%
      unnest(home.team, names_sep = ".") %>%
      mutate(
        # 2023.05.13 We're not entirely out of the woods troubleshooting linescore data that may or may not exist
        linescoreOriginal = linescore,
        linescoreOriginalCurrentPeriodOrdinal = ifelse(
          is.null(linescore) | is.null(linescore$currentPeriodOrdinal),
          NA,
          linescore$currentPeriodOrdinal
        ),
        linescoreOriginalCurrentPeriodTimeRemaining = ifelse(
          is.null(linescore) | is.null(linescore$currentPeriodTimeRemaining),
          NA,
          linescore$currentPeriodTimeRemaining
        ),
        # 2023.05.13 Let's stick with our solution earlier today and keep the above fields for debug information
        linescore = ifelse(
          is.null(linescore),
          NA,
          linescore
        )
      ) %>%
      mutate( # 2023.10.12 Use direct assignment from linescoreOriginal as the values for our current period ordinal and time remaining
        currentPeriodOrdinal = linescoreOriginal$currentPeriodOrdinal,
        currentPeriodTimeRemaining = linescoreOriginal$currentPeriodTimeRemaining,
        awaySOG = linescoreOriginal$teams$away$shotsOnGoal,
        homeSOG = linescoreOriginal$teams$home$shotsOnGoal,
      ) %>%
      mutate(
        gameDateFormatted = format(
          # with_tz is used to convert the date-time object to the local time zone - which is "America/Los_Angeles" for Seattle WA
          with_tz(gameDateYMDHMS, Sys.timezone()),
          # format is used to format the date-time object to the desired output format ("%Y-%m-%d %I:%M%p %Z") which gives the date and time in the format "YYYY-MM-DD hh:mmAM/PM Timezone"
          # %I will display a twelve-hour time value with a leading zero. In this case, I want to use %l so we see the desired value
          format = "%Y-%m-%d %l:%M %p %Z" # 2023-05-12  7:00 PM PDT
        )
      ) %>%
      select(
        gamePk, gameDateFormatted,
        away.team.name, away.score,
        home.team.name, home.score,
        currentPeriodOrdinal, currentPeriodTimeRemaining,
        awaySOG, homeSOG,
        linescoreOriginal
      )
  
    # View(nhl_scoreboard_dataframe)
    # colnames(nhl_scoreboard_dataframe)

    # OPTIONAL: Convert our filtered data frame to JSON
    # nhl_schedule_details_games_dataframe_filtered_toJSON <- toJSON(nhl_schedule_details_games_dataframe_filtered, pretty = TRUE)

    # Call our API to load the game_details
    nhl_game_details <- GET(url = NHL_LIVE_GAME_URL)
    nhl_game_details_text <- content(nhl_game_details, "text", encoding = "UTF-8") # Convert response
    nhl_game_details_json <- fromJSON(nhl_game_details_text) # Parse JSON

    # Convert data into dataframes

    # Away team
    try(nhl_awayteam_dataframe <- as.data.frame(nhl_game_details_json$liveData$boxscore$teams$away$team), silent = TRUE) # Team name, short code
    try(nhl_awayteamStats_dataframe <- as.data.frame(nhl_game_details_json$liveData$boxscore$teams$away$teamStats), silent = TRUE) # Summary of goals, PIM, shots, power play by the numbers, hits, blocked shots, takeaways, giveaways, etc.

    # Home team
    try(nhl_hometeam_dataframe <- as.data.frame(nhl_game_details_json$liveData$boxscore$teams$home$team), silent = TRUE) # Team name, short code
    try(nhl_hometeamStats_dataframe <- as.data.frame(nhl_game_details_json$liveData$boxscore$teams$home$teamStats), silent = TRUE) # Summary of goals, PIM, shots, power play by the numbers, hits, blocked shots, takeaways, giveaways, etc.

    # Game data will error out here if we are looking at a scheduled game.
    # All other data frame examples work just fine for scheduled or live/completed games.
    try(nhl_gameData_dataframe <- as.data.frame(nhl_game_details_json$gameData), silent = TRUE)
    try(nhl_allPlays_dataframe <- as.data.frame(nhl_game_details_json$liveData$plays$allPlays), silent = TRUE) # All plays for the game
    try(nhl_linescore_dataframe <- as.data.frame(nhl_game_details_json$liveData$linescore), silent = TRUE) # Line score
    try(nhl_decisions_dataframe <- as.data.frame(nhl_game_details_json$liveData$decisions), silent = TRUE) # Decisions
  },
  silent = TRUE
)
