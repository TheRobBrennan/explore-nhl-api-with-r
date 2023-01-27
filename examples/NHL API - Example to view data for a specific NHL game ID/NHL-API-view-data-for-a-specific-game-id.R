# Installing the packages
# install.packages("httr")
# install.packages("jsonlite")

# Loading packages
library(httr)
library(jsonlite)

# 2023.01.17 => SEA @ EDM
  # https://www.nhl.com/gamecenter/sea-vs-edm/2023/01/17/2022020711#game=2022020711,game_state=final,lock_state=final,game_tab=stats
  # Expected 31 SOG for SEA / 33 SOG for EDM - EDM wins 5-2
# NHL_GAME_ID = 2022020711

# 2023.01.19 => NJD @ SEA 
  # https://www.nhl.com/gamecenter/njd-vs-sea/2023/01/19/2022020728/recap/stats#game=2022020728,game_state=final,lock_state=final,game_tab=stats
  # Expected 30 SOG for NJD / 40 SOG for SEA - SEA wins 4-3 in OT
# NHL_GAME_ID = 2022020728

# 2023.01.21 => COL @ SEA 
  # https://www.nhl.com/gamecenter/col-vs-sea/2023/01/21/2022020743/recap/stats#game=2022020743,game_state=final,lock_state=final,game_tab=stats
  # Expected 27 SOG for COL / 27 SOG for SEA - COL wins 2-1 in SO
# NHL_GAME_ID = 2022020743

# 2023.01.25 => VAN @ SEA 
  # https://www.nhl.com/gamecenter/van-vs-sea/2023/01/25/2022020770/ice-tracker/plays#game=2022020770,game_state=live,lock_state=live,game_tab=plays
  # Expected 20 SOG for VAN / 35 SOG for SEA - SEA wins 6-1
NHL_GAME_ID <- 2022020770

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
