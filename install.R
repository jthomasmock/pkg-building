# install.packages(c("tidyverse", "glue"))
library(tidyverse)

old_pkg <- readr::read_csv(glue::glue("my-pkg-{Sys.Date()}.csv"))

my_pkg <- as.data.frame(installed.packages()) %>%
  tibble() %>%
  filter(Priority != "Base"|is.na(Priority)) %>%
  select(-c(Enhances:MD5sum, LinkingTo:Suggests))

pkg_diff <- anti_join(old_pkg , my_pkg, by = "Package") %>%
  droplevels()

pkg_diff %>%
  filter(where_at == "CRAN") %>%
  pull(Package) %>%
  as.character()

old_pkg |>
  dplyr::filter(where_at == "CRAN") |>
  dplyr::pull(Package) |>
  as.character() |>
  install.packages()

old_pkg %>%
  filter(str_detect(source, "GitHub")) %>%
  select(Package, Version, NeedsCompilation, where_at)
