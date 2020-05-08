# 1.0 Load libraries and source files ----


library(rvest)     # HTML Hacking & Web Scraping
library(tidyverse) # Data Manipulation
library(xopen)     # Opens URL in Browser
library(lubridate)
library(janitor)

source("00_scripts/functions/01_scrape_helpers.R")


# 1.0 Scrape ----


# 1.1 autoGIDAS ----

url_gidas <- 'https://en.autogidas.lt/skelbimai/automobiliai/?f_41=2003&f_42=2009&f_3%5B2%5D=He%C4%8Dbekas&f_3%5B3%5D=Universalas&f_3%5B5%5D=Vienat%C5%ABris&f_2%5B2%5D=Benzinas&f_2%5B3%5D=Benzinas%2FDujos&f_10=Mechanin%C4%97&s=1013965957&f_1%5B0%5D=Skoda&f_model_14%5B0%5D=Fabia&f_1%5B1%5D=Mazda&f_model_14%5B1%5D=3&f_1%5B2%5D=Nissan&f_model_14%5B2%5D=Primera&f_1%5B3%5D=Nissan&f_model_14%5B3%5D=Micra'

#Filter HTML to Isolate Nodes
page_links_gidas <- read_html(url_gidas) %>%
  
  #isolate lincs
  html_nodes(".item-link") %>% 
  html_attr("href") %>% 
  
  #complete lincs
  map_chr(., ~ str_glue("https://en.autogidas.lt/", ., sep = ""))


data_gidas <- map_df(page_links_gidas, scrape_page_gidas) %>%  cbind(page_links_gidas)

 data_gidas <- data_gidas %>% 
   mutate(date = lubridate::as_datetime(Sys.time()))

 # fs::dir_create("00_data/raw/plius")

data_gidas %>%
  saveRDS(
    str_glue(
      "00_data/raw/gidas/",
      "{as_date(Sys.time()) %>% str_replace_all('-', '_')}data_gidas_raw.rds"
    )
  )

# 1.2 autoPLIUS--------

baseUrl_url_01 <- 'https://en.autoplius.lt/ads/used-cars?category_id=2&fk_place_countries_id=1&fuel_id=30&gearbox_id=37&make_date_from=2003&make_date_to=2009&make_id_list=45&slist=1079819857&make_id%5B45%5D=290&make_id%5B48%5D=336&make_id%5B68%5D=715_732_738'

pages <- c("",
              "&page_nr=2", 
              "&page_nr=3",
              "&page_nr=4",
              "&page_nr=5")

urls_autopl <- map_chr(pages, ~ paste0(baseUrl_url_01, .))

car_links_autopl <- map(urls_autopl, function(x) {
  read_html(x) %>%
    #isolate lincs
    html_nodes(".announcement-item") %>% 
    html_attr("href")
}) %>% 
  unlist()


data_autoplius <- map_df(car_links_autopl, scrape_autopl) %>%  cbind(car_links_autopl)

 data_autoplius <- data_autoplius %>%
   mutate(date = lubridate::as_datetime(Sys.time()))

#save raw data

data_autoplius %>%
  saveRDS(
    str_glue(
      "00_data/raw/plius/",
      "{as_date(Sys.time()) %>% str_replace_all('-', '_')}data_plius_raw.rds"
    )
  )

