# getting team abbreviations
# save results to csv

# Get team abbreviations ----
# read in team abbreviation table from teams.md
# from https://github.com/JayBlackedOut/hass-nhlapi/blob/master/teams.md
teams_text <- readLines("data/teams.md")
teams_df <- read.delim(text = paste(teams_text, collapse = "\n"), 
            sep="|", header=TRUE, row.names = NULL)
# remove first row: just -----
teams_df <- teams_df[-1,]
# rename columns
teams_df <- teams_df %>% rename(
  team_name = Team.Name, 
  team_id = Team.ID, 
  team_abbr = Team.Abbr)
# select only relevant (other is noise)
teams_df <- teams_df %>% select(team_name, team_id, team_abbr)
# remove spaces before/after names
teams_df <- teams_df %>% mutate(
  team_name = str_trim(team_name),
  team_id = str_trim(team_id),
  team_abbr = str_trim(team_abbr)
)
# convert id to integer
teams_df$team_id <- as.integer(teams_df$team_id)
# clean-up row names
rownames(teams_df) <- seq(1:nrow(teams_df))
# save locally
write.csv(teams_df, "teams_df.csv", row.names = FALSE)
