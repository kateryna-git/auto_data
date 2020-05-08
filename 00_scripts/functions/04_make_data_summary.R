
# helper functions --------------------------------------------------------


count_numeric <- function(.df) {
  .df %>% 
    select(is.numeric) %>% 
    ncol()
}

count_factor <- function(.df) {
  .df %>% 
    select(is.factor) %>% 
    ncol()
}


count_date <- function(.df) {
  .df %>% 
    select(is.Date) %>% 
    ncol()
}

count_posixct <- function(.df) {
  .df %>% 
    select(is.POSIXct) %>% 
    ncol()
}

# summary functions -------------------------------------------------------


main_summary <- function(df, name = "data") {
  summary_list <- list(
    c("Number of columns",
      "Number of Rows",
      "Numeric",
      "Factor",
      "Date",
      "POSIXct"),
    c(ncol(df), 
      nrow(df), 
      count_numeric(df), 
      count_factor(df),
      count_date(df),
      count_posixct(df)
    )) %>% 
    set_names(c("Summary", name))
  
  summary <- map_df(summary_list, cbind) 
  return(summary)
  
}


# styling -----------------------------------------------------------------


main_style <- function(df) {
  df = df %>% 
  kable("html", escape = F, caption = "Summary") %>%
    kable_styling(bootstrap_options = c("hover", "condensed", full_width = F), font_size = 13) %>%
    group_rows("Column type frequency:", 3, 4) %>% 
    add_header_above(c(" " = 1, "Data tables" = 3)) 
  return(df)
}

main_style_one_table <- function(df) {
  df = df %>% 
    kable("html", escape = F, caption = "Summary", full_width = F) %>%
    kable_styling(bootstrap_options = c("hover", "condensed", full_width = F), font_size = 13)  %>% 
     pack_rows("Variables", 3, 6)
  return(df)
}


# skim summary ------------------------------------------------------------


skim_date <- function(.skim_list) {
  dgk <- .skim_list[["Date"]] %>%
    mutate_if(is.numeric, format, digits=2, nsmall = 0) %>% 
    rename("Variable" = skim_variable,
           "Missing" = n_missing,
           "Complete" = complete_rate,
           "Unique" = n_unique)
  
  dgk%>% 
    mutate(
      Complete = color_bar("lightgrey")(Complete)
    ) %>% 
    kable("html", escape = F, align = c("l", rep("r", 6)), caption = "Date") %>%
    kable_styling(bootstrap_options = c("hover", "condensed", fixed_thead = T, full_width = F), font_size = 13) %>%
    column_spec(1, italic = T) %>% 
    add_header_above(c(" " = 1, "Missing" = 2, "Summary" = 4))
}


skim_factor <- function(.skim_list) {
  .skim_list[["factor"]] %>%
    rename("Variable" = skim_variable,
           "Missing" = n_missing,
           "Complete" = complete_rate,
           "Unique" = n_unique,
           "Top Counts" = top_counts) %>% 
    mutate(
      Complete = color_bar("lightgrey")(Complete)
    ) %>% 
    kable("html", escape = F, align = c("l", rep("r", 4), "c"), caption = "Categorocal") %>%
    kable_styling(bootstrap_options = c("hover", "condensed", fixed_thead = T, full_width = F), font_size = 13) %>%
    column_spec(1, italic = T) %>% 
    add_header_above(c(" " = 1, "Missing" = 2, "Summary" = 3)) 
  
}

skim_numeric <- function(.skim_list) {
  dgk <- .skim_list[["numeric"]] %>%
    mutate_if(is.numeric, format, digits=2,nsmall = 0) %>% 
    rename("Variable" = skim_variable,
           "Missing" = n_missing,
           "Complete" = complete_rate,
           "median" = p50,
           "Hist" = hist)
  
  dgk%>% 
    mutate(
      Complete = color_bar("lightgrey")(Complete)
    ) %>% 
    kable("html", escape = F, align = c("l", rep("r", 9), "c"), caption = "Numeric") %>%
    kable_styling(bootstrap_options = c("hover", "condensed", fixed_thead = T, full_width = F), font_size = 13) %>%
    column_spec(1, italic = T) %>% 
    # column_spec(c(3, 10), border_right = T) %>% 
    add_header_above(c(" " = 1, "Missing" = 2, "Summary" = 7, " " = 1)) %>% 
    column_spec(11, width = "3cm")
}

skim_posixct <- function(.skim_list) {
  dgk <- .skim_list[["POSIXct"]] %>%
    mutate_if(is.numeric, format, digits=2, nsmall = 0) %>% 
    rename("Variable" = skim_variable,
           "Missing" = n_missing,
           "Complete" = complete_rate,
           "Unique" = n_unique)
  
  dgk%>% 
    mutate(
      Complete = color_bar("lightgrey")(Complete)
    ) %>% 
    kable("html", escape = F, align = c("l", rep("r", 6)), caption = "POSIXct") %>%
    kable_styling(bootstrap_options = c("hover", "condensed", fixed_thead = T, full_width = F), font_size = 13) %>%
    column_spec(1, italic = T) %>% 
    add_header_above(c(" " = 1, "Missing" = 2, "Summary" = 4))
}