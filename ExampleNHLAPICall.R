# Installing the packages
# install.packages("httr")
# install.packages("jsonlite")

# Loading packages
library(httr)
library(jsonlite)

# Initializing API Call
NHL_GAME_ID <- 2022020770
NHL_LIVE_GAME_URL <- sprintf("https://statsapi.web.nhl.com/api/v1/game/%d/feed/live", NHL_GAME_ID)

# Getting details in API
game_details <- GET(url = NHL_LIVE_GAME_URL)

# Converting content to text
game_text <- content(game_details, "text", encoding = "UTF-8")
game_text

# Parsing data in JSON
game_json <- fromJSON(game_text)
game_json

# Converting into dataframe
game_dataframe <- as.data.frame(game_json)

# All plays for the specified game
game_json$liveData$plays$allPlays
allPlays_dataframe <- as.data.frame(game_json$liveData$plays$allPlays)

