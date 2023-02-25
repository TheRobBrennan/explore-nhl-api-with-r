# Installing the packages
# install.packages("httr")
# install.packages("jsonlite")

# Loading packages
library(httr)
library(jsonlite)

# Click on an individual game in the scorebar at https://www.nhl.com to get the game ID
NHL_GAME_ID <- 2022020946

# Build the URL to load our live game data
NHL_BASE_API_URL <- "https://statsapi.web.nhl.com/api/v1"
NHL_LIVE_GAME_URL <- sprintf("%s/game/%d/feed/live", NHL_BASE_API_URL, NHL_GAME_ID)

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
