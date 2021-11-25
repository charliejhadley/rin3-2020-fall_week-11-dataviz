library(tidyverse)
library(rvest)
library(janitor)

busiest_us_airports_table <- read_html("https://en.wikipedia.org/wiki/List_of_the_busiest_airports_in_the_United_States") %>% 
  html_table() %>% 
  .[[1]] %>% 
  clean_names()


busiest_us_airports_long <- busiest_us_airports_table %>% 
  rename(airport = airports_large_hubs) %>% 
  select(airport, starts_with("x")) %>% 
  pivot_longer(contains("x")) %>% 
  mutate(name = str_extract(name, "2[0-9]{3}"),
         name = as.integer(name),
         value = parse_number(value)) %>% 
  rename(year = name,
         passengers = value)
  


busiest_us_airports_long %>% 
  pivot_wider(values_from = passengers,
              names_from = year) %>% 
  slice_max(`2020`, n = 5) %>% 
  pivot_longer(contains("2"),
               values_to = "passengers",
               names_to = "year") %>% 
  write_csv("data/busiest-us-airports.csv")
