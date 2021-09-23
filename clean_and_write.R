library(tidyverse)
all_my_pkg <- as.data.frame(installed.packages()) %>%
  tibble()

non_base <- all_my_pkg %>%
  filter(Priority != "base" | is.na(Priority)) %>%
  select(-c(Enhances:MD5sum, LinkingTo:Suggests)) %>%
  droplevels()

package_source <- function(pkg){
  x <- as.character(packageDescription(pkg)$Repository)
  if (length(x)==0) {
    y <- as.character(packageDescription(pkg)$GithubRepo)
    z <- as.character(packageDescription(pkg)$GithubUsername)
    if (length(y)==0) {
      return("Other")
    } else {
      return(str_c(z, "/", y))
    }
  } else {
    return(x)
  }
}

found_pkg <- non_base %>%
  mutate(where_at = map_chr(Package, package_source),
         source = ifelse(str_detect(where_at, "/"), "GitHub", NA_character_))

janitor::tabyl(found_pkg, source)

write_csv(found_pkg, glue::glue("my-pkg-{Sys.Date()}.csv"))
