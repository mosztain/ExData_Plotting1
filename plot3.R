if (!file.exists("household_power_consumption.txt")) {
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileUrl, destfile = "household_power_consumption.zip")
    unzip("household_power_consumption.zip")
}
## Load the data
data <- read.table("household_power_consumption.txt", sep = ";", header = TRUE)

## Adjust formats for Date to reduce the set
data$Date <- as.Date(data$Date, format="%d/%m/%Y")

## Reduce the set to dates between '2007-02-01' and '2007-02-02'
Start_date <- as.POSIXct("2007-02-01")
End_date <- as.POSIXct("2007-02-02")
databound <- subset(data, data$Date %in% as.Date(c(Start_date, End_date)))

## Adjust format for needed columns 
## databound$Global_active_power <- as.numeric(as.character(databound$Global_active_power))
## databound$Global_reactive_power <- as.numeric(as.character(databound$Global_reactive_power))
## databound$Voltage <- as.numeric(as.character(databound$Voltage))
## databound$Global_intensity <- as.numeric(as.character(databound$Global_intensity))
databound$Sub_metering_1 <- as.numeric(as.character(databound$Sub_metering_1))
databound$Sub_metering_2 <- as.numeric(as.character(databound$Sub_metering_2))

## Add a new column for Date+Time -- there will be some warnings about TZ not being declared
databound$DateTime <- as.POSIXct(paste(databound$Date, databound$Time), format("%Y-%m-%d %H:%M:%S"))

## Make the plot
## I'll plot into the screen and then copy into png.  Since the png default is 480x480 in pixels
## I don't have to specify the size.

## This plot does not have a title nor a label for x-axis 
## Since the plot involves three different lines, I'll
## plot one at a time
plot(databound$DateTime, databound$Sub_metering_1, type = 'l', ann = FALSE)

## Draw the lines in the following colors: Black - Red - Blue
lines(databound$DateTime, databound$Sub_metering_1, type = 'l')
lines(databound$DateTime, databound$Sub_metering_2, type = 'l', col = "red")
lines(databound$DateTime, databound$Sub_metering_3, type = 'l', col = "blue")

## Set the label for the y axis
title(ylab = "Energy sub metering")

## Set the box with legends for each plot
legend("topright", lty = 1, col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## Save the plot into a .png file
dev.copy(png,'plot3.png')
dev.off()