## code to prepare `j3s` dataset goes here

j3s <- tibble::tribble(
        ~value,                       ~name,
           29L,                      "John",
           91L,               "John, Jacob",
           39L, "John, Jacob, Jingleheimer",
           28L,     "Jingleheimer, Schmidt",
           12L,              "JJJ, Schmidt")

usethis::use_data(j3s, overwrite = TRUE)
