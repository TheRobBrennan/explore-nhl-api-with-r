# Installing the packages
# install.packages("httr")
# install.packages("jsonlite")

# Loading packages
library(httr)
library(jsonlite)

# 2023.01.25 => VAN @ SEA - https://www.nhl.com/gamecenter/van-vs-sea/2023/01/25/2022020770/ice-tracker/plays#game=2022020770,game_state=live,lock_state=live,game_tab=plays
# Expected 20 SOG for VAN / 35 SOG for SEA - SEA wins 6-1
NHL_GAME_ID <- 2022020770

# Build the URL to load our live game data
NHL_LIVE_GAME_URL <- sprintf("https://statsapi.web.nhl.com/api/v1/game/%d/feed/live", NHL_GAME_ID)

# Call our API to load the game_details
game_details <- GET(url = NHL_LIVE_GAME_URL)
game_text <- content(game_details, "text", encoding = "UTF-8") # Convert response
game_json <- fromJSON(game_text) # Parse JSON

# Convert data into dataframes
game_dataframe <- as.data.frame(game_json$gameData) # Game data
allPlays_dataframe <- as.data.frame(game_json$liveData$plays$allPlays) # All plays for the game
