# #############################################################################
# Objective
#   Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
#   Using the base plotting system, make a plot showing the total PM2.5 emission 
#   from all sources for each of the years 1999, 2002, 2005, and 2008.

##############################################################################
# DOWNLOAD ,UNCOMPRESS, LOAD Data
# Code for downloading and uncompressing test data resides in getdata.R
# Code is executed as we source getdata.R
# File "FNEI_data.zip" is downloaded only once
# If for some reason file must be downloaded again, manualr remove the existing file from your working directory.
#
# Script also uncompresses FNEI_data.zip 
#
# Data sets are than loaded into objects NEI & SCC  
#   NEI <- readRDS("summarySCC_PM25.rds")
#   SCC <- readRDS("Source_Classification_Code.rds")
#
# Re-executing getdata.R will not load the data sets again if already loaded
source("getdata.R")
