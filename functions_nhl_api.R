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

get_roster <- function(team_abbr, season) {
  base_url <- "https://api-web.nhle.com/v1/roster"
  #team_abbr <- teams_df$team_abbr[1]
  #season <- "20242025"

  # Build API URL
  url <- glue("{base_url}/{team_abbr}/{season}")
  # Make GET request
  response <- GET(url)

  # Check if response was successful
  if (status_code(response) == 200) {
    # Parse JSON response
    roster_data <- fromJSON(content(response, "text"), 
                    simplifyDataFrame = FALSE)
    print(roster_data)
  } else {
    print(paste("Failed to retrieve data:", status_code(response)))
  }
  return(roster_data)
} # end get_roster function

# parse out the data based on the position lists 
clean_player_list <- function(player_list, position) {
  map_dfr(player_list, function(x) {
    tibble(
      id = x$id,
      headshot = x$headshot,
      firstName = x$firstName[["default"]],
      lastName = x$lastName[["default"]],
      sweaterNumber = if ("sweaterNumber" %in% names(x)) x$sweaterNumber else NA_integer_,
      position = position,
      positionCode = x$positionCode,
      shootsCatches = x$shootsCatches,
      heightInInches = x$heightInInches,
      weightInPounds = x$weightInPounds,
      heightInCentimeters = x$heightInCentimeters,
      weightInKilograms = x$weightInKilograms,
      birthDate = x$birthDate,
      birthCity = x$birthCity[["default"]],
      birthCountry = x$birthCountry
    )
  }) # end map
} # end clean_player_list

# combine single team/season processinto single function
get_full_roster <- function(team_abbr, season) {
  roster_data <- get_roster(team_abbr, season)
  fwd_clean <- clean_player_list(roster_data$forwards, "FWD")
  def_clean <- clean_player_list(roster_data$defensemen, "DEF")
  gk_clean <- clean_player_list(roster_data$goalies, "GK")
  team_roster <- bind_rows(fwd_clean, def_clean, gk_clean)
  team_roster <- team_roster %>% mutate(
    team_code = team_abbr,
    season = season
  )
  return(team_roster)
}

# test
#teams_df <- read.csv("teams_df.csv")
#team_abbr <- teams_df$team_abbr[4]
#season <- "20242025"
#team_roster <- get_full_roster(team_abbr, season)
