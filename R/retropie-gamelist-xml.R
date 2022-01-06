library(xml2)
library(tidyverse)

# For any element of a list, if that element is NULL as it isn't present
# replace with an NA
list_extract_null <- function(list_all, location) {
  
  # extract the location element of the list
  temp <- map(list_all, location)
  
  # replace NULLS with NA
  is.na(temp) <- lengths(temp) == 0
  
  # turn it into a character
  temp_sort <- temp %>% 
    unlist() %>% 
    as.character()
  
  # return
  return(temp_sort)
}

# read in the gamelist.xml file and parse into a dataframe
read_gamelist_xml <- function(file_path) {
  
  # read the gamelist.xml file from the filepath and coerce to list
  gamelist <- read_xml(file_path) %>% 
    as_list()

  # extract the data into a nice dataframe
  df <- tibble(
    path = do.call(list_extract_null, list(gamelist$gameList, "path")),
    name = do.call(list_extract_null, list(gamelist$gameList, "name")),
    desc = do.call(list_extract_null, list(gamelist$gameList, "desc")),
    image = do.call(list_extract_null, list(gamelist$gameList, "image")),
    releasedate = do.call(list_extract_null, list(gamelist$gameList, "releasedate")),
    developer = do.call(list_extract_null, list(gamelist$gameList, "developer")),
    publisher = do.call(list_extract_null, list(gamelist$gameList, "publisher")),
    genre = do.call(list_extract_null, list(gamelist$gameList, "genre")),
    players = do.call(list_extract_null, list(gamelist$gameList, "players")),
    playcount = do.call(list_extract_null, list(gamelist$gameList, "playcount")),
    lastplayed = do.call(list_extract_null, list(gamelist$gameList, "lastplayed"))
    )
  
  # return the dataframe
  return(df)
}

# take a dataframe in the gamelist format and write out an XML file
# to file_path of the correct format for retropie
write_gamelist_xml <- function(df_all, file_path) {
  
  # set up a blank list
  data <- list()
  
  # iterate through every row of the dataframe
  for(i in 1:nrow(df_all)) {
    
    # take one row at a time
    df_slice <- df_all %>% 
      slice(i)
    
    # only select columns which have a non-na value so we can rebuild the xml properly
    df_slice <- df_slice %>% 
      select(where(function(x) !is.na(x)))
    
    # rebuild the list in the correct format
    data[[i]] <- list(path = list(df_slice$path), 
                      name = list(df_slice$name), 
                      desc = list(df_slice$desc), 
                      image = list(df_slice$image), 
                      releasedate = list(df_slice$releasedate), 
                      developer = list(df_slice$developer), 
                      publish = list(df_slice$publisher),
                      genre = list(df_slice$genre),
                      players = list(df_slice$players),
                      playcount = list(df_slice$playcount),
                      lastplayed = list(df_slice$lastplayed)
                      )
  }
  
  # name each individual list as "game"
  names(data) <- rep("game", nrow(df_all))
  
  # put them into one master list called gameList
  new_gamelist <- list(gameList = data)
  
  # convert to XML and write to file_path
  new_gamelist %>% 
    as_xml_document() %>% 
    write_xml(filepath, options = "as_xml")
}

df_game <- read_gamelist_xml("~/R/gamelist.xml")

