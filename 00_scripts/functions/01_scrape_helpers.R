helper_scrape_nodes <- function(.link, .nod) {
  text <- .link %>% 
    read_html() %>%
    html_nodes(.nod) %>% 
    html_text() %>% 
    str_trim()
  
  return(text)
}

scrape_page_gidas <- function(link) {
  
  # parameters
  param_names <- helper_scrape_nodes(link, ".params-block .param .left")
  
  params <- helper_scrape_nodes(link, ".params-block .param .right")
  
  availability <- link %>%
    read_html() %>%
    html_nodes(".content-left > div:nth-child(2) > link") %>%
    html_attr("href") %>%
    str_trunc(width = 7, side = c("left"), ellipsis = "")
  
  badge <- helper_scrape_nodes(link, ".sold-badge")
  
  second_param_names <- helper_scrape_nodes(link, ".times-item-left")
  
  second_params <- helper_scrape_nodes(link, ".times-item-right")
  
  visitors <- helper_scrape_nodes(link, ".top-info.no-print > strong")
  
  location <- helper_scrape_nodes(link, ".seller-ico.seller-btn.seller-location")
  
  second_params_df <- cbind(second_param_names, second_params) %>%
    as_tibble() %>%
    pivot_wider(names_from = "second_param_names", values_from = "second_params")
  
  result_params <- cbind(param_names, params, availability, badge, visitors, location) %>%
    as_tibble() %>%
    pivot_wider(names_from = "param_names", values_from = "params") %>%
    cbind(second_params_df)
  
  return(result_params)
}


scrape_autopl <- function(link) {
  
  price <-  helper_scrape_nodes(link, ".price")
  
  parameters1 <-  link %>% 
    helper_scrape_nodes(".parameter-label")
  
  parameters2 <-  link %>% 
    helper_scrape_nodes(".parameter-value")
  
  location <-  link %>% 
    helper_scrape_nodes(".seller-contact-location")
  
  # add_id <-  link %>% 
  #   helper_scrape_nodes(".announcement-id")
  
  name <- link %>% 
    helper_scrape_nodes(".announcement-controls-heading")
  
  bookmarked <- link %>% 
    helper_scrape_nodes(".content-container > div:nth-child(5) > div > span:nth-child(1) > b")
  
  last_updated <- link %>% 
    helper_scrape_nodes(".content-container > div:nth-child(5) > div > span:nth-child(2)")
  
  result_params <- cbind(parameters1, parameters2, location, name, bookmarked, last_updated) %>%
    as_tibble() %>%
    pivot_wider(names_from = "parameters1", values_from = "parameters2") 
  
  return(result_params)
  
}