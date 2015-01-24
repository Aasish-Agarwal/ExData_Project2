# How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?
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
# Total emissions in 1000's are recorded in variable total_emissions 

library(dplyr)
library(ggplot2)
NEI_group_by_fuel <- NEI %>%
  tbl_df() %>%
  filter(fips == "24510") %>%
  group_by(year,SCC) %>%
  summarize(total_emissions = sum(Emissions) )  

NEI_group_by_fuel <- merge(NEI_group_by_fuel,SCC,by="SCC",all.x = T)  %>% tbl_df()
NEI_group_by_fuel <-   filter(NEI_group_by_fuel , grepl("Vehicles", EI.Sector))

NEI_group_by_fuel <- NEI_group_by_fuel %>%
  group_by(year,EI.Sector) %>%
  summarize(total_emissions = sum(total_emissions) )  

##############################################################################
# CREATE PNG File

g <- ggplot(NEI_group_by_fuel, aes(year,total_emissions ))
p <- g + geom_point() + 
  facet_grid( EI.Sector ~ ., scales="free", as.table=F) +
  labs(y = "Total Emissions (1000 Tons)") +
  ggtitle("Emissions By Fuel Type")

print(p)

dev.copy(png,file = "plot5.png", width = 480, height = 880, units = "px")

# Winding up by closing png device
dev.off()

cat("\nCreated plot5.png in your working directory")

