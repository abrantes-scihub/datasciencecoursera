# EXPLORATORY DATA ANALYSIS
# COURSE PROJECT 1
# The dataset has 2,075,259 rows and 9 columns.
# We will only be using data from the dates 2007-02-01 and 2007-02-02.
# 
file <- "~/data/household_power_consumption.csv"
select <- "select * from file where Date in ('1/2/2007', '2/2/2007')"
hpc <- read.csv.sql(file, sql = select) 

times <- as.POSIXct(strptime(paste(hpc$Date, hpc$Time), "%d/%m/%Y %H:%M:%S"))
hpc1 <- mutate(hpc, datetime = times) 

# Our overall goal here is simply to examine how household energy usage 
# varies over a 2-day period in February, 2007. Your task is to reconstruct 
# the following plots below, all of which were constructed using the base 
# plotting system.

# PLOT 3:
with(hpc1, plot(datetime, Sub_metering_1, xlab="", ylab = "Energy sub metering", type = "n") ) 
lines(as.matrix(cbind(hpc1$datetime, hpc1$Sub_metering_1)), type ="l", col = "black")
lines(as.matrix(cbind(hpc1$datetime, hpc1$Sub_metering_2)), type ="l", col = "red") 
lines(as.matrix(cbind(hpc1$datetime, hpc1$Sub_metering_3)), type ="l", col = "blue")
legend("topright", lty =1,  col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")) 
dev.copy(png, file="./plot3.png", width=480, height=480)
dev.off()

# Reproduce the image (within a different frame):
library(png)
img1 <- readPNG("./plot1.png")
plot(c(0, 500), c(0, 500), type = "n", xlab = "", ylab = "")
rasterImage(img1, 0, 0, 480, 480)
