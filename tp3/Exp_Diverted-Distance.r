load_library <- function(){
  library(DBI)
  library(ggplot2)
}
load_library()
from_db <- function(sql) {
  dbGetQuery(ontime, sql)
}
ontime <- dbConnect(RSQLite::SQLite(), dbname = "ontime.sqlite3")

from_db("select max(distance), min(distance) from ontime where year = '2000' or year = '2001' or year = '2002' or year = '2003' or year = '2004' or year = '2005' or year = '2006' or year = '2007' or year = '2008'")

ranges <- c('0', '6', '11', '16', '21', '26', '31', '36', '41', '46')

layout(matrix(c(1,4,7,2,5,8,3,6,9),3))
par(mar = c(4,2,1,1), col = "black")

plot((1:length(data_2000)), data_2000, ylim = c(0, 0.025), xlab = '2000', xaxt = 'n')
lines((1:length(data_2000)), data_2000, ylim = c(0, 0.025), xlab = '2000', xaxt = 'n')
Axis(side=1, at = 1:length(ranges), labels = ranges)
plot((1:length(data_2001)), data_2001, ylim = c(0, 0.025), xlab = '2001', xaxt = 'n')
lines((1:length(data_2001)), data_2001, ylim = c(0, 0.025), xlab = '2001', xaxt = 'n')
Axis(side=1, at = 1:length(ranges), labels = ranges)
plot((1:length(data_2002)), data_2002, ylim = c(0, 0.025), xlab = '2002', xaxt = 'n')
lines((1:length(data_2002)), data_2002, ylim = c(0, 0.025), xlab = '2002', xaxt = 'n')
Axis(side=1, at = 1:length(ranges), labels = ranges)
plot((1:length(data_2003)), data_2003, ylim = c(0, 0.025), xlab = '2003', xaxt = 'n')
lines((1:length(data_2003)), data_2003, ylim = c(0, 0.025), xlab = '2003', xaxt = 'n')
Axis(side=1, at = 1:length(ranges), labels = ranges)
plot((1:length(data_2004)), data_2004, ylim = c(0, 0.025), xlab = '2004', xaxt = 'n')
lines((1:length(data_2004)), data_2004, ylim = c(0, 0.025), xlab = '2004', xaxt = 'n')
Axis(side=1, at = 1:length(ranges), labels = ranges)
plot((1:length(data_2005)), data_2005, ylim = c(0, 0.025), xlab = '2005', xaxt = 'n')
lines((1:length(data_2005)), data_2005, ylim = c(0, 0.025), xlab = '2005', xaxt = 'n')
Axis(side=1, at = 1:length(ranges), labels = ranges)
plot((1:length(data_2006)), data_2006, ylim = c(0, 0.025), xlab = '2006', xaxt = 'n')
lines((1:length(data_2006)), data_2006, ylim = c(0, 0.025), xlab = '2006', xaxt = 'n')
Axis(side=1, at = 1:length(ranges), labels = ranges)
plot((1:length(data_2007)), data_2007, ylim = c(0, 0.025), xlab = '2007', xaxt = 'n')
lines((1:length(data_2007)), data_2007, ylim = c(0, 0.025), xlab = '2007', xaxt = 'n')
Axis(side=1, at = 1:length(ranges), labels = ranges)
plot((1:length(data_2008)), data_2008, ylim = c(0, 0.025), xlab = '2008', xaxt = 'n')
lines((1:length(data_2008)), data_2008, ylim = c(0, 0.025), xlab = '2008', xaxt = 'n')
Axis(side=1, at = 1:length(ranges), labels = ranges)

data_2000 <- read.csv("outputR/data_2000.in", header = FALSE)$V1
data_2001 <- read.csv("outputR/data_2001.in", header = FALSE)$V1
data_2002 <- read.csv("outputR/data_2002.in", header = FALSE)$V1
data_2003 <- read.csv("outputR/data_2003.in", header = FALSE)$V1
data_2004 <- read.csv("outputR/data_2004.in", header = FALSE)$V1
data_2005 <- read.csv("outputR/data_2005.in", header = FALSE)$V1
data_2006 <- read.csv("outputR/data_2006.in", header = FALSE)$V1
data_2007 <- read.csv("outputR/data_2007.in", header = FALSE)$V1
data_2008 <- read.csv("outputR/data_2008.in", header = FALSE)$V1

