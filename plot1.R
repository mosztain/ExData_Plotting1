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

## Adjust format for needed column
databound$Global_active_power <- as.numeric(as.character(databound$Global_active_power))
## databound$Global_reactive_power <- as.numeric(as.character(databound$Global_reactive_power))
## databound$Voltage <- as.numeric(as.character(databound$Voltage))
## databound$Global_intensity <- as.numeric(as.character(databound$Global_intensity))
## databound$Sub_metering_1 <- as.numeric(as.character(databound$Sub_metering_1))
## databound$Sub_metering_2 <- as.numeric(as.character(databound$Sub_metering_2))

## Make the plot
## I'll plot into the screen and then copy into png.  Since the png default is 480x480 in pixels
## I don't have to specify the size.

hist(databound$Global_active_power, col = "red", 
     xlab = "Global Active Power (kilowatts)", 
     main = "Global Active Power")

## Save the plot into a .png file
dev.copy(png,'plot1.png')
dev.off()