library(tidyverse)
library(ggthemes)
library(ggtext)
library(ggrepel)
# devtools::install_github("gadenbuie/ggpomological")

busiest_us_airports <- read_csv("data/busiest-us-airports.csv")


min_passengers <- min(busiest_us_airports$passengers)
max_passengers <- max(busiest_us_airports$passengers)
annotation_y_center <- min_passengers + (max_passengers - min_passengers) / 2         

colors_airports <- c("Hartsfield-Jackson International Airport" = "#B0241F",
                     "Dallas/Fort Worth International Airport" = "#7F8D3C",
                     "Denver International Airport" = "#F97A1D",
                     "O'Hare International Airport" = "#F1B43A",
                     "Los Angeles International Airport" = "#DE7769")

# ==== Basic annotations


busiest_us_airports %>% 
  ggplot(aes(x = year,
             y = passengers,
             color = airport)) +
  geom_line(key_glyph = "timeseries") +
  geom_vline(xintercept = 2020) +
  annotate("text",
           x = 2020 + 0.2,
           y = annotation_y_center,
           label = "2020 Coronavirus Pandemic",
           angle = 90
  ) +
  scale_y_continuous(labels = scales::number_format(scale = 1E-6,
                                                    suffix = " Million")) +
  scale_x_continuous(breaks = unique(busiest_us_airports$year)) +
  scale_color_manual(values = colors_airports,
                     name = "") +
  labs(y = "Total passengers",
       title = "The COVID-19 pandemic has drastically affected passenger numbers amongst the top 5 busiest US airports.",
       subtitle = "<span style='color:#7F8D3C'>Dallas Airport</span> is the only airport to have increased passenger in 2020,") +
  theme_minimal() +
  theme(plot.subtitle = element_markdown())






# ==== With some additional effort ====

busiest_us_airports %>% 
  ggplot(aes(x = year,
             y = passengers,
             color = airport)) +
  geom_line(key_glyph = "timeseries") +
  geom_vline(xintercept = 2020) +
  geom_label_repel(aes(label = ifelse(year == 2009, scales::number(passengers, 
                                                                   scale = 1E-6, 
                                                                   suffix = "M",
                                                                   accuracy = 1), "")),
                   nudge_x = -1,
                   show.legend = FALSE) +
  geom_label_repel(aes(label = ifelse(year == 2020, scales::number(passengers, 
                                                                   scale = 1E-6, 
                                                                   suffix = "M",
                                                                   accuracy = 1), "")),
                   nudge_x = 0.1,
                   segment.color = 'transparent',
                   show.legend = FALSE) +
  annotate("text",
           x = 2020 + 0.2,
           y = 50E6,
           label = "2020 Coronavirus Pandemic",
           angle = 90
           ) +
  scale_y_continuous(labels = scales::number_format(scale = 1E-6,
                                                    suffix = " Million")) +
  scale_x_continuous(breaks = unique(busiest_us_airports$year)) +
  scale_color_manual(values = colors_airports) +
  labs(y = "Total passengers",
       title = "The COVID-19 pandemic has drastically affected passenger numbers amongst the top 5 busiest US airports.",
       subtitle = "<span style='color:#7F8D3C'>Dallas Airport</span> is the only airport to have increased passenger in 2020,") +
  theme_minimal() +
  theme(plot.subtitle = element_markdown())
