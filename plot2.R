#plot2.R
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
library(lattice)
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
Sys.setlocale("LC_TIME", "C") # english Axis

with(data, plot(x = DateTime, y = Global_active_power, type = "l",
                xlab = "", ylab = "Global Active Power (kilowatts)", xaxt = "n"))
axis.POSIXct(1, at = seq(min(data$DateTime), max(data$DateTime), by = "days"), format = "%a")

# in the dataset Saturday is not included, but the axis needs the "Sat", as given in the assignment
# so I am adding another hour to the axis (60s*60min = 3600s)
axis.POSIXct(1, at = seq(min(data$DateTime), max(data$DateTime) + 3600, by = "days"), format = "%a")

# now i can save the plot as png
png(filename = "plot2.png", width = 480, height = 480, units = "px")
with(data, plot(x = DateTime, y = Global_active_power, type = "l",
                xlab = "", ylab = "Global Active Power (kilowatts)", xaxt = "n"))
axis.POSIXct(1, at = seq(min(data$DateTime), max(data$DateTime) + 3600, by = "days"), format = "%a")
dev.off()





