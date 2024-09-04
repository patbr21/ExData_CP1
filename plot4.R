# plot4.R
# Copyright (C) [2015] [patbr21]
# All rights reserved.

# This script is part of a public GitHub project and is subject to the following terms:
#
# 1. Permission is granted to use, copy, modify, and distribute this code for any purpose, 
#    provided that the original author ([Your Name or Username]) is clearly credited.
#
# 2. Commercial use of this code is strictly prohibited without prior written permission 
#    from the author.
#
# 3. This code is provided "as is", without warranty of any kind, express or implied. The author 
#    is not liable for any damages or losses that may arise from the use of this code.
#
# 4. By using this code, you agree to these terms.

#--------
# load packages
library(data.table)
library(dplyr)
# read the data
file_path <- "household_power_consumption.txt"
initial <- read.table(file_path, 
                      header = TRUE, 
                      sep = ";", 
                      nrows = 5, 
                      na.strings = "?")

# Zeige die Spaltennamen
names(initial)
column_classes <- sapply(initial, class)  # Ermittelt die Datentypen der Spalten

data <- fread("household_power_consumption.txt", 
              sep = ";", 
              na.strings = "?",
              colClasses = column_classes)

# Subset the data for the dates 2007-02-01 and 2007-02-02
data <- data[Date %in% c("1/2/2007", "2/2/2007")]

# transform to datetime
data[, DateTime := as.POSIXct(strptime(paste(Date, Time), format="%d/%m/%Y %H:%M:%S"))]
head(data)

# plotting Datetime vs Global Active Power as lineplot
Sys.setlocale("LC_TIME", "C") # english days on the x-Axis

# two plots we already have, so lets create the other two
# datetime vs voltage, basically plot 2 but different y variable and diff x-Axis label
# Setze den Layout-Bereich auf 2x2
png(filename = "plot4.png", width = 480, height = 480, units = "px")

par(mfrow = c(2, 2))

# 1. Plot: Global Active Power (links oben)
with(data, plot(x = DateTime, y = Global_active_power, type = "l",
                xlab = "", ylab = "Global Active Power (kilowatts)", xaxt = "n"))
axis.POSIXct(1, at = seq(min(data$DateTime), max(data$DateTime) + 3600, by = "days"), format = "%a")

# 2. Plot: Voltage (rechts oben)
with(data, plot(x = DateTime, y = Voltage, type = "l",
                xlab = "datetime", ylab = "Voltage", xaxt = "n"))
axis.POSIXct(1, at = seq(min(data$DateTime), max(data$DateTime) + 3600, by = "days"), format = "%a")

# 3. Plot: Energy Sub Metering (links unten)
with(data, plot(x = DateTime, y = Sub_metering_1, type = "l", xaxt = "n", xlab = "", ylab = "Energy sub metering"))
with(data, lines(x = DateTime, y = Sub_metering_2, col = "red"))
with(data, lines(x = DateTime, y = Sub_metering_3, col = "blue"))
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = 1, lwd = 2, cex = 0.8)
axis.POSIXct(1, at = seq(min(data$DateTime), max(data$DateTime) + 3600, by = "days"), format = "%a")

# 4. Plot: Platzhalter für den vierten Plot (rechts unten)
with(data, plot(x = DateTime, y = Global_reactive_power, type = "l",
                xlab = "datetime", ylab = "Global_reactive_power ", xaxt = "n"))
axis.POSIXct(1, at = seq(min(data$DateTime), max(data$DateTime) + 3600, by = "days"), format = "%a")# with(data, plot(x = DateTime, y = <your_variable>, type = "l", xlab = "datetime", ylab = "<your_label>"))
dev.off()