write(data_2000, "outputR/avg_CA_2000.in", ncolumns = 1)
write(data_2001, "outputR/avg_CA_2001.in", ncolumns = 1)
write(data_2002, "outputR/avg_CA_2002.in", ncolumns = 1)
write(data_2003, "outputR/avg_CA_2003.in", ncolumns = 1)
write(data_2004, "outputR/avg_CA_2004.in", ncolumns = 1)
write(avg_FL_2004, "outputR/avg_FL_2004.in", ncolumns = 1)
write(avg_CA_2005, "outputR/avg_CA_2005.in", ncolumns = 1)
write(avg_FL_2005, "outputR/avg_FL_2005.in", ncolumns = 1)
write(avg_CA_2006, "outputR/avg_CA_2006.in", ncolumns = 1)
write(avg_FL_2006, "outputR/avg_FL_2006.in", ncolumns = 1)
write(avg_CA_2007, "outputR/avg_CA_2007.in", ncolumns = 1)
write(avg_FL_2007, "outputR/avg_FL_2007.in", ncolumns = 1)
write(avg_CA_2008, "outputR/avg_CA_2008.in", ncolumns = 1)
write(avg_FL_2008, "outputR/avg_FL_2008.in", ncolumns = 1)

data_0_500 <- from_db("select count(*) as Count, year
from ontime where (distance BETWEEN 0 and 500) and (year = '2000' or year = '2001' or year = '2002' or year = '2003' or year = '2004' or year = '2005' or year = '2006' or year = '2007' or year = '2008')
group by year")

data_501_1000 <- from_db("select count(*) as Count, year
from ontime where (distance BETWEEN 501 and 1000) and (year = '2000' or year = '2001' or year = '2002' or year = '2003' or year = '2004' or year = '2005' or year = '2006' or year = '2007' or year = '2008')
group by year")

data_1001_1500 <- from_db("select count(*) as Count, year
from ontime where (distance BETWEEN 1001 and 1500) and (year = '2000' or year = '2001' or year = '2002' or year = '2003' or year = '2004' or year = '2005' or year = '2006' or year = '2007' or year = '2008')
group by year")

data_1501_2000 <- from_db("select count(*) as Count, year
from ontime where (distance BETWEEN 1501 and 2000) and (year = '2000' or year = '2001' or year = '2002' or year = '2003' or year = '2004' or year = '2005' or year = '2006' or year = '2007' or year = '2008')
group by year")

data_2001_2500 <- from_db("select count(*) as Count, year
from ontime where (distance BETWEEN 2001 and 2500) and (year = '2000' or year = '2001' or year = '2002' or year = '2003' or year = '2004' or year = '2005' or year = '2006' or year = '2007' or year = '2008')
group by year")

data_2501_3000 <- from_db("select count(*) as Count, year
from ontime where (distance BETWEEN 2501 and 3000) and (year = '2000' or year = '2001' or year = '2002' or year = '2003' or year = '2004' or year = '2005' or year = '2006' or year = '2007' or year = '2008')
group by year")

data_3001_3500 <- from_db("select count(*) as Count, year
from ontime where (distance BETWEEN 3001 and 3500) and (year = '2000' or year = '2001' or year = '2002' or year = '2003' or year = '2004' or year = '2005' or year = '2006' or year = '2007' or year = '2008')
group by year")

data_3501_4000 <- from_db("select count(*) as Count, year
from ontime where (distance BETWEEN 3501 and 4000) and (year = '2000' or year = '2001' or year = '2002' or year = '2003' or year = '2004' or year = '2005' or year = '2006' or year = '2007' or year = '2008')
group by year")

data_4001_4500 <- from_db("select count(*) as Count, year
from ontime where (distance BETWEEN 4001 and 4500) and (year = '2000' or year = '2001' or year = '2002' or year = '2003' or year = '2004' or year = '2005' or year = '2006' or year = '2007' or year = '2008')
group by year")

data_4501_5000 <- from_db("select count(*) as Count, year
from ontime where (distance BETWEEN 4501 and 5000) and (year = '2000' or year = '2001' or year = '2002' or year = '2003' or year = '2004' or year = '2005' or year = '2006' or year = '2007' or year = '2008')
group by year")

data_4501_5000 <- from_db("select count(*) as Count, year
from ontime where (distance BETWEEN 4501 and 5000) and (year = '2000' or year = '2001' or year = '2002' or year = '2003' or year = '2004' or year = '2005' or year = '2006' or year = '2007' or year = '2008')
group by year")

from_db("select count(*) from ontime where diverted = 1 and year = '2000' or year = '2001' or year = '2002' or year = '2003' or year = '2004' or year = '2005' or year = '2006' or year = '2007' or year = '2008'")
data_diverted_0_500 <- from_db("select count(*) as Count, year
from ontime where (distance BETWEEN 0 and 500) and (diverted = 1) and (year = '2000' or year = '2001' or year = '2002' or year = '2003' or year = '2004' or year = '2005' or year = '2006' or year = '2007' or year = '2008')
group by year")

data_diverted_501_1000 <- from_db("select count(*) as Count, year
from ontime where (distance BETWEEN 501 and 1000) and (diverted = 1) and (year = '2000' or year = '2001' or year = '2002' or year = '2003' or year = '2004' or year = '2005' or year = '2006' or year = '2007' or year = '2008')
group by year")

data_diverted_1001_1500 <- from_db("select count(*) as Count, year
from ontime where (distance BETWEEN 1001 and 1500) and (diverted = 1) and (year = '2000' or year = '2001' or year = '2002' or year = '2003' or year = '2004' or year = '2005' or year = '2006' or year = '2007' or year = '2008')
group by year")

data_diverted_1501_2000 <- from_db("select count(*) as Count, year
from ontime where (distance BETWEEN 1501 and 2000) and (diverted = 1) and (year = '2000' or year = '2001' or year = '2002' or year = '2003' or year = '2004' or year = '2005' or year = '2006' or year = '2007' or year = '2008')
group by year")

data_diverted_2001_2500 <- from_db("select count(*) as Count, year
from ontime where (distance BETWEEN 2001 and 2500) and (diverted = 1) and (year = '2000' or year = '2001' or year = '2002' or year = '2003' or year = '2004' or year = '2005' or year = '2006' or year = '2007' or year = '2008')
group by year")

data_diverted_2501_3000 <- from_db("select count(*) as Count, year
from ontime where (distance BETWEEN 2501 and 3000) and (diverted = 1) and (year = '2000' or year = '2001' or year = '2002' or year = '2003' or year = '2004' or year = '2005' or year = '2006' or year = '2007' or year = '2008')
group by year")

data_diverted_3001_3500 <- from_db("select count(*) as Count, year
from ontime where (distance BETWEEN 3001 and 3500) and (diverted = 1) and (year = '2000' or year = '2001' or year = '2002' or year = '2003' or year = '2004' or year = '2005' or year = '2006' or year = '2007' or year = '2008')
group by year")

data_diverted_3501_4000 <- from_db("select count(*) as Count, year
from ontime where (distance BETWEEN 3501 and 4000) and (diverted = 1) and (year = '2000' or year = '2001' or year = '2002' or year = '2003' or year = '2004' or year = '2005' or year = '2006' or year = '2007' or year = '2008')
group by year")

data_diverted_4001_4500 <- from_db("select count(*) as Count, year
from ontime where (distance BETWEEN 4001 and 4500) and (diverted = 1) and (year = '2000' or year = '2001' or year = '2002' or year = '2003' or year = '2004' or year = '2005' or year = '2006' or year = '2007' or year = '2008')
group by year")

data_diverted_4501_5000 <- from_db("select count(*) as Count, year
from ontime where (distance BETWEEN 4501 and 5000) and (diverted = 1) and (year = '2000' or year = '2001' or year = '2002' or year = '2003' or year = '2004' or year = '2005' or year = '2006' or year = '2007' or year = '2008')
group by year")

data_2000 <- c(data_diverted_0_500$Count[data_diverted_0_500$Year == '2000'] / data_0_500$Count[data_0_500$Year == '2000'],
               data_diverted_501_1000$Count[data_diverted_501_1000$Year == '2000'] / data_501_1000$Count[data_501_1000$Year == '2000'],
               data_diverted_1001_1500$Count[data_diverted_1001_1500$Year == '2000'] / data_1001_1500$Count[data_1001_1500$Year == '2000'],
               data_diverted_1501_2000$Count[data_diverted_1501_2000$Year == '2000'] / data_1501_2000$Count[data_1501_2000$Year == '2000'],
               data_diverted_2001_2500$Count[data_diverted_2001_2500$Year == '2000'] / data_2001_2500$Count[data_2001_2500$Year == '2000'],
               data_diverted_2501_3000$Count[data_diverted_2501_3000$Year == '2000'] / data_2501_3000$Count[data_2501_3000$Year == '2000'],
               data_diverted_3001_3500$Count[data_diverted_3001_3500$Year == '2000'] / data_3001_3500$Count[data_3001_3500$Year == '2000'],
               data_diverted_3501_4000$Count[data_diverted_3501_4000$Year == '2000'] / data_3501_4000$Count[data_3501_4000$Year == '2000'],
               data_diverted_4001_4500$Count[data_diverted_4001_4500$Year == '2000'] / data_4001_4500$Count[data_4001_4500$Year == '2000'],
               data_diverted_4501_5000$Count[data_diverted_4501_5000$Year == '2000'] / data_4501_5000$Count[data_4501_5000$Year == '2000'])
data_2001 <- c(data_diverted_0_500$Count[data_diverted_0_500$Year == '2001'] / data_0_500$Count[data_0_500$Year == '2001'],
               data_diverted_501_1000$Count[data_diverted_501_1000$Year == '2001'] / data_501_1000$Count[data_501_1000$Year == '2001'],
               data_diverted_1001_1500$Count[data_diverted_1001_1500$Year == '2001'] / data_1001_1500$Count[data_1001_1500$Year == '2001'],
               data_diverted_1501_2000$Count[data_diverted_1501_2000$Year == '2001'] / data_1501_2000$Count[data_1501_2000$Year == '2001'],
               data_diverted_2001_2500$Count[data_diverted_2001_2500$Year == '2001'] / data_2001_2500$Count[data_2001_2500$Year == '2001'],
               data_diverted_2501_3000$Count[data_diverted_2501_3000$Year == '2001'] / data_2501_3000$Count[data_2501_3000$Year == '2001'],
               data_diverted_3001_3500$Count[data_diverted_3001_3500$Year == '2001'] / data_3001_3500$Count[data_3001_3500$Year == '2001'],
               data_diverted_3501_4000$Count[data_diverted_3501_4000$Year == '2001'] / data_3501_4000$Count[data_3501_4000$Year == '2001'],
               data_diverted_4001_4500$Count[data_diverted_4001_4500$Year == '2001'] / data_4001_4500$Count[data_4001_4500$Year == '2001'],
               data_diverted_4501_5000$Count[data_diverted_4501_5000$Year == '2001'] / data_4501_5000$Count[data_4501_5000$Year == '2001'])
data_2002 <- c(data_diverted_0_500$Count[data_diverted_0_500$Year == '2002'] / data_0_500$Count[data_0_500$Year == '2002'],
               data_diverted_501_1000$Count[data_diverted_501_1000$Year == '2002'] / data_501_1000$Count[data_501_1000$Year == '2002'],
               data_diverted_1001_1500$Count[data_diverted_1001_1500$Year == '2002'] / data_1001_1500$Count[data_1001_1500$Year == '2002'],
               data_diverted_1501_2000$Count[data_diverted_1501_2000$Year == '2002'] / data_1501_2000$Count[data_1501_2000$Year == '2002'],
               data_diverted_2001_2500$Count[data_diverted_2001_2500$Year == '2002'] / data_2001_2500$Count[data_2001_2500$Year == '2002'],
               data_diverted_2501_3000$Count[data_diverted_2501_3000$Year == '2002'] / data_2501_3000$Count[data_2501_3000$Year == '2002'],
               data_diverted_3001_3500$Count[data_diverted_3001_3500$Year == '2002'] / data_3001_3500$Count[data_3001_3500$Year == '2002'],
               data_diverted_3501_4000$Count[data_diverted_3501_4000$Year == '2002'] / data_3501_4000$Count[data_3501_4000$Year == '2002'],
               data_diverted_4001_4500$Count[data_diverted_4001_4500$Year == '2002'] / data_4001_4500$Count[data_4001_4500$Year == '2002'],
               data_diverted_4501_5000$Count[data_diverted_4501_5000$Year == '2002'] / data_4501_5000$Count[data_4501_5000$Year == '2002'])
data_2003 <- c(data_diverted_0_500$Count[data_diverted_0_500$Year == '2003'] / data_0_500$Count[data_0_500$Year == '2003'],
               data_diverted_501_1000$Count[data_diverted_501_1000$Year == '2003'] / data_501_1000$Count[data_501_1000$Year == '2003'],
               data_diverted_1001_1500$Count[data_diverted_1001_1500$Year == '2003'] / data_1001_1500$Count[data_1001_1500$Year == '2003'],
               data_diverted_1501_2000$Count[data_diverted_1501_2000$Year == '2003'] / data_1501_2000$Count[data_1501_2000$Year == '2003'],
               data_diverted_2001_2500$Count[data_diverted_2001_2500$Year == '2003'] / data_2001_2500$Count[data_2001_2500$Year == '2003'],
               data_diverted_2501_3000$Count[data_diverted_2501_3000$Year == '2003'] / data_2501_3000$Count[data_2501_3000$Year == '2003'],
               data_diverted_3001_3500$Count[data_diverted_3001_3500$Year == '2003'] / data_3001_3500$Count[data_3001_3500$Year == '2003'],
               data_diverted_3501_4000$Count[data_diverted_3501_4000$Year == '2003'] / data_3501_4000$Count[data_3501_4000$Year == '2003'],
               data_diverted_4001_4500$Count[data_diverted_4001_4500$Year == '2003'] / data_4001_4500$Count[data_4001_4500$Year == '2003'],
               data_diverted_4501_5000$Count[data_diverted_4501_5000$Year == '2003'] / data_4501_5000$Count[data_4501_5000$Year == '2003'])
data_2004 <- c(data_diverted_0_500$Count[data_diverted_0_500$Year == '2004'] / data_0_500$Count[data_0_500$Year == '2004'],
               data_diverted_501_1000$Count[data_diverted_501_1000$Year == '2004'] / data_501_1000$Count[data_501_1000$Year == '2004'],
               data_diverted_1001_1500$Count[data_diverted_1001_1500$Year == '2004'] / data_1001_1500$Count[data_1001_1500$Year == '2004'],
               data_diverted_1501_2000$Count[data_diverted_1501_2000$Year == '2004'] / data_1501_2000$Count[data_1501_2000$Year == '2004'],
               data_diverted_2001_2500$Count[data_diverted_2001_2500$Year == '2004'] / data_2001_2500$Count[data_2001_2500$Year == '2004'],
               data_diverted_2501_3000$Count[data_diverted_2501_3000$Year == '2004'] / data_2501_3000$Count[data_2501_3000$Year == '2004'],
               data_diverted_3001_3500$Count[data_diverted_3001_3500$Year == '2004'] / data_3001_3500$Count[data_3001_3500$Year == '2004'],
               data_diverted_3501_4000$Count[data_diverted_3501_4000$Year == '2004'] / data_3501_4000$Count[data_3501_4000$Year == '2004'],
               data_diverted_4001_4500$Count[data_diverted_4001_4500$Year == '2004'] / data_4001_4500$Count[data_4001_4500$Year == '2004'],
               data_diverted_4501_5000$Count[data_diverted_4501_5000$Year == '2004'] / data_4501_5000$Count[data_4501_5000$Year == '2004'])
data_2005 <- c(data_diverted_0_500$Count[data_diverted_0_500$Year == '2005'] / data_0_500$Count[data_0_500$Year == '2005'],
               data_diverted_501_1000$Count[data_diverted_501_1000$Year == '2005'] / data_501_1000$Count[data_501_1000$Year == '2005'],
               data_diverted_1001_1500$Count[data_diverted_1001_1500$Year == '2005'] / data_1001_1500$Count[data_1001_1500$Year == '2005'],
               data_diverted_1501_2000$Count[data_diverted_1501_2000$Year == '2005'] / data_1501_2000$Count[data_1501_2000$Year == '2005'],
               data_diverted_2001_2500$Count[data_diverted_2001_2500$Year == '2005'] / data_2001_2500$Count[data_2001_2500$Year == '2005'],
               data_diverted_2501_3000$Count[data_diverted_2501_3000$Year == '2005'] / data_2501_3000$Count[data_2501_3000$Year == '2005'],
               data_diverted_3001_3500$Count[data_diverted_3001_3500$Year == '2005'] / data_3001_3500$Count[data_3001_3500$Year == '2005'],
               data_diverted_3501_4000$Count[data_diverted_3501_4000$Year == '2005'] / data_3501_4000$Count[data_3501_4000$Year == '2005'],
               data_diverted_4001_4500$Count[data_diverted_4001_4500$Year == '2005'] / data_4001_4500$Count[data_4001_4500$Year == '2005'],
               data_diverted_4501_5000$Count[data_diverted_4501_5000$Year == '2005'] / data_4501_5000$Count[data_4501_5000$Year == '2005'])
data_2006 <- c(data_diverted_0_500$Count[data_diverted_0_500$Year == '2006'] / data_0_500$Count[data_0_500$Year == '2006'],
               data_diverted_501_1000$Count[data_diverted_501_1000$Year == '2006'] / data_501_1000$Count[data_501_1000$Year == '2006'],
               data_diverted_1001_1500$Count[data_diverted_1001_1500$Year == '2006'] / data_1001_1500$Count[data_1001_1500$Year == '2006'],
               data_diverted_1501_2000$Count[data_diverted_1501_2000$Year == '2006'] / data_1501_2000$Count[data_1501_2000$Year == '2006'],
               data_diverted_2001_2500$Count[data_diverted_2001_2500$Year == '2006'] / data_2001_2500$Count[data_2001_2500$Year == '2006'],
               data_diverted_2501_3000$Count[data_diverted_2501_3000$Year == '2006'] / data_2501_3000$Count[data_2501_3000$Year == '2006'],
               data_diverted_3001_3500$Count[data_diverted_3001_3500$Year == '2006'] / data_3001_3500$Count[data_3001_3500$Year == '2006'],
               data_diverted_3501_4000$Count[data_diverted_3501_4000$Year == '2006'] / data_3501_4000$Count[data_3501_4000$Year == '2006'],
               data_diverted_4001_4500$Count[data_diverted_4001_4500$Year == '2006'] / data_4001_4500$Count[data_4001_4500$Year == '2006'],
               data_diverted_4501_5000$Count[data_diverted_4501_5000$Year == '2006'] / data_4501_5000$Count[data_4501_5000$Year == '2006'])
data_2007 <- c(data_diverted_0_500$Count[data_diverted_0_500$Year == '2007'] / data_0_500$Count[data_0_500$Year == '2007'],
               data_diverted_501_1000$Count[data_diverted_501_1000$Year == '2007'] / data_501_1000$Count[data_501_1000$Year == '2007'],
               data_diverted_1001_1500$Count[data_diverted_1001_1500$Year == '2007'] / data_1001_1500$Count[data_1001_1500$Year == '2007'],
               data_diverted_1501_2000$Count[data_diverted_1501_2000$Year == '2007'] / data_1501_2000$Count[data_1501_2000$Year == '2007'],
               data_diverted_2001_2500$Count[data_diverted_2001_2500$Year == '2007'] / data_2001_2500$Count[data_2001_2500$Year == '2007'],
               data_diverted_2501_3000$Count[data_diverted_2501_3000$Year == '2007'] / data_2501_3000$Count[data_2501_3000$Year == '2007'],
               data_diverted_3001_3500$Count[data_diverted_3001_3500$Year == '2007'] / data_3001_3500$Count[data_3001_3500$Year == '2007'],
               data_diverted_3501_4000$Count[data_diverted_3501_4000$Year == '2007'] / data_3501_4000$Count[data_3501_4000$Year == '2007'],
               data_diverted_4001_4500$Count[data_diverted_4001_4500$Year == '2007'] / data_4001_4500$Count[data_4001_4500$Year == '2007'],
               data_diverted_4501_5000$Count[data_diverted_4501_5000$Year == '2007'] / data_4501_5000$Count[data_4501_5000$Year == '2007'])
data_2008 <- c(data_diverted_0_500$Count[data_diverted_0_500$Year == '2008'] / data_0_500$Count[data_0_500$Year == '2008'],
               data_diverted_501_1000$Count[data_diverted_501_1000$Year == '2008'] / data_501_1000$Count[data_501_1000$Year == '2008'],
               data_diverted_1001_1500$Count[data_diverted_1001_1500$Year == '2008'] / data_1001_1500$Count[data_1001_1500$Year == '2008'],
               data_diverted_1501_2000$Count[data_diverted_1501_2000$Year == '2008'] / data_1501_2000$Count[data_1501_2000$Year == '2008'],
               data_diverted_2001_2500$Count[data_diverted_2001_2500$Year == '2008'] / data_2001_2500$Count[data_2001_2500$Year == '2008'],
               data_diverted_2501_3000$Count[data_diverted_2501_3000$Year == '2008'] / data_2501_3000$Count[data_2501_3000$Year == '2008'],
               data_diverted_3001_3500$Count[data_diverted_3001_3500$Year == '2008'] / data_3001_3500$Count[data_3001_3500$Year == '2008'],
               data_diverted_3501_4000$Count[data_diverted_3501_4000$Year == '2008'] / data_3501_4000$Count[data_3501_4000$Year == '2008'],
               data_diverted_4001_4500$Count[data_diverted_4001_4500$Year == '2008'] / data_4001_4500$Count[data_4001_4500$Year == '2008'],
               data_diverted_4501_5000$Count[data_diverted_4501_5000$Year == '2008'] / data_4501_5000$Count[data_4501_5000$Year == '2008'])