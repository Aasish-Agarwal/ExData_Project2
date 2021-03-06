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
# Agreegate total emissions from PM2.5 agreegated by fuel (SCC)
# Total emissions in 1000's are recorded in variable total_emissions 

library(dplyr)
library(ggplot2)
NEI_group_by_fuel <- NEI %>%
  tbl_df() %>%
  filter(fips == "24510" | fips == "06037" ) %>%
  group_by(fips,year,SCC) %>%
  summarize(total_emissions = sum(Emissions) )  

fipsmap <- data.frame(fips= c("24510","06037"), City= c("Baltimore City", "Los Angeles County"))

NEI_group_by_fuel <- merge(NEI_group_by_fuel,SCC,by="SCC",all.x = T)  %>% tbl_df()

NEI_group_by_fuel <- merge(NEI_group_by_fuel,fipsmap,by="fips",all.x = T)  %>% tbl_df()

NEI_group_by_fuel <-   filter(NEI_group_by_fuel , grepl("Vehicles", EI.Sector))

NEI_group_by_fuel <- NEI_group_by_fuel %>%
  group_by(City,year,EI.Sector) %>%
  summarize(total_emissions = sum(total_emissions) )  

##############################################################################
g <- ggplot(NEI_group_by_fuel, aes(year,total_emissions ))
p <- g + geom_point(aes(color = City), size=5, shape=18) + 
  geom_line(aes(color = City)) +
  facet_grid( EI.Sector ~ ., scales="free", as.table=F) +
  labs(y = "Total Emissions (Tons)") +
  ggtitle("Emissions By Fuel Type")

print(p)
dev.copy(png,file = "plot6.png", width = 680, height = 1080, units = "px")
dev.off()
