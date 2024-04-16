DATA <- read.csv("EENO.csv", header = TRUE, sep = ";")

# Check the DateTime format
head(DATA$DateTime)

# check if the first NA has initially data
DATA[1994:1998,]

# Combine 'DateTime' columns into a single POSIXct datetime object
DATA$DateTime <- as.POSIXct(paste(DATA$DateTime), tz="Etc/GMT-3", 
                            format = "%m/%d/%Y %H:%M")

###
### I found the culprit, its the daylight saving time algorithm
### that is implemented into the DateTime system or R.
### Now, instead of Europe/Tallinn time zone that has daylight
### saving by default I use the Etc/GMT-3 that has same time but
### no daylight saving is applied 
###
### If you leave it out, the default is UTC!
### Therefore, in your code DateTime and DateTime_UTC were the same.
###

DATA[1994:1998,]

# Check now if the time zone is set correct on the initial data
head(DATA$DateTime)

# find possible NA values in the read-in data, if none, all is ok
which(is.na(DATA$DateTime))

# Convert the datetime object to UTC
library(lubridate)
DATA$DateTime_UTC <- with_tz(DATA$DateTime, "UTC")

# Check the timezone information of the DateTime column
head(DATA$DateTime)

# Check the timezone information of the DateTime_UTC column
head(DATA$DateTime_UTC)

DATA

# Save data into new csv file
write.csv(DATA, "EENO_UTC.csv", row.names = FALSE)
