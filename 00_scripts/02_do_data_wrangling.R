# 1.0 Load libraries and source files ----


library(tidyverse) # Data Manipulation
library(lubridate)
library(janitor)
library(here)
library(dplyr)
# library(devtools)
# remotes::install_github("r-lib/rlang")
# remotes::install_github("tidyverse/dplyr")

source(here('00_scripts', 'functions', '02_tidy_gidas.R'))
source(here('00_scripts', 'functions', '03_tidy_plius.R'))

# 2.0 Tidy GIDAS ----
 # 2.1  Wrangle

file_list <- list.files(here('00_data', 'raw', 'gidas'), pattern = "*\\.rds") %>% 
  paste0(here('00_data', 'raw', 'gidas'), "/", .)

#return dataframe by row binding
gidas_data_raw <- map_df(file_list, read_rds)


  ##VARIABLES
# price - Euro
# engine_volume -Liters
# engine_force - kW
# engine_force - Ag
#milage <- km

tidy_gidas <- gidas_data_raw %>% 
  as_tibble(.name_repair = janitor::make_clean_names) %>% 

  #separate cols  
  split_cols_gidas()  %>% 

  #mutate and tidy cols and data
  make_clean_cols_gidas() %>% 

  #leave columns
  select_rename_relocate_cols_gidas() %>%
  
  # mutate_if(is.character, as.factor) 
  # mutate(across(is.character, as.factor)) %>% 
  
  #parse columns as numbers
  map_at(
    c(
      "visitors",
      "mileage",
      "number_of_gears",
      "number_of_seats",
      "number_of_cylinders",
      "fuel_cons_urban", 
      "fuel_cons_overland", 
      "fuel_cons_combined"),
    parse_number) %>% 
  
  #parse columns as factor
  map_at(
    c(
      "advert_id",
      "availability",
      "make",
      "model",
      "fuel_type",
      "body_type",
      "gearbox",
      "driven_wheels",
      "damage",
      "color", 
      "wheels",
      "city", 
      "country",
      "first_registration_country"),
    parse_factor
  ) %>% 
  
  #parse columns as date
  map_at(
    c("inserted_on",
      "valid_till",
      "last_updated"),
    parse_date
  ) %>%
  as_tibble()

tidy_gidas$price <- parse_number(tidy_gidas$price, locale = locale(grouping_mark = " "))  
tidy_gidas$ts_to <- parse_date(tidy_gidas$ts_to, format = "%Y-%m") 

# 2.2  save gidas ----

tidy_gidas %>%
  saveRDS(
    str_glue(
      here('00_data', 'tidy'), "/",
      # "/{as_date(Sys.time()) %>% str_replace_all('-', '_')}
     "data_gidas_tidy.rds"
    )
  )

# 3.0 Tidy autoPLIUS ----

 # 3.1  plius

file_list_plius <- list.files(here('00_data', 'raw', 'plius'), pattern = "*\\.rds") %>% 
  paste0(here('00_data', 'raw', 'plius'), "/", .)

#return dataframe by row binding
plius_data_raw <- map_df(file_list_plius, read_rds)
  
  ##VARIABLES
  # price - Euro
  # engine_volume -cm
  # engine_force - Hp
  # engine_force - Kw
  #milage <- km

tidy_plius <- plius_data_raw %>% 
  
  #make tidy names
  as_tibble(.name_repair = janitor::make_clean_names) %>% 
  
  split_cols_plius() %>% 
  
  make_clean_cols_plius() %>% 

  select_rename_relocate_cols_plius() %>% 
    
  #parse columns as numbers ?somehow doesn't work in a function
  map_at(
    c(
      "visitors",
      "mileage",
      "number_of_seats",
      "number_of_cylinders",
      "fuel_cons_urban", 
      "fuel_cons_overland", 
      "fuel_cons_combined", 
      "year", 
      "visitors"),
    parse_number) %>% 
  
  #parse columns as factor
  map_at(
    c(
      "advert_id",
      "availability",
      "make",
      "model",
      "fuel_type",
      "body_type",
      "gearbox",
      "driven_wheels",
      "damage",
      "color", 
      "wheels",
      "city", 
      "country",
      "first_registration_country", 
      "climate_control"),
    parse_factor
  ) %>% 
  
  #parse columns as date
  map_at("last_updated", parse_date) %>%
  
  as_tibble()
  
  #function uses system facilities to convert a character vector between encodings:
  # the 'i' stands for 'internationalization'. mark : logical, for expert use.
  tidy_plius$city <- tidy_plius$city %>%
    iconv(from = 'UTF-8', to = 'ASCII//TRANSLIT')
  
  tidy_plius$price <- parse_number(tidy_plius$price, locale = locale(grouping_mark = " ")) 
  
  # 3.2  save plius ----

  
  tidy_plius %>%
    saveRDS(
      str_glue(
        here('00_data', 'tidy'), "/",
        "data_plius_tidy.rds"
      )
    )

  

# notes -------------------------------------------------------------------

  
  
  # %>%
  #   rename_with(~ paste( ., "1", sep = "_"), 1:8) %>% 
  
  

  
  
  
  #check if date replacement correct  
  # tidy_plius %>% 
  #   select(last_updated, date, last_updated2) %>% 
  #   summarise(last_updated = last_updated, last_updated2 = as_date(last_updated2), period = as_date(date) - last_updated2) %>% 
  #   sample_n(20)
  
  
  
  #trim whitespaces
   # mutate_if(is.character, str_trim) %>% 

  



# reduce?

  # tidy_gidas %>% get_dupes(advert_id_a)

  
# Drops columns from a data.frame that contain only 
# a single constant value (with an na.rm option to control
# whether NAs should be considered as different values from the constant).
# remove_constant() 
  
  
  
# summarise(across(starts_with("Sepal")), list(mean, sd), .names = "{col}.fn{fn}")
# 
 # across(c(sex, gender, homeworld), list(n_distinct, n))
# 
  
  
  
  # summarise(across(c(price, year, engine_volume), list(n_distinct, sd), , .names = "{col}.fn{fn}")) %>%