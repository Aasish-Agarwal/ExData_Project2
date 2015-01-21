# #############################################################################
# Objective
#   Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad)
#   variable, which of these four sources have seen decreases in emissions from 1999-2008
#   for Baltimore City? Which have seen increases in emissions from 1999-2008? 
#   Use the ggplot2 plotting system to make a plot answer this question.

##############################################################################
# DOWNLOAD ,UNCOMPRESS, LOAD Data

# File "FNEI_data.zip" is downloaded only once
# If for some reason file must be downloaded again, manualy remove the existing file from your working directory.

# Download And Unzip Data File
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
projectDatafile <- "FNEI_data.zip"

cat("\nDownloadoing data set if not already exists: " , projectDatafile)
if (! file.exists(projectDatafile)){
  cat("\nStaring data download")
  download.file(url , projectDatafile, method = "curl")
  unzip(projectDatafile)
} else {
  cat("\nFile already downloaded")
} 

# Load data sets if not already loaded
cat("\nLoading data sets if not already loaded")
if (!exists("NEI")) {
  NEI <- readRDS("summarySCC_PM25.rds")
  SCC <- readRDS("Source_Classification_Code.rds")
}
cat("\nDone with data load")

##############################################################################
# Agreegate total emissions from PM2.5 for fips "24510"
# Total emissions are recorded in variable total_emissions as 1000 tons
# Total emission in 1000 tons is also rounded to 2 decimal places

library(dplyr)
NEI_group_by_year <- NEI %>%
  tbl_df() %>%
  group_by(type,year) %>%
  filter(fips == "24510") %>%
  summarize(total_emissions = sum(Emissions) )  


##############################################################################
# CREATE PNG File

qplot(year, total_emissions, data=NEI_group_by_year , facets = type ~ . , 
      binwidth = 2, color = type,
      ylab = "Total Emissions (Tons)",
      geom=c("point","smooth"))

dev.copy(png,file = "plot3.png", width = 480, height = 480, units = "px")

# Winding up by closing png device
dev.off()

cat("\nCreated plot3.png in your working directory")
