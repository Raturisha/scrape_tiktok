message('Loading Packages')
library(rvest)
library(tidyverse)
library(mongolite)

message('Scraping Data')
url <- "https://hypeauditor.com/top-tiktok/"
page <- read_html(url)


rank <- page %>% html_nodes(xpath = '//div[@class="row-cell rank"]') %>% html_text()
influencer <- page %>% html_nodes(xpath = '//div[@class="contributor__name"]') %>% html_text()

followers <- page %>% html_nodes(xpath = '//div[@class="row-cell subscribers"]') %>% html_text()

view <- page %>% html_nodes(xpath = '//div[@class="row-cell views-avg"]') %>% html_text()

likes <-page %>% html_nodes(xpath = '//div[@class="row-cell likes-avg"]') %>% html_text()

comments <-page %>% html_nodes(xpath = '//div[@class="row-cell comments-avg"]') %>% html_text()

shares <-page %>% html_nodes(xpath = '//div[@class="row-cell shares-avg"]') %>% html_text()

data <- data.frame(
  time_scraped = Sys.time(),
  rank = head(rank, 5),
  influencer = head(influencer, 5),
  followers = head(followers, 5),
  view = head(view, 5),
  likes = head(likes, 5),
  comments = head(comments, 5),
  shares = head(shares, 5),
  stringsAsFactors = FALSE
)

# MONGODB
message('Input Data to MongoDB Atlas')
atlas_conn <- mongo(
  collection = Sys.getenv("ATLAS_COLLECTION"),
  db         = Sys.getenv("ATLAS_DB"),
  url        = Sys.getenv("ATLAS_URL")
)

atlas_conn$insert(data)
rm(atlas_conn)
