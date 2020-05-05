## plot3.R   
## This is for an eda class
## Chris Thoburn 05-05-20
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

targetdata$Sub_metering_1 = as.numeric(targetdata$Sub_metering_1)
targetdata$Sub_metering_2 = as.numeric(targetdata$Sub_metering_2)
targetdata$Sub_metering_3 = as.numeric(targetdata$Sub_metering_3)

## #############################################################
## target image generation
## #############################################################
##return to the starting directory
setwd(startDir)

## open the device
png(filename = "plot3.png", width = 480, height = 480)

## build the figure - this one has multiple parts overlayed
## we need a common range
yRange <- range(c(targetdata$Sub_metering_1,
                  targetdata$Sub_metering_2,
                  targetdata$Sub_metering_3))

targetimage <- plot(targetdata$datetime,
                    targetdata$Sub_metering_1,
                    type = "l",
                    col  = "black",
                    main = "",
                    xlab = "",
                    ylab = "",
                    ylim = yRange)

par(new= TRUE)  ## draw over the previous image
targetimage <- plot(targetdata$datetime,
                     targetdata$Sub_metering_2,
                     type = "l",
                     col  = "red",
                     main = "",
                     xlab = "",
                     ylab = "",
                     ylim = yRange)

par(new= TRUE)  ## draw over the previous image
targetimage <- plot(targetdata$datetime,
                     targetdata$Sub_metering_3,
                     type = "l",
                     col  = "blue",
                     main = "",
                     xlab = "",
                     ylab = "Energy sub metering",
                     ylim = yRange)

## and we need the legend to match the overlayed graphs
targetimage <- legend("topright", 
                pch = "-",
                col = c("black", "red", "blue"),
                legend = c("Sub_metering_1",
                           "Sub_metering_2",
                           "Sub_metering_3")
                           )

## close the device
dev.off()


