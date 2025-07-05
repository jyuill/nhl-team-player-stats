# NHL-team-player-stats

Exploring stats related to NHL league, teams, players.

## Current API

As of July 2025, API can be found here:

### API Documentation 
* https://gitlab.com/dword4/nhlapi/-/blob/master/new-api.md
* https://github.com/JayBlackedOut/hass-nhlapi 
* https://publicapi.dev/nhl-records-and-stats-api

### Teams

Teams are identified by 3-letter abbreviation.
Table found here: https://github.com/JayBlackedOut/hass-nhlapi/blob/master/teams.md

* stored here as teams_df.csv

## Key Components

**functions_nhl_api.R:** - functions for fetching data from NHL API; currently just player roster info 