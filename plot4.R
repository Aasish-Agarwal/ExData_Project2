# #############################################################################
# Objective
#   Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?

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
# Agreegate total emissions from PM2.5 agreegated by fuel (SCC)
# Total emissions are recorded in variable total_emissions 

library(dplyr)
library(ggplot2)
NEI_group_by_fuel <- NEI %>%
  tbl_df() %>%
  group_by(year,SCC) %>%
  summarize(total_emissions = sum(Emissions) )  

NEI_group_by_fuel <- merge(NEI_group_by_fuel,SCC,by="SCC",all.x = T)  %>% tbl_df()
NEI_group_by_fuel <-   filter(NEI_group_by_fuel , grepl("Coal", EI.Sector))

NEI_group_by_fuel <- NEI_group_by_fuel %>%
  group_by(year,EI.Sector) %>%
  summarize(total_emissions = sum(total_emissions) )  %>%
  mutate( total_emissions = total_emissions/1000)

##############################################################################
# CREATE PNG File

g <- ggplot(NEI_group_by_fuel, aes(year,total_emissions ))
p <- g + geom_point() + 
  facet_grid( EI.Sector ~ ., scales="free") +
  labs(y = "Total Emissions (1000 Tons)") +
  ggtitle("Emissions By Fuel Type")

print(p)

dev.copy(png,file = "plot4.png", width = 480, height = 680, units = "px")

# Winding up by closing png device
dev.off()

cat("\nCreated plot4.png in your working directory")

