bigram <- function(df, text_id = "text_id"){
  word_1 <- "word_1"
  word_2 <- "word_2"
  term <- "term"
  freq <- "freq"
  df %>%
    dplyr::group_by(.data[[text_id]]) %>%
  # according to arrow direction in ggplot: "word_2-word_1"
    dplyr::transmute(text_id, 
                     {{word_2}} := term, 
                     {{word_1}} := dplyr::lag(.data[[term]])) %>%
  #                      bigram = stringr::str_c(.data[[word_2]], " - ",.data[[ word_1]])) %>%
    dplyr::ungroup() %>%
    na.omit() %>%
    dplyr::group_by(.data[[word_1]], .data[[word_2]]) %>%
    dplyr::tally(name = {{freq}}) %>%
    dplyr::ungroup() %>%
    dplyr::arrange(dplyr::desc(.data[[freq]]))
}

  # bigram network
bigram_net <- function(bigram, rand_seed = 12, threshold = 100){
  set.seed(rand_seed)
  bigram %T>%
    { freq_thresh <<- dplyr::slice(., threshold)$freq } %>%
    dplyr::filter(freq > freq_thresh) %>%
    igraph::graph_from_data_frame()
}

freq_ratio <- function(df, bigram_net){
  freq <- "freq"
  term <- 
    bigram_net %>%
    igraph::V() %>%
    attr("name")
  df <- 
    df %>%
    dplyr::group_by(.data[["term"]]) %>%
    dplyr::tally(name = freq )
  dplyr::left_join(tibble::tibble("term" := term), df) %>%
    `[[`(freq) %>%
    log() %>%
    round(0) * 2
}


bigram_network <- function(bigram_net, freq){
  arrow_size  <- unit(input$arrow_size, 'mm')
  cap_size    <- circle(input$arrow_size, 'mm')
  circle_size <- input$circle_size
  text_size   <- input$text_size
  font_family <- if(exists("input$font")) input$font else ""
  arrow_col  <- input$arrow_col
  ccircle_col <- input$circle_col

  bigram_net %>%
    ggraph(layout = "fr") +        # the most understandable layout
    geom_edge_link(color  = arrow_col,  arrow = arrow(length = arrow_size), start_cap = cap_size, end_cap = ccap_size) +
    geom_node_point(color = circle_col, size = freq_ratio() * circle_size * 0.2) +  # default (5) means 5 * 0.2 = 1
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
