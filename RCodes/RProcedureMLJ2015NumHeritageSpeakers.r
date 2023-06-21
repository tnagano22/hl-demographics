# clear the cache
rm(list = ls())

# set the current workd directly
#setwd("TO_YOUR_PATH")
setwd("~/Desktop")

# loading required packages (install with install.packages("xxxx") if the package is not installed)
library(ggplot2); library(gdata); library(xtable); library(gplots); library(foreign); library(ineq);

# loading the data file (full data might take a lot of time to load)
# update fileYear to 1980, 1990, 2000, or 2010  
fileYear="1980"
thisData <- drop.levels(as.data.frame(read.spss(paste("DATA_DOWNLOADED_FROM_IPUMS_SAMPLE",fileYear,".sav",sep=""))),reorder=FALSE)
summary(thisData)

# Creating new variables
# Wyoming is 51 and American Samoa (52), Guam (53), Puerto Rico (54), and Virgin Islands (55)
USStates <- c("Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","District of Columbia","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming","American Samoa","Guam","Puerto Rico")
thisData$USBorn <- thisData$BPL %in% USStates
thisData$AGE_ORIG <- thisData$AGE
thisData$AGE <- as.numeric(levels(thisData$AGE))[thisData$AGE]
thisData[is.na(thisData$AGE),"AGE"] <- 0	# "less than 1 year old"
thisData$ADULT <- thisData$AGE > 18
thisData$YRIMMIG_ORIG <- thisData$YRIMMIG
if (fileYear == "1980"){
	levels(thisData$YRIMMIG) <- c(NA,"1949","1959","1964","1969","1974","1980")
} else if (fileYear == "1990"){
	levels(thisData$YRIMMIG) <- c(NA,"1949","1959","1964","1969","1974","1979","1981","1984","1986","1990")
} else if (fileYear == "2000"){
	levels(thisData$YRIMMIG) <- c("N/A","1910","1914","1919","1920","1921","1922","1923","1924","1925","1926","1927","1928","1929","1930","1935","1936","1937","1938","1939","1940","1941","1942","1943","1944","1945","1946","1947","1948","1949","1950","1951","1952","1953","1954","1955","1956","1957","1958","1959","1960","1961","1962","1963","1964","1965","1966","1967","1968","1969","1970","1971","1972","1973","1974","1975","1976","1977","1978","1979","1980","1981","1982","1983","1984","1985","1986","1987","1988","1989","1990","1991","1992","1993","1994","1995","1996","1997","1998","1999","2000")
} else if (fileYear == "2010"){
	levels(thisData$YRIMMIG) <- c(NA,"1919","1920","1921","1922","1923","1924","1925","1926","1927","1928","1929","1930","1932","1934","1935","1936","1937","1938","1939","1940","1941","1942","1943","1944","1945","1946","1947","1948","1949","1950","1951","1952","1953","1954","1955","1956","1957","1958","1959","1960","1961","1962","1963","1964","1965","1966","1967","1968","1969","1970","1971","1972","1973","1974","1975","1976","1977","1978","1979","1980","1981","1982","1983","1984","1985","1986","1987","1988","1989","1990","1991","1992","1993","1994","1995","1996","1997","1998","1999","2000","2001","2002","2003","2004","2005","2006","2007","2008","2009","2010")
}


# Adult heritage language speakers based on the definition by Nagano (2015)
thisData$YRIMMIG <- as.numeric(levels(thisData$YRIMMIG))[thisData$YRIMMIG]
thisData$YRIMMIG <- as.numeric(fileYear)-as.numeric(thisData$YRIMMIG)
thisData$IMMIGADULT <- thisData$YRIMMIG > 18
thisData[is.na(thisData$IMMIGADULT),"IMMIGADULT"] <- FALSE
thisData$SPEAKENGWell <- thisData$SPEAKENG == "Yes, speaks very well" | thisData$SPEAKENG == "Yes, speaks well"
thisData$SPEAKNoENG <- thisData$SPEAKENG == "Does not speak English"
thisData$SPEAKHL <- !(thisData$LANGUAGE == "N/A or blank" | thisData$LANGUAGE == "English")


# checking states, counties, and CONSPUMA
length(levels(thisData$STATEFIP))
mean(xtabs(PERWT ~ STATEFIP, data=thisData))
sqrt(var(xtabs(PERWT ~ STATEFIP, data=thisData)))
length(levels(as.factor(thisData$COUNTY)))
mean(xtabs(PERWT ~ COUNTYICP, data=thisData))
sqrt(var(xtabs(PERWT ~ COUNTYICP, data=thisData)))

