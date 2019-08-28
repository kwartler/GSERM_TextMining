url <- 'https://www.mondovino.ch/suche/'

allWines <- c('P1013885003' ,'P1001818014')

allUrls <- paste0(url, allWines)

wineNames <- vector()
for(i in 1:length(allUrls)){
  print(paste('working on ',i))
  x <- read_html(allUrls[i])
  y <- x %>% html_nodes('.mod_product_detail__title') %>%
    html_text()
  wineNames[i] <- y
}
