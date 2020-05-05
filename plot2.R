## plot2.R   
## This is for an eda class
## Chris Thoburn 05-04-20
##
## This script generates a target PNG file (480 x 480) for a reference

## #############################################################
## setup #######################################################
## librarys we need
library("data.table")

# remember the directory we start in
startDir <- getwd()

## location where we will store data
dataDir <- "./data"

## name for the data archive we acquire
dataFilename <- "datafile.zip"

## The primary data url
dataURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

## make a directory for the data
if (!file.exists(dataDir)) {dir.create(dataDir)}

## get the file, change the working directory and unzip it
download.file(dataURL, file.path(dataDir, dataFilename))
setwd(dataDir)
unzip(zipfile = dataFilename)

## #############################################################
## primary data subset acquisition 
## #############################################################
data <- read.table("household_power_consumption.txt",
                   header = TRUE,
                   sep = ";",
                   stringsAsFactors = FALSE)

## cleanup the dates we need to use for the format we want
data$datetime = paste(data$Date, data$Time, sep = " ")
data$datetime = strptime(data$datetime, format="%d/%m/%Y %H:%M:%S")
data$Date     = as.Date(data$Date, "%d/%m/%Y")

## #############################################################
## target data generation
## #############################################################
targetdata = subset(data, 
                    (Date >= as.Date("2007-02-01") & 
                     Date <= as.Date("2007-02-02")))

targetdata$Global_active_power = as.numeric(targetdata$Global_active_power)

## #############################################################
## target image generation
## #############################################################
##return to the starting directory
setwd(startDir)

## open the device
png(filename = "plot2.png", width = 480, height = 480)

## build the figure
targetimage <- plot(targetdata$datetime,
                    targetdata$Global_active_power,
                    type = "l",
                    col  = "black",
                    main = "",
                    xlab = "",
                    ylab = "Global Active Power (kilowatts)")

## close the device
dev.off()


