#' Draw bigram network using morphological analysis data.
#' 
#' @param df           A dataframe including result of morphological analysis.
#' @param bigram       A result of bigram().
#' @param bigram_net   A result of bigram_net().
#' @param rand_seed    A numeric.
#' @param threshold    A numeric used as threshold for frequency of bigram.
#' @param freq         A numeric of word frequency in bigram_net.
#'                     Can be got using word_freq().
#' @param arrow_size,circle_size,text_size,
#'                     A numeric.
#' @param font_family  A string. 
#' @param arrow_col,circle_col
#'                     A string to specicy arrow and circle color 
#'                     in bigram network.
#' @param x_limits,y_limits
#'                     A Pair of numeric to specify range.
#' @param no_scale     A logical. FALSE: Not draw x and y axis.
#' @param ...          Extra arguments to internal fuctions.
#' @return  A gg object of bigram network plot.
#' 
#' @export
draw_bigram_network <- function(df, ...){
  bigram_net <- 
    bigram(df, ...) %>%
    bigram_net(...)
  freq <- word_freq(df, bigram_net)
  bigram_network_plot(bigram_net, freq, ...)
}

#' @rdname draw_bigram_network
#' @export
bigram <- function(df, text_id = "text_id", ...){  # `...' will be omitted
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
    dplyr::ungroup() %>%
    na.omit() %>%
    dplyr::group_by(.data[[word_1]], .data[[word_2]]) %>%
    dplyr::tally(name = {{freq}}) %>%
    dplyr::ungroup() %>%
    dplyr::arrange(dplyr::desc(.data[[freq]]))
}

#' @rdname draw_bigram_network
#' @export
bigram_net <- function(bigram, rand_seed = 12, threshold = 100, ...){  # `...' will be omitted
  set.seed(rand_seed)
  freq_thresh <- dplyr::slice(bigram, threshold)[["freq"]]
  bigram %>%
    dplyr::filter(freq > freq_thresh) %>%
    igraph::graph_from_data_frame()
}

#' @rdname draw_bigram_network
#' @export
word_freq <- function(df, bigram_net){
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

#' @rdname draw_bigram_network
#' @export
bigram_network_plot <- function(bigram_net, ...,  # `...' will be omitted
                                freq,
                                arrow_size  = 5,
                                circle_size = 5,
                                text_size   = 5,
                                font_family = "",
                                arrow_col   = "darkgreen",
                                circle_col  = "skyblue",
                                x_limits    = NULL,
                                y_limits    = NULL,
                                no_scale    = TRUE){
  # settings
  cap_size    <- ggraph::circle(arrow_size, 'mm')
  arrow_size  <- grid::unit(arrow_size, 'mm')
  breaks      <- if(no_scale) NULL else ggplot2::waiver()

  bigram_net_plot <- 
    bigram_net %>%
    # the most understandable layout
    ggraph::ggraph(layout = "fr") + 
    ggraph::geom_edge_link(color  = arrow_col, 
                           arrow  = grid::arrow(length = arrow_size), 
                           start_cap = cap_size, 
                           end_cap   = cap_size) +
    ggraph::geom_node_point(color = circle_col, 
                            # default (5) means 5 * 0.2 = 1
                            size  = freq * circle_size * 0.2) +  
    ggraph::geom_node_text(ggplot2::aes(label = name), 
                           vjust  = 1, 
                           hjust  = 1, 
                           size   = text_size, 
                           family = font_family) +
    ggplot2::theme_bw() + 
    ggplot2::theme(axis.title.x = ggplot2::element_blank(),
                   axis.title.y = ggplot2::element_blank()) + 
    ggplot2::scale_x_continuous(limits = x_limits, breaks = breaks) + 
    ggplot2::scale_y_continuous(limits = y_limits, breaks = breaks)

  return(bigram_net_plot)
}
