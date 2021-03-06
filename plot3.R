# #############################################################################
# Objective
#   Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad)
#   variable, which of these four sources have seen decreases in emissions from 1999-2008
#   for Baltimore City? Which have seen increases in emissions from 1999-2008? 
#   Use the ggplot2 plotting system to make a plot answer this question.

##############################################################################
# DOWNLOAD ,UNCOMPRESS, LOAD Data
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
projectDatafile <- "FNEI_data.zip"
if (! file.exists(projectDatafile)){
  download.file(url , projectDatafile, method = "curl")
  unzip(projectDatafile)
} 
if (!exists("NEI")) {
  NEI <- readRDS("summarySCC_PM25.rds")
  SCC <- readRDS("Source_Classification_Code.rds")
}

##############################################################################
# Agreegate total emissions from PM2.5 for fips "24510" agreegated by source type
# Total emissions are recorded in variable total_emissions 
library(dplyr)
library(ggplot2)
NEI_group_by_type <- NEI %>%
  tbl_df() %>%
  group_by(type,year) %>%
  filter(fips == "24510") %>%
  summarize(total_emissions = sum(Emissions) )  

##############################################################################
# CREATE PNG File
g <- ggplot(NEI_group_by_type, aes(year,total_emissions ))
p <- g + geom_point(aes(colour = type)) + geom_line() +
  facet_grid(. ~ type) + 
  facet_wrap( ~ type, nrow = 2, ncol = 2) + 
  guides(colour=FALSE) + 
  labs(y = "Total Emissions (Tons)") +
  ggtitle("Emissions By Type - Baltimore")
print(p)
dev.copy(png,file = "plot3.png", width = 480, height = 480, units = "px")
# Winding up by closing png device
dev.off()

