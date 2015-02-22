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
  filter(fips == "24510") %>%
  group_by(year,SCC) %>%
  summarize(total_emissions = sum(Emissions) )  

NEI_group_by_fuel <- merge(NEI_group_by_fuel,SCC,by="SCC",all.x = T)  %>% tbl_df()
NEI_group_by_fuel <-   filter(NEI_group_by_fuel , grepl("Vehicles", EI.Sector))

NEI_group_by_fuel <- NEI_group_by_fuel %>%
  group_by(year,EI.Sector) %>%
  summarize(total_emissions = sum(total_emissions) )  

##############################################################################
g <- ggplot(NEI_group_by_fuel, aes(year,total_emissions ))
p <- g + 
  geom_bar( aes(fill=year), stat="identity") +
  geom_line(colour="red", size=1) +
  guides(size=F,colour=F,fill=F)+
  facet_grid( EI.Sector ~ ., scales="free", as.table=F) +
  labs(y = "Total Emissions (1000 Tons)") +
  ggtitle("Emissions By Fuel Type")

print(p)
dev.copy(png,file = "plot5.png", width = 480, height = 880, units = "px")
dev.off()


