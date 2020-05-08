split_cols_gidas <- function(df) {
  
  df <- df %>% 
  extract(year, into = c("year", "car_age"), convert = TRUE,
          regex = "(\\d{4})\\/(\\d+)") %>% 
    
    # separate into 3 cols with RegEx
    extract(engine, into = c("engine_volume_l", "engine_force_kw", "engine_force_ag"), convert = TRUE,
            regex = "(\\d\\.\\d+) l.(?: (\\d+) kW \\((\\d+))?") %>% 
    
    separate(location, into = c("city", "country"), sep = ",")
  
  return(df)
}
  
make_clean_cols_gidas <- function(df) {
    
    df <- df %>% 
    
    mutate(availability = if_else(is.na(availability), "sold", "for sale")) %>% 
    mutate(gearbox = if_else(gearbox == "Mechanical", "Manual", "Automatic")) %>% 
    mutate(fuel_type = if_else(fuel_type == "Gasoline", "Petrol", "Petrol/Gas")) %>% 
    mutate(driven_wheels = case_when(
      driven_wheels == "Front wheel drive" ~ "front",
      driven_wheels == "Rear wheel drive" ~ "rear",
      driven_wheels == "All wheel drive" ~ "all",
      TRUE ~ driven_wheels)) %>% 
    
    
    #replace -updated with date of last update
    mutate(last_updated =  case_when(
      str_detect(updated, "\\d+\\sd\\.") ~ as.character(as_date(date) - parse_number(updated)),
      str_detect(updated, "\\d+\\sh\\.") ~ as.character(as_date(date)),
      str_detect(updated, "\\d+\\smin\\.") ~ as.character(as_date(date)),
      str_detect(updated, "\\d+\\sw\\.") ~ as.character(as_date(date) - parse_number(updated)*7),
      str_detect(updated, "\\d+\\smon\\.") ~ as.character(as_date(date) - parse_number(updated)*30),
      TRUE ~ updated
    )) 
  
    return(df)
  }
  
  
select_rename_relocate_cols_gidas <- function(df) {
  
  df <- df %>% 
    
  select(-vin_code, 
         -seller, 
         -contact_phone,
         -weight_kg, 
         -co2_emission_g_km, 
         -export_price, 
         -updated, 
         -number_of_cylinders,
         -steering_column, 
         -doors,
         -euro_standard)  %>% 
    
    rename(
      fuel_cons_urban = "urban",
      fuel_cons_overland = "overland",
      fuel_cons_combined = "overall",
      link = "page_links_gidas"
    ) %>% 
    
    
    relocate(
      advert_id,
      availability,
      inserted_on,
      valid_till,
      last_updated,
      visitors, 
      price,
      city, 
      country,
      make,
      model,
      body_type, 
      year,
      car_age,
      mileage,
      damage, 
      fuel_cons_urban,
      fuel_cons_overland, 
      fuel_cons_combined,
      engine_volume_l,
      engine_force_kw,
      engine_force_ag
    ) 
  return(df)
}

  
parse_cols_gidas <- function(df) {
  
  df <- df %>% 
    
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
  
  return(df)
}
