# Current CRAN version:
install.packages("nhlapi")
install.packages("ggplot2")
install.packages("dplyr")    # The %>% is no longer natively supported by R

# Development version from GitHub
#  devtools::install_github("jozefhajnala/nhlapi")
#  remotes::install_github("jozefhajnala/nhlapi")

library(nhlapi)
library(ggplot2)
library(dplyr)

# Let's start exploring this package by using the help() function in R
# All the relevant functions start with the nhl_ prefix.
#   PRO TIP: If this is your first time using help, notice how we can
#     use autocompletion to narrow down our functions to review
# help("nhl_games")

# Retrieving basic game information
# Let’s look at the very basic game results using the nhl_games_linescore() function
linescore <- nhlapi::nhl_games_linescore(gameIds = 2017020001)[[1]]
# Look at quick info on periods
linescore$periods

# Getting detailed events data for a game
# Let's investigate what plays were made during the game and where on the ice they happened. 
# We can use nhl_games_feed() to get the most detailed game data available in the API. 
# To get a picture of the amount of detail, we can print the structure of the retrieved object limited to 3 levels of depth
gameIds <- 2017020001
gameFeed <- nhlapi::nhl_games_feed(gameIds = gameIds)[[1]]
str(gameFeed, max.level = 3)
# Now let's finally look at the data on plays. We can access those via the allPlays data.frame inside the element plays of liveData. 
# The below code chunk will store those in a separate data.frame called plays. 
# We can then filter based on result.event to look for instance only at goals.
plays <- gameFeed$liveData$plays$allPlays
goals <- plays[plays$result.event == "Goal", ]
# Selecting limited columns to keep the print reasonable
goals[, c(2, 5, 6, 12, 15, 18, 26, 23, 24)]

# More involved data retrieval - many games in parallel
# Now we know how to look at the positional data for one match so one very interesting aspect of the data is where plays happen overall. 
# We will now investigate and plot where different plays were happening in the regular season 2017/2018. 
# Looking at ?nhl_games we see that for regular seasons we can usually get all the gameIds in the interval 2017020001:2017021271.
# Define the game ids
gameIds <- 2017020001:2017021271
# Retrieve the data
gameFeeds <- nhlapi::nhl_games_feed(gameIds)

# To retrieve the data a bit faster, we can also use the parallel package which is part of the base R installation to retrieve the data in parallel
# Define the game ids
gameIds <- 2017020001:2017021271
# Create a local cluster 
cl <- parallel::makeCluster(parallel::detectCores() / 2)
# Retrieve the data using nhlapi::nhl_games_feed()
gameFeeds <- parallel::parLapplyLB(cl, gameIds, nhlapi::nhl_games_feed)
# Stop the cluster
parallel::stopCluster(cl)

# This is a large data set (~1.4 GB for the 2017-18 season), so let's use saveRDS to store this on disk
REGULAR_SEASON_RDS_PATH <- sprintf("%s/examples/NHL API - Exploring and plotting positional ice hockey data on goals penalties and more from R with the nhlapi package/assets", getwd())
saveRDS(gameFeeds, file.path(REGULAR_SEASON_RDS_PATH, "gamefeeds_regular_2017.rds")) # ~34.1 MB is the RDS file size 🤓

# Processing and plotting positional data
# Retrieve the data frames with plays from the data
getPlaysDf <- function(gm) {
  playsRes <- try(gm[[1L]][["liveData"]][["plays"]][["allPlays"]])
  if (inherits(playsRes, "try-error")) data.frame() else playsRes
}
plays <- lapply(gameFeeds, getPlaysDf)
# Bind the list into a single data frame
plays <- nhlapi:::util_rbindlist(plays)
# Keep only the records that have coordinates
plays <- plays[!is.na(plays$coordinates.x), ]
# Move the coordinates to non-negative values before plotting
plays$coordx <- plays$coordinates.x + abs(min(plays$coordinates.x))
plays$coordy <- plays$coordinates.y + abs(min(plays$coordinates.y))

# Now we have the data ready in a plays data.frame, finally we can create some cool plots. 
# As an example, in the following chunk the popular ggplot2 package is used to plot densities and events that would yield results 
# similar to the ones shown below
# Note the %>% pipe to indicate that the following line is part of the same code chunk
goals <- plays %>%
  filter(result.eventTypeId == "GOAL")

ggplot(goals, aes(x = coordx, y = coordy)) +
  labs(title = "Where are goals scored from") +
  geom_point(alpha = 0.1, size = 0.2) +
  xlim(0, 198) + ylim(0, 84) +
  geom_density_2d_filled(alpha = 0.35, show.legend = FALSE) +
  theme_void()
