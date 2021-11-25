library(tidyverse)
library(gghighlight)
library(ggtext)

bechdel_pass_rate_over_time <- bechdel %>%
  filter(year >= 1984) %>% 
  select(year, binary) %>% 
  count(year, binary) %>% 
  group_by(year) %>% 
  mutate(percent_n = n / sum(n))

# ==== Basic chart ====

bechdel_pass_rate_over_time %>% 
  ggplot(aes(x = year,
             y = percent_n,
             color = binary)) +
  geom_line()

# ==== using a different geom and {ggtext}

bechdel_pass_rate_over_time %>% 
  ggplot(aes(x = year,
             y = percent_n,
             fill = binary)) +
  geom_area(position = "stack") +
  scale_fill_manual(values = c("FAIL" = "#A61C1B", "PASS" = "#6689F0")) +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(title = "Over time the percentage of movies <span style='color:#6689F0'>passing the Bechdel test</span> is increasing",
       y = "Percentage of movies released",
       subtitle = "Data from fivethiryeight::bechdel") +
  theme(plot.title = element_markdown())

# ... with a little bit more fine tuning

bechdel_pass_rate_over_time %>% 
  ggplot(aes(x = year,
             # ymax = percent_n,
             # ymin = 0,
             y = percent_n,
             fill = binary)) +
  geom_area(position = "stack") +
  scale_fill_manual(values = c("FAIL" = "#A61C1B", "PASS" = "#6689F0")) +
  scale_y_continuous(labels = scales::percent_format(),
                     expand = c(0, 0)) +
  scale_x_continuous(expand = c(0, 0)) +
  labs(title = "Over time the percentage of movies <span style='color:#6689F0'>passing the Bechdel test</span> is increasing",
       y = "Percentage of movies released",
       subtitle = "Data from fivethiryeight::bechdel") +
  theme(plot.title = element_markdown())
  
  

