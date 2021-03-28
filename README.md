# Parse a RetroPie `gamelist.xml` File

Having recently gotten into using [RetroPie](https://retropie.org.uk/) on one of my Raspberry Pi's, I've been gently annoyed that the ROM scraper has a US-centricity to both the images it scrapes and the data it gets. Noodling around it seems the scraper populates a number of `gamelist.xml` files in each of the system directories in the RetroPie folders at: `~/.emulationstation/gamelists/{system}`

The structure is pretty simple so, not wanting to waste my fine R skills, I wrote a couple of helper functions to read into and out of a dataframe in R.

`read_gamelist_xml` - This function will read a `gamelist.xml` file and convert to an R dataframe.

`write_gamelist_xml` - This function will read an R dataframe in the correct format and write out a new `gamelist.xml` file

`list_extract_null` - This function takes an element of a list and extracts it, but replaces any missing data with `NA`

#### Future Development

rip and replace image files

shiny front end for editing
