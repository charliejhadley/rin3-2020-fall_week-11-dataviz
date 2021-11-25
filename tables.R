library(tidyverse)
library(gt)


dr_who_episodes <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-11-23/episodes.csv')


most_popular_by_season <- dr_who_episodes %>% 
  select(season_number, episode_title, uk_viewers) %>% 
  mutate(uk_viewers = 1E6 * uk_viewers) %>% 
  arrange(season_number) %>% 
  drop_na() %>% 
  group_by(season_number) %>% 
  filter(uk_viewers == max(uk_viewers)) %>% 
  ungroup() %>% 
  mutate(growth = (uk_viewers - lag(uk_viewers)) / uk_viewers)

most_popular_by_season %>% 
  gt() %>% 
  cols_label(season_number = "Season",
             episode_title = "Episode Title",
             uk_viewers = "UK Viewers (Millions)",
             growth = "Growth (compared to previous season)") %>% 
  fmt_number(columns = uk_viewers,
             suffixing = TRUE) %>% 
  fmt_percent(growth) %>% 
  fmt_missing(columns = growth,
              missing_text = "") %>% 
  tab_style(
    style = cell_text(color = "red"),
    locations = cells_body(
    columns = growth,
    rows = growth < 0
  ))
