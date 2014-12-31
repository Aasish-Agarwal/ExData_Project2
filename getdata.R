library(R.utils)

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
