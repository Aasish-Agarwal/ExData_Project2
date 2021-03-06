# #############################################################################
# Objective
#   Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
#   Using the base plotting system, make a plot showing the total PM2.5 emission 
#   from all sources for each of the years 1999, 2002, 2005, and 2008.

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
# Agreegate total emissions from PM2.5
# Total emissions are recorded in variable total_emissions as million tons
# Total emission in million tons is also rounded to 2 decimal places

library(dplyr)
NEI_group_by_year <- NEI %>%
  tbl_df() %>%
  select(Emissions,year) %>%
  group_by(year) %>%
  summarize(total_emissions = round(sum(Emissions)/1000000,2)) 


##############################################################################
# CREATE PNG File

# Creating Plot
# Setting margins
par(mai = c(1.2,1.2,0.75,0.5))

# Plot with increased size of the symbol, no line
par(lty = 1, cex = 1.5 , cex.axis = 0.7 , cex.lab = 0.7 , cex.main = 0.8)

with(NEI_group_by_year, {plot(year,total_emissions, type = "l", xlab = "year" , 
                              ylab = "Total Emissions (Million Ton)" ,
                              main = "Total PM25 Emissions")
                         points(year,total_emissions, pch = 19, col = "red" )
                         })

model <- lm(total_emissions ~ year, NEI_group_by_year)
abline(model, lwd = 2, col = "magenta1", lty = 1)

dev.copy(png,file = "plot1.png", width = 480, height = 480, units = "px")

# Winding up by closing png device
dev.off()

cat("\nCreated plot1.png in your working directory")

