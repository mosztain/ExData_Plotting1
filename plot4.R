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
databound$Global_active_power <- as.numeric(as.character(databound$Global_active_power))
databound$Global_reactive_power <- as.numeric(as.character(databound$Global_reactive_power))
databound$Voltage <- as.numeric(as.character(databound$Voltage))
## databound$Global_intensity <- as.numeric(as.character(databound$Global_intensity))
databound$Sub_metering_1 <- as.numeric(as.character(databound$Sub_metering_1))
databound$Sub_metering_2 <- as.numeric(as.character(databound$Sub_metering_2))

## Add a new column for Date+Time -- there will be some warnings about TZ not being declared
databound$DateTime <- as.POSIXct(paste(databound$Date, databound$Time), format("%Y-%m-%d %H:%M:%S"))

## Make the plot
## I'll plot into the screen and then copy into png.  Since the png default is 480x480 in pixels
## I don't have to specify the size.

## I need four plots:
## 1. Global Active Power (top left)
## 2. Voltage (top right)
## 3. Energy sub metering (bot left)
## 4. Global Reactive Power (bot right)

##  Set the grid to draw the plots - drawing by row order
par(mfrow=c(2,2))

## Top left (Global Active Power)
## This plot does not have a title nor a label for x-axis
plot(databound$DateTime, databound$Global_active_power, type = 'l', ann = FALSE)

## Set the label for the y-axis
title(ylab = "Global Axis Power (kilowatts)")

## Top right (Voltage)
## This plot does not have a title
plot(databound$DateTime, databound$Voltage, type = 'l', ann = FALSE)

## Set the label for the y-axis
title(ylab = "Voltage", xlab = "datetime")

## Bot left (Energy sub metering)
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
legend("topright", lty = 1, col = c("black", "red", "blue"), bty = "n",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## Bot right (Global Reactive Power)
## This plot does not have a title
plot(databound$DateTime, databound$Global_reactive_power, type = 'l', ann = FALSE)

## Set the label for the y-axis
title(ylab = "Global_reactive_power", xlab = "datetime")

## Save the plot into a .png file
dev.copy(png,'plot4.png')
dev.off()