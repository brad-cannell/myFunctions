#' Add Attributes to Columns
#'
#' Add arbitrary attributes to columns (e.g., description, source, column type).
#' These attributes can later be accessed to fill in the column attributes table.
#' Note: Column type is the type I say it is: categorical or numeric, Data type
#' is what the computer says it is.
#'
#' @param df Data frame of interest
#' @param .x Column of interest in df
#' @param ... Arbitrary list of attributes (i.e., attribute = "value")
#'
#' @return Data frame
#' @export
codebook_add_col_attributes <- function(df, .x, ...) {

  # ===========================================================================
  # Variable management
  # ===========================================================================
  .x <- rlang::enquo(.x) %>% rlang::quo_name()
  args <- list(...)
  arg_names <- names(args)

  # ===========================================================================
  # Checks
  # ===========================================================================
  # Check for typos. Let the user know if they are adding an attribute
  # that doesn't already exist for at least one variable in the dataset.
  attr_list <- purrr::map(df, function(x) {
    attrs <- attributes(x)
    attrs <- names(attrs)
    attrs
  }) %>%
    unlist() %>%
    unique()

  new_args <- dplyr::setdiff(arg_names, attr_list)
  if (length(new_args) > 1) {
    new_args <- paste(new_args, collapse = ", ")
  }

  if (length(new_args) != 0) {
    message("The following attribute(s) are being added to a variable in ",
            "the data frame for the first time: ", new_args, ". ",
            "Check for typos.")
  }


  # ===========================================================================
  # Add attributes
  # ===========================================================================
  for (i in seq_along(args)) {
    attr(df[[.x]], arg_names[i]) <- args[[i]]
  }

  # ===========================================================================
  # Return data frame
  # ===========================================================================
  df
}