# HL conditions: age of 18 or above, speak a HL at home, not "Does not speak English", and not immigrated after 18
HLConditions <- thisData$ADULT==TRUE & thisData$SPEAKHL==TRUE & !thisData$SPEAKNoENG & !thisData$IMMIGADULT

# adult population
adultPopulation <- xtabs(PERWT ~ STATEFIP, data=thisData)
adultPopulation
write.csv(adultPopulation,,file=paste("Output00_TableAdultStatesPopulation",fileYear,".csv",sep=""))


# all people
sum(thisData[,"PERWT"])
# all people who speak HL at home
sum(thisData[thisData$SPEAKHL==TRUE,"PERWT"])
# all people who are HL according to my criteira
sum(thisData[HLConditions,"PERWT"])

# U.S. population by race
tableRace <- xtabs(PERWT ~ RACESING, data=thisData)
tableRace
write.csv(tableRace,file=paste("Output01_TableRace",fileYear,".csv",sep=""))

# U.S. Hispanic population
tableHipanics <- xtabs(PERWT ~ HISPAN, data=thisData)
tableHipanics
write.csv(tableHipanics,file=paste("Output02_TableRaceHispanic",fileYear,".csv",sep=""))

# Heritage language speakers by state
HLTableOrder = rev(order(colSums(xtabs(PERWT ~ STATEFIP + LANGUAGE, data=thisData[HLConditions,]))))
tableAllHLSpeakersState <- xtabs(PERWT ~ STATEFIP + LANGUAGE, data=thisData[thisData$SPEAKHL==TRUE,])
tableAllHLSpeakersState
write.csv(tableAllHLSpeakersState[,HLTableOrder],file=paste("Output03_TableAllHLSpeakersByState",fileYear,".csv",sep=""))

# Heritage language speakers by region
tableHLSpeakersRegion <- xtabs(PERWT ~ REGION + LANGUAGE, data=thisData[HLConditions,])
tableHLSpeakersRegion
write.csv(tableHLSpeakersRegion[,HLTableOrder],file=paste("Output04_TableHLSpeakersByRegion",fileYear,".csv",sep=""))

# Heritage language speakers by language and by state
tableHLSpeakersState <- xtabs(PERWT ~ STATEFIP + LANGUAGE, data=thisData[HLConditions,])
tableHLSpeakersState
write.csv(tableHLSpeakersState[,HLTableOrder],file=paste("Output05_TableHLSpeakersByState",fileYear,".csv",sep=""))

# Heritage language speakers by language and by PUMA
tableHLSpeakersCONSPUMA <- xtabs(PERWT ~ CONSPUMA + LANGUAGE, data=thisData[HLConditions,])
tableHLSpeakersCONSPUMA
write.csv(tableHLSpeakersCONSPUMA[,HLTableOrder],file=paste("Output06_TableHLSpeakersByCONSPUMA",fileYear,".csv",sep=""))

tableHLSpeakersSpeakMETRO <- xtabs(PERWT ~ METRO + LANGUAGE, data=thisData[HLConditions,])
tableHLSpeakersSpeakMETRO
write.csv(tableHLSpeakersSpeakMETRO[,HLTableOrder],file=paste("Output07_TableHLSpeakersByMetro",fileYear,".csv",sep=""))

sum(thisData[thisData$USBorn==FALSE,"PERWT"])/sum(thisData[,"PERWT"])

# calculating Gini index (create the CONSPUMA files and combined them into one single file first)
thisData <- drop.levels(as.data.frame(read.csv(paste("OutputXX_TableHLSpeakersByCONSPUMA.csv",sep=""))),reorder=FALSE)
stateOrder2010 <- colnames(thisData)
for (thisFileYear in c("1980","2000","2010")){
	thisData <- drop.levels(as.data.frame(read.table(paste("Output08_TableHLSpeakersByCONSPUMA",fileYear,".csv",sep=""))),reorder=FALSE)
	tempTable <- apply(thisData,2,Gini)
	write.csv(as.table(tempTable[stateOrder2010]),file=paste("Output09_TableHLSpeakersByCONSPUMA_Gini",thisFileYear,".csv",sep="")
}