bigram <- function(df, text_id = "text_id"){
  df %>%
    dplyr::group_by(.data[[text_id]]) %>%
  # according to arrow direction in ggplot: "word_2-word_1"
    dplyr::transmute(text_id, 
                     word_2 = term, 
                     word_1 = dplyr::lag(term), 
                     bigram = stringr::str_c(word_2, " - ", word_1)) %>%
    dplyr::ungroup() %>%
    na.omit() %>%
    dplyr::group_by(.data[[word_1]], .data[[word_2]]) %>%
    dplyr::summarise(freq = dplyr::n()) %>%
    dplyr::ungroup() %>%
    dplyr::arrange(dplyr::desc(.data[[freq]]))
}


freq_ratio <- function(){
  term <- 
    bigram_net() %>%
    igraph::V() %>%
    .$name
  data_in %>%
    dplyr::group_by(term) %>%
    dplyr::tally() %>%
    dplyr::left_join(tibble::tibble(term = term), .) %>%
    .$n %>%
    log() %>%
    round(0) * 2
}

  # bigram network
bigram_net <- function(){
  set.seed(input$rand_seed)
  threshold <- input$threshold
  bigram() %T>%
    { freq_thresh <<- dplyr::slice(., threshold)$freq } %>%
    dplyr::filter(freq > freq_thresh) %>%
    graph_from_data_frame()
}

bigram_network_raw <- function(){
  req(bigram_net())

  arrow_size  <- unit(input$arrow_size, 'mm')
  circle_size <- input$circle_size
  text_size   <- input$text_size
  font_family <- if(exists("input$font")) input$font else ""
  bigram_net() %>%
    ggraph(layout = "fr") +        # the most understandable layout
    geom_edge_link(color  = input$arrow_col,  arrow = arrow(length = arrow_size), start_cap = circle(input$arrow_size, 'mm'), end_cap = circle(input$arrow_size, 'mm')) +
    geom_node_point(color = input$circle_col, size = freq_ratio() * circle_size * 0.2) +  # default (5) means 5 * 0.2 = 1
    geom_node_text(aes(label = name), vjust = 1, hjust = 1, size = text_size, family = font_family) +
    ggplot2::theme_bw() + 
    ggplot2::theme(axis.title.x = element_blank(),
                   axis.title.y = element_blank())
}


bigram_network_detail <- function(){
  bigram_network_raw() + 
    scale_x_continuous(limits = input$detail_x) + 
    scale_y_continuous(limits = input$detail_y)
}

bigram_network_detail_noscale <- function(){
  bigram_network_raw() + 
    scale_x_continuous(breaks = NULL, limits = input$detail_x) + 
    scale_y_continuous(breaks = NULL, limits = input$detail_y)
}

bigram_network_raw_noscale <- function(){
  bigram_network_raw() +
    scale_x_continuous(breaks = NULL) + 
    scale_y_continuous(breaks = NULL)
}
