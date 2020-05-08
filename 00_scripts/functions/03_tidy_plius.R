split_cols_plius <- function(df) {
  
  df <- df %>% 
    
    #separate column -engine
    extract(engine, into = c("engine_volume_cm", "engine_force_hp", "engine_force_kw"), convert = TRUE,
            regex = "(?:(\\d+) cm³,? ?)?(?:(\\d+) HP \\((\\d+))?") %>% 
    
    #separate column -name
    extract(name, into = c("advert_id", "make", "model", "engine_volume_l", "body_type"), convert = TRUE,
            regex = "ID\\: (A\\d+)\\\n     ([[:alpha:]]+) ([[:alnum:]]+),(?: (\\d+\\.\\d+) l.,)? ([[:alpha:]]+(?:[[:blank:]]\\/[[:blank:]][[:alpha:]]+)?)") %>% 
    
    separate(location, into = c("city", "country"), sep = ",") %>% 
    
    extract(last_updated, into = "last_updated",
            regex = "Updated (.*[^ago])(?: ago)?$")
  
  return(df)
}

make_clean_cols_plius <- function(df) {
  
  df <- df %>% 
    
    #replace -last_updated with date of last update
    mutate(last_updated =  case_when(
      str_detect(last_updated, "\\d+\\sdays") ~ as.character(as_date(date) - parse_number(last_updated)),
      str_detect(last_updated, "\\d+\\sh|\\d+\\smin") ~ as.character(as_date(date)),
      str_detect(last_updated, "\\d{4}-\\d{2}-\\d{2}") ~ last_updated,
      TRUE ~ last_updated
    )) %>% 
    
    mutate(driven_wheels = case_when(
      driven_wheels == "Front wheel drive (FWD)" ~ "front",
      driven_wheels == "Front wheel drive (RWD)" ~ "rear",
      driven_wheels == "All wheel (4х4)" ~ "all",
      TRUE ~ driven_wheels)) %>% 
    
    mutate(
      steering_wheel = if_else(fuel_type == "Left hand drive (LHD)", "left", "right")
    ) 
  
  return(df)
}

select_rename_relocate_cols_plius <- function(df) {
  
  df <- df %>% 
    
    select(
      -engine_volume_cm,
      -co_u_2082_emisija_g_km, 
      -vin_number,
      -wheel_size,
      -kerb_weight_kg, 
      -euro_standard) %>% 
    
    rename(
      fuel_cons_urban = "urban",
      fuel_cons_overland = "extra_urban",
      fuel_cons_combined = "combined",
      year = "date_of_manufacture",
      price = "export",
      link = "car_links_autopl", 
      visitors = "bookmarked"
    ) %>% 
    
    relocate(
      advert_id,
      last_updated,
      visitors,
      price,
      city, 
      country,
      make,
      model,
      body_type, 
      year,
      mileage,
      damage,
      fuel_cons_urban,
      fuel_cons_overland, 
      fuel_cons_combined
    ) 
  return(df)
}