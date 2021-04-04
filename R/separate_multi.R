#' separate_multi
#'
#' @param data data.frame or tibble
#' @param col column to be separated
#' @param pattern regular expression pattern
#' @param into_prefix prefix for new columns
#'
#' @export separate_multi

separate_multi <- function(data, col, pattern = "[^[:alnum:]]+", into_prefix){
  # use regex for pattern, or whatever is provided
  in_pattern <- pattern
  # convert data to tibble
  in_data <- tibble::as_tibble(data)
  # convert col to character vector
  in_col <- as.character(col)
  # split columns into character matrix
  out_cols <- stringr::str_split_fixed(in_data[[in_col]],
                                       pattern = in_pattern,
                                       n = Inf)
  # replace NAs in matrix
  out_cols[which(out_cols == "")] <- NA
  # get number of cols
  m <- dim(out_cols)[2]
  # assign column names
  colnames(out_cols) <- paste(into_prefix, 1:m, sep = "_")
  # convert to tibble
  out_cols <- tibble::as_tibble(out_cols)
  # bind cols together
  out_tibble <- dplyr::bind_cols(in_data, out_cols)
  # return the out_tibble
  return(out_tibble)
}
