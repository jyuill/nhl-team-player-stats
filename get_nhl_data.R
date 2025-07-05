# Collect NHL team and player data from 
library(tidyverse)
library(httr)
library(jsonlite)
library(glue)
library(lubridate)
library(stringr)
# NHL API R package doesn't work due to changes to API
# https://cran.r-project.org/web/packages/nhlapi/readme/README.html

# NOW:
# https://api-web.nhle.com/v1/ 

# load functions for getting data
source("functions_nhl_api.R")
# get team info
teams_df <- read.csv("data/teams_df.csv")

# Player rosters ----
# get by team and season
team_roster_all <- data.frame()
season_select <- "20242025"
for(t in 1:nrow(teams_df)) {
  team_abbr <- teams_df$team_abbr[t]
  season <- season_select
  team_roster <- get_full_roster(team_abbr, season)
  team_roster_all <- bind_rows(team_roster_all, team_roster)
}

# write to csv
write_csv(team_roster_all, "data/team_roster_all.csv")
write_csv(team_roster_all, paste0("team_roster_all-",season_select,".csv"))
