# Installing the packages
# install.packages("httr")
# install.packages("jsonlite")

# Loading packages
library(httr)
library(jsonlite)

# 2023.02.20 => SEA @ SJS - https://www.nhl.com/gamecenter/sea-vs-sjs/2023/02/20/2022020905
NHL_GAME_ID <- 2022020905

# Build the URL to load our live game data
NHL_BASE_API_URL <- "https://statsapi.web.nhl.com/api/v1"
NHL_LIVE_GAME_URL <- sprintf("%s/game/%d/feed/live", NHL_BASE_API_URL, NHL_GAME_ID)

# Call our API to load the game_details
game_details <- GET(url = NHL_LIVE_GAME_URL)
game_text <- content(game_details, "text", encoding = "UTF-8") # Convert response
game_json <- fromJSON(game_text) # Parse JSON

# Convert data into dataframes
gameData_dataframe <- as.data.frame(game_json$gameData) # Game data
metaData_dataframe <- as.data.frame(game_json$metaData) # Meta data
allPlays_dataframe <- as.data.frame(game_json$liveData$plays$allPlays) # All plays for the game
linescore_dataframe <- as.data.frame(game_json$liveData$linescore) # Line score
decisions_dataframe <- as.data.frame(game_json$liveData$decisions) # Decisions

# Away team
awayteam_dataframe <- as.data.frame(game_json$liveData$boxscore$teams$away$team) # Team name, short code
awayteamStats_dataframe <- as.data.frame(game_json$liveData$boxscore$teams$away$teamStats) # Summary of goals, PIM, shots, power play by the numbers, hits, blocked shots, takeaways, giveaways, etc.

# Home team
hometeam_dataframe <- as.data.frame(game_json$liveData$boxscore$teams$home$team) # Team name, short code
hometeamStats_dataframe <- as.data.frame(game_json$liveData$boxscore$teams$home$teamStats) # Summary of goals, PIM, shots, power play by the numbers, hits, blocked shots, takeaways, giveaways, etc.
