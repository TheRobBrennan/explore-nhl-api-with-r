# Install packages
install.packages("nhlapi")
install.packages("ggplot2")
install.packages("dplyr")    # The %>% is no longer natively supported by R

# Alternatively - Install the development version from GitHub
#  devtools::install_github("jozefhajnala/nhlapi")
#  remotes::install_github("jozefhajnala/nhlapi")

# Use packages
library(nhlapi)
library(ggplot2)
library(dplyr)

# Read in our RDS file
REGULAR_SEASON_RDS_FILE <- "gamefeeds_regular_2017.rds"
REGULAR_SEASON_RDS_PATH <- sprintf("%s/examples/NHL API - Exploring and plotting positional ice hockey data on goals penalties and more from R with the nhlapi package/assets/%s", getwd(), REGULAR_SEASON_RDS_FILE)
gameFeeds = readRDS(REGULAR_SEASON_RDS_PATH)

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
