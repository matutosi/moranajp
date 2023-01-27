#' Draw bigram network using morphological analysis data.
#' 
#' @param df           A dataframe including result of morphological analysis.
#' @param sentence_id  A dstring to specify sentence.
#' @param bigram       A result of bigram().
#' @param bigram_net   A result of bigram_net().
#' @param rand_seed    A numeric.
#' @param threshold    A numeric used as threshold for frequency of bigram.
#' @param term,term_depend
#'                     A string of terms (words) or dependnt terms column 
#'                     to use bigram.
#' @param depend       A logical to 
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
#' @return  A list including df (input), bigram, freq (frequency) and 
#'          gg (ggplot2 object of bigram network plot).
#' @examples
#' library(tidyverse)
#' data(synonym)
#' synonym <- unescape_utf(synonym)
#' 
#' data(neko_mecab)
#' neko_mecab <- 
#'   unescape_utf() %>%
#'   clean_mecab_local(use_common_data = TRUE, synonym_df = synonym) %>%
#'   print()
#' 
#' bigram_neko <- 
#'   neko_mecab %>%
#'   draw_bigram_network()
#' 
#' data(neko_ginza)
#' neko_ginza <- 
#'   neko_ginza %>%
#'   unescape_utf() %>%
#'   clean_ginza_local(use_common_data = TRUE, synonym_df = synonym) %>%
#'   print()
#' 
#' bigram_neko_ginza_dep <- 
#'   neko_ginza %>%
#'   bigram(term = "lemma", depend = TRUE)
#' 
#' bigram_neko_ginza <- 
#'  neko_ginza %>%
#'    bigram(term = "lemma")
#' 
#' add_stop_words <- 
#'   c("\\u3042\\u308b", "\\u3059\\u308b", "\\u3066\\u308b", 
#'     "\\u3044\\u308b","\\u306e", "\\u306a\\u308b", "\\u304a\\u308b", 
#'     "\\u3093", "\\u308c\\u308b", "*") %>% 
#'    unescape_utf()
#' 
#' data(review_chamame)
#' bigram_review <- 
#'   review_chamame %>%
#'   unescape_utf() %>%
#'   clean_chamame(add_stop_words = add_stop_words) %>%
#'   draw_bigram_network()
#' 
#' data(review_mecab)
#' review_mecab %>%
#'   unescape_utf() %>%
#'   clean_mecab_local() %>%
#'   draw_bigram_network()
#' 
#' data(review_ginza)
#' review_ginza %>%
#'   unescape_utf() %>%
#'   clean_ginza_local() %>%
#'   draw_bigram_network(term = "lemma")
#' 
#' review_ginza %>%
#'   unescape_utf() %>%
#'   clean_ginza_local() %>%
#'   draw_bigram_network(term = "lemma", depend = TRUE)
#' 
#' @export
draw_bigram_network <- function(df, ...){
  big <- bigram(df, ...)
  big_net <- bigram_net(big, ...)
  freq <- word_freq(df, big_net, ...)
  gg <- bigram_network_plot(big_net, freq = freq, ...)
  print(gg)
  res <- list(df = df, bigram = big, freq = freq, gg = gg)
  return(res)
}

#' @rdname draw_bigram_network
#' @export
bigram <- function(df, sentence_id = "sentence_id", 
                   term = "term", depend = FALSE, term_depend = NULL, 
                   ...){ # `...' will be omitted
  word_1 <- "word_1"
  word_2 <- "word_2"
  freq <- "freq"
  bigram_dep <- 
    if(depend) bigram_depend(df, sentence_id, term, term_depend) else NULL
  bigram <- 
    df %>%
    dplyr::group_by(.data[[sentence_id]]) %>%
  # according to arrow direction in ggplot: "word_2-word_1"
    dplyr::transmute(.data[[sentence_id]], 
                     {{word_2}} := .data[[term]], 
                     {{word_1}} := dplyr::lag(.data[[term]])) %>%
    dplyr::ungroup() %>%
    stats::na.omit()
  bigram %>%
    dplyr::bind_rows(bigram_dep) %>%
    dplyr::filter(.data[[word_1]] != "EOS") %>%
    dplyr::filter(.data[[word_2]] != "EOS") %>%
    dplyr::filter(.data[[word_1]] != "*") %>%
    dplyr::filter(.data[[word_2]] != "*") %>%
    dplyr::distinct() %>%
    dplyr::group_by(.data[[word_1]], .data[[word_2]]) %>%
    dplyr::tally(name = {{freq}}) %>%
    dplyr::ungroup() %>%
    dplyr::arrange(dplyr::desc(.data[[freq]]))
}

#' @rdname draw_bigram_network
#' @export
bigram_depend <- function(df, sentence_id = "sentence_id",
                          term = "term", term_depend = NULL){
  if(is.null(term_depend)) term_depend <- stringr::str_c(term, "_dep")
  bigram_dep <- 
    df %>%
    dplyr::transmute(.data[[sentence_id]], 
      "word_1" := .data[[term]], "word_2" := .data[[term_depend]])
  return(bigram_dep)
}

#' @rdname draw_bigram_network
#' @export
bigram_net <- function(bigram, rand_seed = 12, threshold = 100, ...){  # `...' will be omitted
  set.seed(rand_seed)
  freq_thresh <- dplyr::slice(bigram, threshold)[["freq"]]
  bigram %>%
    dplyr::filter(.data[["freq"]] > freq_thresh) %>%
    igraph::graph_from_data_frame()
}

#' @rdname draw_bigram_network
#' @export
word_freq <- function(df, bigram_net, term = "term", ...){
  freq <- "freq"
  name <- 
    bigram_net %>%
    igraph::V() %>%
    attr("name")
  df <- 
    df %>%
    dplyr::group_by(.data[[term]]) %>%
    dplyr::tally(name = freq)
  dplyr::left_join(tibble::tibble({{term}} := name), df) %>%
    `[[`(freq) %>%
    log() %>%
    round(0) * 2
}

#' @rdname draw_bigram_network
#' @export
bigram_network_plot <- function(bigram_net, freq,
                                ...,  # `...' will be omitted
                                arrow_size  = 5,
                                circle_size = 5,
                                text_size   = 5,
                                font_family = "",
                                arrow_col   = "darkgreen",
                                circle_col  = "skyblue",
                                x_limits    = NULL,
                                y_limits    = NULL,
                                no_scale    = FALSE){
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
    ggraph::geom_node_text(ggplot2::aes(label = .data[["name"]]), 
                           vjust  = 1, 
                           hjust  = 1, 
                           size   = text_size, 
                           family = font_family) +
    ggplot2::theme_bw(base_family = font_family) + 
    ggplot2::theme(axis.title.x = ggplot2::element_blank(),
                   axis.title.y = ggplot2::element_blank()) + 
    ggplot2::scale_x_continuous(limits = x_limits, breaks = breaks) + 
    ggplot2::scale_y_continuous(limits = y_limits, breaks = breaks)

  return(bigram_net_plot)
}
