RProcedureMLJ2015NumHeritageSpeakers
================
Tomonori Nagano
2015-12-31

# RProcedureMLJ2015NumHeritageSpeakers

- R scripts to analyze heritage language spakers in the U.S.

## Overview

- Project: Source codes for “Demographics of Adult Heritage Language
  Speakers in the United States: Differences by Region and Language and
  Their Implications” (The Modern Language Journal, vol. 99, No. 4)
  - Nagano, T. (2015). Demographics of Adult Heritage Language Speakers
    in the United States: Differences by Region and Language and their
    Implications. <i>The Modern Language Journal</i>, 99(4), 771-792.
- Script purpose: This R script will analyze the U.S. Census/ACE data
  and compute the number of adult heritage language speakers in the U.S.
  in different regions, at different time period (1980-2010), and by
  languages. See the following article for more information: Nagano, T.
  (2015). Demographics of Adult Heritage Language Speakers in the United
  States: Differences by Region and Language and their Implications. The
  Modern Language Journal, 99(4), 771-792.
- Note: Download the U.S. Census/ACE data from the IPUMS website
  <https://usa.ipums.org>.
  - For the published article, I used the following data:
    - 1980: 5% state
    - 1990: 5%
    - 2000: 5%
    - 2010: ACS
  - The variables to extract in each dataset are: YEAR, DATANUM, SERIAL,
    HHWT, REGION, STATEFIP, COUNTY, METRO, METAREA (general), METAREAD
    (detailed), CITY, CITYPOP, CONSPUMA, CNTRY, GQ, NFAMS, MULTGEN
    (general), MULTGEND (detailed), PERNUM, PERWT, FAMSIZE, NCHILD,
    NCHLT5, FAMUNIT, ELDCH, YNGCH, NSIBS, MOMLOC, POPLOC, SUBFAM, RELATE
    (general), RELATED (detailed), SEX, AGE, MARST, HISPAN (general),
    HISPAND (detailed), BPL (general), BPLD (detailed), ANCESTR1
    (general), ANCESTR1D (detailed), ANCESTR2 (general), ANCESTR2D
    (detailed), CITIZEN, YRIMMIG, YRSUSA1, YRSUSA2, LANGUAGE (general),
    LANGUAGED (detailed), SPEAKENG, RACESING (general), RACESINGD
    (detailed), EDUC (general), EDUCD (detailed), GRADEATT (general),
    GRADEATTD (detailed), OCC, IND, INCTOT, FTOTINC, POVERTY, OCCSCORE,
    and SEI
  - Download the data as SPSS file (which can be read by R). The full
    data (about 2G-3G) will be extremely large and you won’t be able to
    process them unless you have a very powerful computer. Use
    sampled/partial data with the “Customize Sample Size” function on
    IPUMS if necessary.
  - Screenshot of the IPUMS USA page (“Customize Sample Size”) ![IPUMS
    screenshot](https://github.com/tnagano22/hl-demographics/blob/main/images/IPUMSScreenshot.jpg?raw=true)

## Data

- In the “data” folder, you can find sample data from the IPUMS USA page
  (0.3%-0.5% data). They are all in the SPSS data format (.sav).
  Unarchive them and change their filenames accordingly. Please note
  that they are all tiny sample data and may not show exactly the same
  results as those in the published article (they should be very close,
  though.)
- For a complete analysis, go to the IPUMS USA
  (<https://usa.ipums.org/usa/>) and download the whole data files from
  their website.

## Setting up the environment

``` r
# clear the cache
rm(list = ls())

# set the current workd directly
setwd("~/Desktop")

# loading required packages (install with install.packages("xxxx") if the package is not installed)
library(ggplot2); library(gdata); library(xtable); library(gplots); library(foreign); library(ineq);
```

## Loading data

- Load the data. Run the script several times by changing the “fileYear”
  variable.

``` r
# loading the data file (full data might take a lot of time to load)
# update fileYear to 1980, 1990, 2000, or 2010  
fileYear="1980"
thisData <- drop.levels(as.data.frame(read.spss(paste("dataIPUMS2014/DATA_DOWNLOADED_FROM_IPUMS_SAMPLE",fileYear,".sav",sep=""))),reorder=FALSE)
```

    ## Warning in read.spss(paste("dataIPUMS2014/DATA_DOWNLOADED_FROM_IPUMS_SAMPLE", :
    ## Duplicated levels in factor RELATED: Other non-relatives,
    ## Roomers/boarders/lodgers, Relative of employee, Military

    ## Warning in read.spss(paste("dataIPUMS2014/DATA_DOWNLOADED_FROM_IPUMS_SAMPLE", :
    ## Duplicated levels in factor BPLD: Br. Virgin Islands, ns

    ## Warning in read.spss(paste("dataIPUMS2014/DATA_DOWNLOADED_FROM_IPUMS_SAMPLE", :
    ## Undeclared level(s) 422, 441 added in variable: ANCESTR1

``` r
head(thisData)
```

    ##   YEAR  SAMPLE SERIAL HHWT  CLUSTER           REGION STATEFIP COUNTYICP
    ## 1 1980 1980 5%      2  200 1.98e+12 Pacific Division   Alaska       200
    ## 2 1980 1980 5%      2  200 1.98e+12 Pacific Division   Alaska       200
    ## 3 1980 1980 5%     12  200 1.98e+12 Pacific Division   Alaska       200
    ## 4 1980 1980 5%     32  200 1.98e+12 Pacific Division   Alaska       200
    ## 5 1980 1980 5%     32  200 1.98e+12 Pacific Division   Alaska       200
    ## 6 1980 1980 5%     42  200 1.98e+12 Pacific Division   Alaska       200
    ##                                                                        METRO
    ## 1 In metropolitan area: Central/principal city status indeterminable (mixed)
    ## 2 In metropolitan area: Central/principal city status indeterminable (mixed)
    ## 3 In metropolitan area: Central/principal city status indeterminable (mixed)
    ## 4 In metropolitan area: Central/principal city status indeterminable (mixed)
    ## 5 In metropolitan area: Central/principal city status indeterminable (mixed)
    ## 6 In metropolitan area: Central/principal city status indeterminable (mixed)
    ##         METAREA      METAREAD          CITY CITYPOP STRATA CONSPUMA
    ## 1 Anchorage, AK Anchorage, AK Anchorage, AK    1744     24      540
    ## 2 Anchorage, AK Anchorage, AK Anchorage, AK    1744     24      540
    ## 3 Anchorage, AK Anchorage, AK Anchorage, AK    1744     27      540
    ## 4 Anchorage, AK Anchorage, AK Anchorage, AK    1744     25      540
    ## 5 Anchorage, AK Anchorage, AK Anchorage, AK    1744     25      540
    ## 6 Anchorage, AK Anchorage, AK Anchorage, AK    1744      7      540
    ##           CNTRY                               GQ           NFAMS      MULTGEN
    ## 1 United States Households under 1970 definition 1 family or N/A 1 generation
    ## 2 United States Households under 1970 definition 1 family or N/A 1 generation
    ## 3 United States Households under 1970 definition 1 family or N/A 1 generation
    ## 4 United States Households under 1970 definition 1 family or N/A 1 generation
    ## 5 United States Households under 1970 definition 1 family or N/A 1 generation
    ## 6 United States Households under 1970 definition 1 family or N/A 1 generation
    ##       MULTGEND PERNUM PERWT                                   FAMUNIT
    ## 1 1 generation      1   200 1st family in household or group quarters
    ## 2 1 generation      2   200 1st family in household or group quarters
    ## 3 1 generation      1   200 1st family in household or group quarters
    ## 4 1 generation      1   200 1st family in household or group quarters
    ## 5 1 generation      2   200 1st family in household or group quarters
    ## 6 1 generation      1   200 1st family in household or group quarters
    ##                    FAMSIZE                             SUBFAM MOMLOC POPLOC
    ## 1 2 family members present Group quarters or not in subfamily      0      0
    ## 2 2 family members present Group quarters or not in subfamily      0      0
    ## 3  1 family member present Group quarters or not in subfamily      0      0
    ## 4 2 family members present Group quarters or not in subfamily      0      0
    ## 5 2 family members present Group quarters or not in subfamily      0      0
    ## 6 2 family members present Group quarters or not in subfamily      0      0
    ##               NCHILD                  NCHLT5      NSIBS ELDCH YNGCH
    ## 1 0 children present No children under age 5 0 siblings   N/A   N/A
    ## 2 0 children present No children under age 5 0 siblings   N/A   N/A
    ## 3 0 children present No children under age 5 0 siblings   N/A   N/A
    ## 4 0 children present No children under age 5 0 siblings   N/A   N/A
    ## 5 0 children present No children under age 5 0 siblings   N/A   N/A
    ## 6 0 children present No children under age 5 0 siblings   N/A   N/A
    ##             RELATE          RELATED    SEX AGE                   MARST
    ## 1 Head/Householder Head/Householder Female  58 Married, spouse present
    ## 2           Spouse           Spouse   Male  59 Married, spouse present
    ## 3 Head/Householder Head/Householder   Male  42    Never married/single
    ## 4 Head/Householder Head/Householder   Male  24 Married, spouse present
    ## 5           Spouse           Spouse Female  24 Married, spouse present
    ## 6 Head/Householder Head/Householder   Male  37 Married, spouse present
    ##         HISPAN      HISPAND           BPL          BPLD
    ## 1 Not Hispanic Not Hispanic      Illinois      Illinois
    ## 2 Not Hispanic Not Hispanic      Illinois      Illinois
    ## 3 Not Hispanic Not Hispanic  South Dakota  South Dakota
    ## 4 Not Hispanic Not Hispanic      Virginia      Virginia
    ## 5 Not Hispanic Not Hispanic      Maryland      Maryland
    ## 6 Not Hispanic Not Hispanic West Virginia West Virginia
    ##                   ANCESTR1     ANCESTR1D     ANCESTR2     ANCESTR2D CITIZEN
    ## 1                   German German (1980)       French French (1980)     N/A
    ## 2                  English       English       German German (1980)     N/A
    ## 3                 American      American Not Reported  Not Reported     N/A
    ## 4                 Scottish      Scottish Not Reported  Not Reported     N/A
    ## 5 Irish, various subheads,         Irish Not Reported  Not Reported     N/A
    ## 6                  English       English Not Reported  Not Reported     N/A
    ##   YRIMMIG YRSUSA2 LANGUAGE LANGUAGED                 SPEAKENG
    ## 1     N/A     N/A  English   English Yes, speaks only English
    ## 2     N/A     N/A  English   English Yes, speaks only English
    ## 3     N/A     N/A  English   English Yes, speaks only English
    ## 4     N/A     N/A  English   English Yes, speaks only English
    ## 5     N/A     N/A  English   English Yes, speaks only English
    ## 6     N/A     N/A  English   English Yes, speaks only English
    ##                  EDUC                                EDUCD GRADEATT GRADEATTD
    ## 1            Grade 12                             Grade 12      N/A       N/A
    ## 2   1 year of college                    1 year of college      N/A       N/A
    ## 3 5+ years of college 6 years of college (6+ in 1960-1970)      N/A       N/A
    ## 4            Grade 12                             Grade 12      N/A       N/A
    ## 5            Grade 12                             Grade 12      N/A       N/A
    ## 6 5+ years of college 6 years of college (6+ in 1960-1970)      N/A       N/A
    ##   OCC IND INCTOT FTOTINC POVERTY OCCSCORE SEI RACESING RACESINGD
    ## 1 313 412  18310   21620     448       22  61    White     White
    ## 2 508 421   3310   21620     448       33  48    White     White
    ## 3 173 901  30005   30005     501       31  65    White     White
    ## 4   0   0   3970    8975     186       11  18    White     White
    ## 5   0   0   5005    8975     186       11  18    White     White
    ## 6   0   0  20310   23815     494       11  18    White     White

## Pre-processing/Clearning data

``` r
# Creating new variables
# Wyoming is 51 and American Samoa (52), Guam (53), Puerto Rico (54), and Virgin Islands (55)
USStates <- c("Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","District of Columbia","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming","American Samoa","Guam","Puerto Rico")
thisData$USBorn <- thisData$BPL %in% USStates
thisData$AGE_ORIG <- thisData$AGE
thisData$AGE <- as.numeric(levels(thisData$AGE))[thisData$AGE]
```

    ## Warning: NAs introduced by coercion

``` r
thisData[is.na(thisData$AGE),"AGE"] <- 0    # "less than 1 year old"
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
```

## Defining heritage speakers in the data and analyzing them by race, states, regions, and PUMA

- See the article for more discussion on how to define heritage speakers
  using the Census/ACS data.

``` r
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
```

    ## [1] 51

``` r
mean(xtabs(PERWT ~ STATEFIP, data=thisData))
```

    ## [1] 4452216

``` r
sqrt(var(xtabs(PERWT ~ STATEFIP, data=thisData)))
```

    ## [1] 4714314

``` r
length(levels(as.factor(thisData$COUNTY)))
```

    ## [1] 107

``` r
mean(xtabs(PERWT ~ COUNTYICP, data=thisData))
```

    ## [1] 2122084

``` r
sqrt(var(xtabs(PERWT ~ COUNTYICP, data=thisData)))
```

    ## [1] 9054487

``` r
# HL conditions: age of 18 or above, speak a HL at home, not "Does not speak English", and not immigrated after 18
HLConditions <- thisData$ADULT==TRUE & thisData$SPEAKHL==TRUE & !thisData$SPEAKNoENG & !thisData$IMMIGADULT

# adult population
adultPopulation <- xtabs(PERWT ~ STATEFIP, data=thisData)
head(adultPopulation)
```

    ## STATEFIP
    ##    Alabama     Alaska    Arizona   Arkansas California   Colorado 
    ##    3945600     412200    2726000    2275000   23750400    2883600

``` r
write.csv(adultPopulation,file=paste("Output00_TableAdultStatesPopulation",fileYear,".csv",sep=""))

# all people
sum(thisData[,"PERWT"])
```

    ## [1] 227063000

``` r
# all people who speak HL at home
sum(thisData[thisData$SPEAKHL==TRUE,"PERWT"])
```

    ## [1] 23813400

``` r
# all people who are HL according to my criteira
sum(thisData[HLConditions,"PERWT"])
```

    ## [1] 14071800

``` r
# U.S. population by race
tableRace <- xtabs(PERWT ~ RACESING, data=thisData)
head(tableRace)
```

    ## RACESING
    ##                         White                         Black 
    ##                     194825200                      26703800 
    ## American Indian/Alaska Native Asian and/or Pacific Islander 
    ##                       1553000                       3759600 
    ##      Other race, non-Hispanic 
    ##                        221400

``` r
write.csv(tableRace,file=paste("Output01_TableRace",fileYear,".csv",sep=""))

# U.S. Hispanic population
tableHipanics <- xtabs(PERWT ~ HISPAN, data=thisData)
head(tableHipanics)
```

    ## HISPAN
    ## Not Hispanic      Mexican Puerto Rican        Cuban        Other 
    ##    212335200      8757600      2036600       807800      3125800

``` r
write.csv(tableHipanics,file=paste("Output02_TableRaceHispanic",fileYear,".csv",sep=""))

# Heritage language speakers by state
HLTableOrder = rev(order(colSums(xtabs(PERWT ~ STATEFIP + LANGUAGE, data=thisData[HLConditions,]))))
tableAllHLSpeakersState <- xtabs(PERWT ~ STATEFIP + LANGUAGE, data=thisData[thisData$SPEAKHL==TRUE,])
head(tableAllHLSpeakersState)
```

    ##             LANGUAGE
    ## STATEFIP     N/A or blank English  German Yiddish, Jewish   Dutch Swedish
    ##   Alabama               0       0   11800             400    1600     200
    ##   Alaska                0       0    2400               0     400     200
    ##   Arizona               0       0   14000            1400    1600    1000
    ##   Arkansas              0       0    6200               0     800     200
    ##   California            0       0  175800           27800   39000   11400
    ##   Colorado              0       0   28800             800    1000     600
    ##             LANGUAGE
    ## STATEFIP      Danish Norwegian Icelandic Italian  French Spanish Portuguese
    ##   Alabama          0         0         0     800    8800   18400          0
    ##   Alaska           0      1200         0     200     800    3600        200
    ##   Arizona        200      1200         0    6400   12600  344800       1600
    ##   Arkansas         0         0         0    1000    5200   12000          0
    ##   California   11400      9800      1000  137800  104200 3248800      77800
    ##   Colorado       200      1200         0    5600   11600  181600        800
    ##             LANGUAGE
    ## STATEFIP     Rumanian  Celtic   Greek Albanian Russian
    ##   Alabama           0       0     800        0       0
    ##   Alaska            0     200       0        0    1600
    ##   Arizona           0       0    2000        0     400
    ##   Arkansas          0     200     600        0     600
    ##   California     3000    1600   40800      200   30400
    ##   Colorado          0       0    2800        0    1600
    ##             LANGUAGE
    ## STATEFIP     Ukrainian, Ruthenian, Little Russian   Czech  Polish  Slovak
    ##   Alabama                                       0       0       0     200
    ##   Alaska                                        0       0       0       0
    ##   Arizona                                     600     400    3000       0
    ##   Arkansas                                      0     400     600     400
    ##   California                                 7000    9600   22400    1200
    ##   Colorado                                    800    1800    3000     400
    ##             LANGUAGE
    ## STATEFIP     Serbo-Croatian, Yugoslavian, Slavonian Slovene Lithuanian
    ##   Alabama                                       400       0        200
    ##   Alaska                                          0       0          0
    ##   Arizona                                      2800       0       1000
    ##   Arkansas                                      200       0        200
    ##   California                                  16200    1200       7200
    ##   Colorado                                     3000     200        600
    ##             LANGUAGE
    ## STATEFIP     Other Balto-Slavic Armenian Persian, Iranian, Farsi
    ##   Alabama                     0        0                    1000
    ##   Alaska                      0        0                       0
    ##   Arizona                     0      200                     400
    ##   Arkansas                    0        0                     800
    ##   California               1000    57800                   32200
    ##   Colorado                    0      200                    1400
    ##             LANGUAGE
    ## STATEFIP     Other Persian dialects Hindi and related Romany, Gypsy Finnish
    ##   Alabama                         0              2800             0       0
    ##   Alaska                          0               400             0       0
    ##   Arizona                         0              2000             0     800
    ##   Arkansas                        0                 0             0       0
    ##   California                    200             46600           400    5800
    ##   Colorado                        0               400             0     400
    ##             LANGUAGE
    ## STATEFIP     Magyar, Hungarian  Uralic Turkish Other Altaic
    ##   Alabama                    0       0     200            0
    ##   Alaska                   600       0       0            0
    ##   Arizona                 1400     200     600            0
    ##   Arkansas                 400       0     400            0
    ##   California             21400    2400    3800          400
    ##   Colorado                2000     400       0            0
    ##             LANGUAGE
    ## STATEFIP     Caucasian, Georgian, Avar  Basque Dravidian  Kurukh Burushaski
    ##   Alabama                            0       0       400       0          0
    ##   Alaska                             0       0         0       0          0
    ##   Arizona                            0       0         0       0          0
    ##   Arkansas                           0       0         0       0          0
    ##   California                         0    1600      3000    1400          0
    ##   Colorado                           0       0       800       0          0
    ##             LANGUAGE
    ## STATEFIP     Chinese Tibetan Burmese, Lisu, Lolo Thai, Siamese, Lao Japanese
    ##   Alabama       1200       0                   0                400     1600
    ##   Alaska           0       0                   0                600     1800
    ##   Arizona       4000       0                   0                400     2200
    ##   Arkansas       400       0                   0                  0      600
    ##   California  272400    1600                2600              23800   122600
    ##   Colorado      3400       0                   0               1000     4400
    ##             LANGUAGE
    ## STATEFIP      Korean Vietnamese Other East/Southeast Asian Indonesian
    ##   Alabama       1000       1600                          0          0
    ##   Alaska        1400          0                          0          0
    ##   Arizona       3200        200                          0        200
    ##   Arkansas       800        800                          0          0
    ##   California   87800      67000                       3200       2400
    ##   Colorado      2600       1600                          0          0
    ##             LANGUAGE
    ## STATEFIP     Other Malayan Filipino, Tagalog Micronesian, Polynesian Hawaiian
    ##   Alabama                0                 0                       0      200
    ##   Alaska                 0               800                       0        0
    ##   Arizona                0              1400                     200        0
    ##   Arkansas               0               600                       0        0
    ##   California          6600            214400                   24200     1400
    ##   Colorado               0              1800                     400      200
    ##             LANGUAGE
    ## STATEFIP      Arabic Near East Arabic dialect Hebrew, Israeli
    ##   Alabama       1000                        0               0
    ##   Alaska         200                        0               0
    ##   Arizona       1600                        0               0
    ##   Arkansas      1600                        0               0
    ##   California   42800                     3400           16800
    ##   Colorado      3600                        0            1200
    ##             LANGUAGE
    ## STATEFIP     Amharic, Ethiopian, etc Hamitic Sub-Saharan Africa African, n.s
    ##   Alabama                          0       0                400            0
    ##   Alaska                           0       0                200            0
    ##   Arizona                        200       0                  0          200
    ##   Arkansas                         0       0                400          400
    ##   California                    1200    1200               5600          200
    ##   Colorado                       200     200               1400            0
    ##             LANGUAGE
    ## STATEFIP     American Indian (all) Other or not reported
    ##   Alabama                      600                  4600
    ##   Alaska                     29200                   200
    ##   Arizona                   108200                  2000
    ##   Arkansas                     800                  4000
    ##   California                 10600                 34000
    ##   Colorado                    1800                  2800

``` r
write.csv(tableAllHLSpeakersState[,HLTableOrder],file=paste("Output03_TableAllHLSpeakersByState",fileYear,".csv",sep=""))

# Heritage language speakers by region
tableHLSpeakersRegion <- xtabs(PERWT ~ REGION + LANGUAGE, data=thisData[HLConditions,])
head(tableHLSpeakersRegion)
```

    ##                           LANGUAGE
    ## REGION                     N/A or blank English  German Yiddish, Jewish   Dutch
    ##   New England Division                0       0   27800            6600    5200
    ##   Middle Atlantic Division            0       0  175200           90400    9600
    ##   East North Central Div              0       0  216000           13800   18000
    ##   West North Central Div              0       0  169800            1800    8400
    ##   South Atlantic Division             0       0   93600           25400    7600
    ##   East South Central Div              0       0   25600             400    1400
    ##                           LANGUAGE
    ## REGION                     Swedish  Danish Norwegian Icelandic Italian  French
    ##   New England Division        5400    1600      1200       200  137400  317800
    ##   Middle Atlantic Division    6400    3200      5400       600  502400  146200
    ##   East North Central Div     11200    3200     11600       600  121400   81800
    ##   West North Central Div     17200    4200     41400       600   17400   29600
    ##   South Atlantic Division     4200    2400      2200       400   71600  140400
    ##   East South Central Div       200       0         0         0    5800   31000
    ##                           LANGUAGE
    ## REGION                     Spanish Portuguese Rumanian  Celtic   Greek Albanian
    ##   New England Division      134400     106800     1200    1800   30000     2400
    ##   Middle Atlantic Division 1154200      32800     3400    4800   71000     3600
    ##   East North Central Div    468800       2600     5600    2200   52000     1800
    ##   West North Central Div     97400       1200        0    1200    3200        0
    ##   South Atlantic Division   622800       9400      800    2800   29200      200
    ##   East South Central Div     51200        400        0     400    3000        0
    ##                           LANGUAGE
    ## REGION                     Russian Ukrainian, Ruthenian, Little Russian   Czech
    ##   New England Division        2400                                 2600    1400
    ##   Middle Atlantic Division   39400                                26800   12400
    ##   East North Central Div     14000                                 9800   19600
    ##   West North Central Div      2200                                  400   26000
    ##   South Atlantic Division     6000                                 2800    3600
    ##   East South Central Div       400                                    0       0
    ##                           LANGUAGE
    ## REGION                      Polish  Slovak
    ##   New England Division       71200    2200
    ##   Middle Atlantic Division  227200   34600
    ##   East North Central Div    221200   22000
    ##   West North Central Div     13400     800
    ##   South Atlantic Division    29800    3400
    ##   East South Central Div      1400     600
    ##                           LANGUAGE
    ## REGION                     Serbo-Croatian, Yugoslavian, Slavonian Slovene
    ##   New England Division                                       1600     400
    ##   Middle Atlantic Division                                  30600    2400
    ##   East North Central Div                                    39400    6000
    ##   West North Central Div                                     4200     200
    ##   South Atlantic Division                                    4200     800
    ##   East South Central Div                                      400     200
    ##                           LANGUAGE
    ## REGION                     Lithuanian Other Balto-Slavic Armenian
    ##   New England Division          13800                  0     8800
    ##   Middle Atlantic Division      13000               2000    10000
    ##   East North Central Div        12200               4000     3800
    ##   West North Central Div         1000                  0      200
    ##   South Atlantic Division        3200                  0     3800
    ##   East South Central Div          400                400      400
    ##                           LANGUAGE
    ## REGION                     Persian, Iranian, Farsi Other Persian dialects
    ##   New England Division                        4200                      0
    ##   Middle Atlantic Division                    5800                    200
    ##   East North Central Div                     10200                      0
    ##   West North Central Div                      5400                    200
    ##   South Atlantic Division                    10800                   1000
    ##   East South Central Div                      2000                    200
    ##                           LANGUAGE
    ## REGION                     Hindi and related Romany, Gypsy Finnish
    ##   New England Division                  4000             0    4200
    ##   Middle Atlantic Division             44200           600    2400
    ##   East North Central Div               34600           800   17000
    ##   West North Central Div                7800             0   13200
    ##   South Atlantic Division              20200             0    3200
    ##   East South Central Div                3400             0       0
    ##                           LANGUAGE
    ## REGION                     Magyar, Hungarian  Uralic Turkish Other Altaic
    ##   New England Division                  7200       0    1200          400
    ##   Middle Atlantic Division             31600       0    8600            0
    ##   East North Central Div               24800     200    2400          400
    ##   West North Central Div                1600       0     200          400
    ##   South Atlantic Division               9400       0    2200            0
    ##   East South Central Div                 600       0     600          200
    ##                           LANGUAGE
    ## REGION                     Caucasian, Georgian, Avar  Basque Dravidian  Kurukh
    ##   New England Division                             0       0      1800     200
    ##   Middle Atlantic Division                       200       0      9400       0
    ##   East North Central Div                         200       0      5200       0
    ##   West North Central Div                           0       0      2400       0
    ##   South Atlantic Division                          0       0      2400     400
    ##   East South Central Div                           0       0       200       0
    ##                           LANGUAGE
    ## REGION                     Burushaski Chinese Tibetan Burmese, Lisu, Lolo
    ##   New England Division              0   18600     200                   0
    ##   Middle Atlantic Division          0   89800    1000                   0
    ##   East North Central Div            0   30000    2000                   0
    ##   West North Central Div            0   10800     400                 200
    ##   South Atlantic Division           0   26000     600                 800
    ##   East South Central Div            0    3000     200                   0
    ##                           LANGUAGE
    ## REGION                     Thai, Siamese, Lao Japanese  Korean Vietnamese
    ##   New England Division                   1200     3200    4000       2200
    ##   Middle Atlantic Division               7800    20800   32800       8600
    ##   East North Central Div                 9000    14400   23800       5400
    ##   West North Central Div                 3200     6000    6200       9400
    ##   South Atlantic Division                6600     9800   28000      12600
    ##   East South Central Div                 1600     2800    5200       4400
    ##                           LANGUAGE
    ## REGION                     Other East/Southeast Asian Indonesian Other Malayan
    ##   New England Division                              0        400           800
    ##   Middle Atlantic Division                        200       1600           800
    ##   East North Central Div                          800       1800          1600
    ##   West North Central Div                            0        800           400
    ##   South Atlantic Division                         600        400             0
    ##   East South Central Div                            0        200           400
    ##                           LANGUAGE
    ## REGION                     Filipino, Tagalog Micronesian, Polynesian Hawaiian
    ##   New England Division                  3200                     600      200
    ##   Middle Atlantic Division             34000                    1200      600
    ##   East North Central Div               32000                    1200      400
    ##   West North Central Div                5000                     600        0
    ##   South Atlantic Division              27600                    2200        0
    ##   East South Central Div                2400                     400      200
    ##                           LANGUAGE
    ## REGION                      Arabic Near East Arabic dialect Hebrew, Israeli
    ##   New England Division        9000                      200            6200
    ##   Middle Atlantic Division   30600                      600           28000
    ##   East North Central Div     33800                     2200            4000
    ##   West North Central Div      5400                        0            1000
    ##   South Atlantic Division    15400                      200            5600
    ##   East South Central Div      3400                        0             800
    ##                           LANGUAGE
    ## REGION                     Amharic, Ethiopian, etc Hamitic Sub-Saharan Africa
    ##   New England Division                         200       0               1600
    ##   Middle Atlantic Division                     400     800               9000
    ##   East North Central Div                      4000     400               5600
    ##   West North Central Div                       400       0               3000
    ##   South Atlantic Division                     1200     800               6200
    ##   East South Central Div                         0       0                800
    ##                           LANGUAGE
    ## REGION                     African, n.s American Indian (all)
    ##   New England Division              200                  2800
    ##   Middle Atlantic Division         1000                  6000
    ##   East North Central Div            600                  8000
    ##   West North Central Div            800                 18800
    ##   South Atlantic Division           200                  6200
    ##   East South Central Div              0                  4000
    ##                           LANGUAGE
    ## REGION                     Other or not reported
    ##   New England Division                      9800
    ##   Middle Atlantic Division                 27200
    ##   East North Central Div                   33400
    ##   West North Central Div                   11400
    ##   South Atlantic Division                  32600
    ##   East South Central Div                   10000

``` r
write.csv(tableHLSpeakersRegion[,HLTableOrder],file=paste("Output04_TableHLSpeakersByRegion",fileYear,".csv",sep=""))

# Heritage language speakers by language and by state
tableHLSpeakersState <- xtabs(PERWT ~ STATEFIP + LANGUAGE, data=thisData[HLConditions,])
head(tableHLSpeakersState)
```

    ##             LANGUAGE
    ## STATEFIP     N/A or blank English  German Yiddish, Jewish   Dutch Swedish
    ##   Alabama               0       0    7400             200     800     200
    ##   Alaska                0       0    1800               0     400       0
    ##   Arizona               0       0    9800            1000     800     600
    ##   Arkansas              0       0    4000               0     400     200
    ##   California            0       0   96200           13600   19400    6400
    ##   Colorado              0       0   15800             200    1000     400
    ##             LANGUAGE
    ## STATEFIP      Danish Norwegian Icelandic Italian  French Spanish Portuguese
    ##   Alabama          0         0         0     400    5800   13200          0
    ##   Alaska           0         0         0     200     600    3200        200
    ##   Arizona          0       600         0    3600    8200  198400       1000
    ##   Arkansas         0         0         0    1000    3600    7600          0
    ##   California    5200      5000      1000   81000   70400 1701400      44800
    ##   Colorado       200       800         0    4400    7800  134800        600
    ##             LANGUAGE
    ## STATEFIP     Rumanian  Celtic   Greek Albanian Russian
    ##   Alabama           0       0     600        0       0
    ##   Alaska            0     200       0        0     600
    ##   Arizona           0       0    1400        0     200
    ##   Arkansas          0     200     400        0       0
    ##   California     2200     400   24000      200   12600
    ##   Colorado          0       0    1800        0     600
    ##             LANGUAGE
    ## STATEFIP     Ukrainian, Ruthenian, Little Russian   Czech  Polish  Slovak
    ##   Alabama                                       0       0       0     200
    ##   Alaska                                        0       0       0       0
    ##   Arizona                                     200       0    2400       0
    ##   Arkansas                                      0     200     200     200
    ##   California                                 2400    5200   13400     800
    ##   Colorado                                    400    1600    1400     400
    ##             LANGUAGE
    ## STATEFIP     Serbo-Croatian, Yugoslavian, Slavonian Slovene Lithuanian
    ##   Alabama                                       200       0        200
    ##   Alaska                                          0       0          0
    ##   Arizona                                       800       0       1000
    ##   Arkansas                                        0       0        200
    ##   California                                   9200     200       1800
    ##   Colorado                                     1600     200        200
    ##             LANGUAGE
    ## STATEFIP     Other Balto-Slavic Armenian Persian, Iranian, Farsi
    ##   Alabama                     0        0                     600
    ##   Alaska                      0        0                       0
    ##   Arizona                     0      200                     200
    ##   Arkansas                    0        0                     800
    ##   California                400    35800                   23000
    ##   Colorado                    0      200                    1200
    ##             LANGUAGE
    ## STATEFIP     Other Persian dialects Hindi and related Romany, Gypsy Finnish
    ##   Alabama                         0              1800             0       0
    ##   Alaska                          0               400             0       0
    ##   Arizona                         0              1400             0     600
    ##   Arkansas                        0                 0             0       0
    ##   California                      0             30000           400    4200
    ##   Colorado                        0               400             0     200
    ##             LANGUAGE
    ## STATEFIP     Magyar, Hungarian  Uralic Turkish Other Altaic
    ##   Alabama                    0       0     200            0
    ##   Alaska                   400       0       0            0
    ##   Arizona                 1200     200     400            0
    ##   Arkansas                 200       0     200            0
    ##   California              9200     400    2600          400
    ##   Colorado                1000       0       0            0
    ##             LANGUAGE
    ## STATEFIP     Caucasian, Georgian, Avar  Basque Dravidian  Kurukh Burushaski
    ##   Alabama                            0       0       200       0          0
    ##   Alaska                             0       0         0       0          0
    ##   Arizona                            0       0         0       0          0
    ##   Arkansas                           0       0         0       0          0
    ##   California                         0    1600      3000     800          0
    ##   Colorado                           0       0       400       0          0
    ##             LANGUAGE
    ## STATEFIP     Chinese Tibetan Burmese, Lisu, Lolo Thai, Siamese, Lao Japanese
    ##   Alabama        400       0                   0                400     1000
    ##   Alaska           0       0                   0                600     1600
    ##   Arizona       2000       0                   0                200     2000
    ##   Arkansas       200       0                   0                  0      600
    ##   California  156000     800                2000              14400    84000
    ##   Colorado      2000       0                   0                200     2600
    ##             LANGUAGE
    ## STATEFIP      Korean Vietnamese Other East/Southeast Asian Indonesian
    ##   Alabama        800        800                          0          0
    ##   Alaska        1200          0                          0          0
    ##   Arizona       1800          0                          0        200
    ##   Arkansas       600        800                          0          0
    ##   California   57000      37200                       2000       1400
    ##   Colorado      2400       1400                          0          0
    ##             LANGUAGE
    ## STATEFIP     Other Malayan Filipino, Tagalog Micronesian, Polynesian Hawaiian
    ##   Alabama                0                 0                       0      200
    ##   Alaska                 0               600                       0        0
    ##   Arizona                0               400                     200        0
    ##   Arkansas               0               400                       0        0
    ##   California          3800            149600                   16000     1400
    ##   Colorado               0               800                     400      200
    ##             LANGUAGE
    ## STATEFIP      Arabic Near East Arabic dialect Hebrew, Israeli
    ##   Alabama       1000                        0               0
    ##   Alaska         200                        0               0
    ##   Arizona       1200                        0               0
    ##   Arkansas      1000                        0               0
    ##   California   28400                     2200           10400
    ##   Colorado      3000                        0            1000
    ##             LANGUAGE
    ## STATEFIP     Amharic, Ethiopian, etc Hamitic Sub-Saharan Africa African, n.s
    ##   Alabama                          0       0                400            0
    ##   Alaska                           0       0                200            0
    ##   Arizona                        200       0                  0          200
    ##   Arkansas                         0       0                400          200
    ##   California                    1200    1000               3800          200
    ##   Colorado                       200       0                800            0
    ##             LANGUAGE
    ## STATEFIP     American Indian (all) Other or not reported
    ##   Alabama                      600                  1000
    ##   Alaska                     20200                     0
    ##   Arizona                    58200                  1400
    ##   Arkansas                     400                  2600
    ##   California                  8000                 19200
    ##   Colorado                    1200                  2000

``` r
write.csv(tableHLSpeakersState[,HLTableOrder],file=paste("Output05_TableHLSpeakersByState",fileYear,".csv",sep=""))

# Heritage language speakers by language and by PUMA
tableHLSpeakersCONSPUMA <- xtabs(PERWT ~ CONSPUMA + LANGUAGE, data=thisData[HLConditions,])
head(tableHLSpeakersCONSPUMA)
```

    ##         LANGUAGE
    ## CONSPUMA N/A or blank English German Yiddish, Jewish Dutch Swedish Danish
    ##        1            0       0   1600               0   200       0      0
    ##        2            0       0    800               0     0       0      0
    ##        3            0       0      0               0     0       0      0
    ##        4            0       0    600               0     0     200      0
    ##        5            0       0   4400             200   600       0      0
    ##        6            0       0    400               0     0       0      0
    ##         LANGUAGE
    ## CONSPUMA Norwegian Icelandic Italian French Spanish Portuguese Rumanian Celtic
    ##        1         0         0       0    400    1600          0        0      0
    ##        2         0         0       0    600     600          0        0      0
    ##        3         0         0       0      0     400          0        0      0
    ##        4         0         0       0    800    2800          0        0      0
    ##        5         0         0     400   4000    7800          0        0      0
    ##        6         0         0       0    200    2400          0        0      0
    ##         LANGUAGE
    ## CONSPUMA Greek Albanian Russian Ukrainian, Ruthenian, Little Russian Czech
    ##        1     0        0       0                                    0     0
    ##        2     0        0       0                                    0     0
    ##        3     0        0       0                                    0     0
    ##        4   200        0       0                                    0     0
    ##        5   400        0       0                                    0     0
    ##        6     0        0       0                                    0     0
    ##         LANGUAGE
    ## CONSPUMA Polish Slovak Serbo-Croatian, Yugoslavian, Slavonian Slovene
    ##        1      0      0                                      0       0
    ##        2      0      0                                      0       0
    ##        3      0      0                                      0       0
    ##        4      0    200                                      0       0
    ##        5      0      0                                    200       0
    ##        6      0      0                                      0       0
    ##         LANGUAGE
    ## CONSPUMA Lithuanian Other Balto-Slavic Armenian Persian, Iranian, Farsi
    ##        1          0                  0        0                     400
    ##        2          0                  0        0                       0
    ##        3          0                  0        0                       0
    ##        4          0                  0        0                       0
    ##        5        200                  0        0                     200
    ##        6          0                  0        0                       0
    ##         LANGUAGE
    ## CONSPUMA Other Persian dialects Hindi and related Romany, Gypsy Finnish
    ##        1                      0                 0             0       0
    ##        2                      0               200             0       0
    ##        3                      0                 0             0       0
    ##        4                      0               400             0       0
    ##        5                      0              1200             0       0
    ##        6                      0                 0             0       0
    ##         LANGUAGE
    ## CONSPUMA Magyar, Hungarian Uralic Turkish Other Altaic
    ##        1                 0      0       0            0
    ##        2                 0      0       0            0
    ##        3                 0      0       0            0
    ##        4                 0      0       0            0
    ##        5                 0      0     200            0
    ##        6                 0      0       0            0
    ##         LANGUAGE
    ## CONSPUMA Caucasian, Georgian, Avar Basque Dravidian Kurukh Burushaski Chinese
    ##        1                         0      0         0      0          0       0
    ##        2                         0      0         0      0          0       0
    ##        3                         0      0         0      0          0     200
    ##        4                         0      0         0      0          0       0
    ##        5                         0      0       200      0          0     200
    ##        6                         0      0         0      0          0       0
    ##         LANGUAGE
    ## CONSPUMA Tibetan Burmese, Lisu, Lolo Thai, Siamese, Lao Japanese Korean
    ##        1       0                   0                200        0      0
    ##        2       0                   0                  0        0      0
    ##        3       0                   0                  0        0    200
    ##        4       0                   0                  0        0    400
    ##        5       0                   0                200     1000    200
    ##        6       0                   0                  0        0      0
    ##         LANGUAGE
    ## CONSPUMA Vietnamese Other East/Southeast Asian Indonesian Other Malayan
    ##        1        600                          0          0             0
    ##        2          0                          0          0             0
    ##        3          0                          0          0             0
    ##        4          0                          0          0             0
    ##        5        200                          0          0             0
    ##        6          0                          0          0             0
    ##         LANGUAGE
    ## CONSPUMA Filipino, Tagalog Micronesian, Polynesian Hawaiian Arabic
    ##        1                 0                       0      200    400
    ##        2                 0                       0        0    400
    ##        3                 0                       0        0      0
    ##        4                 0                       0        0      0
    ##        5                 0                       0        0    200
    ##        6                 0                       0        0      0
    ##         LANGUAGE
    ## CONSPUMA Near East Arabic dialect Hebrew, Israeli Amharic, Ethiopian, etc
    ##        1                        0               0                       0
    ##        2                        0               0                       0
    ##        3                        0               0                       0
    ##        4                        0               0                       0
    ##        5                        0               0                       0
    ##        6                        0               0                       0
    ##         LANGUAGE
    ## CONSPUMA Hamitic Sub-Saharan Africa African, n.s American Indian (all)
    ##        1       0                  0            0                   200
    ##        2       0                  0            0                     0
    ##        3       0                  0            0                     0
    ##        4       0                200            0                     0
    ##        5       0                200            0                   400
    ##        6       0                  0            0                 28600
    ##         LANGUAGE
    ## CONSPUMA Other or not reported
    ##        1                     0
    ##        2                     0
    ##        3                     0
    ##        4                   600
    ##        5                   400
    ##        6                     0

``` r
write.csv(tableHLSpeakersCONSPUMA[,HLTableOrder],file=paste("Output06_TableHLSpeakersByCONSPUMA",fileYear,".csv",sep=""))

tableHLSpeakersSpeakMETRO <- xtabs(PERWT ~ METRO + LANGUAGE, data=thisData[HLConditions,])
head(tableHLSpeakersSpeakMETRO)
```

    ##                                                                             LANGUAGE
    ## METRO                                                                        N/A or blank
    ##   Metropolitan status indeterminable (mixed)                                            0
    ##   Not in metropolitan area                                                              0
    ##   In metropolitan area: In central/principal city                                       0
    ##   In metropolitan area: Not in central/principal city                                   0
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)            0
    ##                                                                             LANGUAGE
    ## METRO                                                                        English
    ##   Metropolitan status indeterminable (mixed)                                       0
    ##   Not in metropolitan area                                                         0
    ##   In metropolitan area: In central/principal city                                  0
    ##   In metropolitan area: Not in central/principal city                              0
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)       0
    ##                                                                             LANGUAGE
    ## METRO                                                                         German
    ##   Metropolitan status indeterminable (mixed)                                  124400
    ##   Not in metropolitan area                                                    241000
    ##   In metropolitan area: In central/principal city                             159000
    ##   In metropolitan area: Not in central/principal city                         298600
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)  162000
    ##                                                                             LANGUAGE
    ## METRO                                                                        Yiddish, Jewish
    ##   Metropolitan status indeterminable (mixed)                                            1600
    ##   Not in metropolitan area                                                              2600
    ##   In metropolitan area: In central/principal city                                      85200
    ##   In metropolitan area: Not in central/principal city                                  57200
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)            9000
    ##                                                                             LANGUAGE
    ## METRO                                                                          Dutch
    ##   Metropolitan status indeterminable (mixed)                                    7000
    ##   Not in metropolitan area                                                     17200
    ##   In metropolitan area: In central/principal city                              10800
    ##   In metropolitan area: Not in central/principal city                          31200
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)   17200
    ##                                                                             LANGUAGE
    ## METRO                                                                        Swedish
    ##   Metropolitan status indeterminable (mixed)                                   10000
    ##   Not in metropolitan area                                                     13000
    ##   In metropolitan area: In central/principal city                              13600
    ##   In metropolitan area: Not in central/principal city                          17200
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)    7000
    ##                                                                             LANGUAGE
    ## METRO                                                                         Danish
    ##   Metropolitan status indeterminable (mixed)                                    1200
    ##   Not in metropolitan area                                                      5800
    ##   In metropolitan area: In central/principal city                               3800
    ##   In metropolitan area: Not in central/principal city                           7800
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)    5400
    ##                                                                             LANGUAGE
    ## METRO                                                                        Norwegian
    ##   Metropolitan status indeterminable (mixed)                                     26200
    ##   Not in metropolitan area                                                       20800
    ##   In metropolitan area: In central/principal city                                 9400
    ##   In metropolitan area: Not in central/principal city                            15200
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)      7600
    ##                                                                             LANGUAGE
    ## METRO                                                                        Icelandic
    ##   Metropolitan status indeterminable (mixed)                                       600
    ##   Not in metropolitan area                                                         600
    ##   In metropolitan area: In central/principal city                                 1400
    ##   In metropolitan area: Not in central/principal city                             1200
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)       800
    ##                                                                             LANGUAGE
    ## METRO                                                                        Italian
    ##   Metropolitan status indeterminable (mixed)                                   53800
    ##   Not in metropolitan area                                                     51400
    ##   In metropolitan area: In central/principal city                             354000
    ##   In metropolitan area: Not in central/principal city                         409800
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)  112400
    ##                                                                             LANGUAGE
    ## METRO                                                                         French
    ##   Metropolitan status indeterminable (mixed)                                  193600
    ##   Not in metropolitan area                                                    261200
    ##   In metropolitan area: In central/principal city                             236000
    ##   In metropolitan area: Not in central/principal city                         248200
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)  222600
    ##                                                                             LANGUAGE
    ## METRO                                                                        Spanish
    ##   Metropolitan status indeterminable (mixed)                                  438400
    ##   Not in metropolitan area                                                    621200
    ##   In metropolitan area: In central/principal city                            2581400
    ##   In metropolitan area: Not in central/principal city                        1753000
    ##   In metropolitan area: Central/principal city status indeterminable (mixed) 1043400
    ##                                                                             LANGUAGE
    ## METRO                                                                        Portuguese
    ##   Metropolitan status indeterminable (mixed)                                      25000
    ##   Not in metropolitan area                                                        16600
    ##   In metropolitan area: In central/principal city                                 42400
    ##   In metropolitan area: Not in central/principal city                             57200
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)      65200
    ##                                                                             LANGUAGE
    ## METRO                                                                        Rumanian
    ##   Metropolitan status indeterminable (mixed)                                      200
    ##   Not in metropolitan area                                                          0
    ##   In metropolitan area: In central/principal city                                8200
    ##   In metropolitan area: Not in central/principal city                            4200
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)     1200
    ##                                                                             LANGUAGE
    ## METRO                                                                         Celtic
    ##   Metropolitan status indeterminable (mixed)                                    2600
    ##   Not in metropolitan area                                                      2800
    ##   In metropolitan area: In central/principal city                               3800
    ##   In metropolitan area: Not in central/principal city                           5000
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)    1800
    ##                                                                             LANGUAGE
    ## METRO                                                                          Greek
    ##   Metropolitan status indeterminable (mixed)                                   11400
    ##   Not in metropolitan area                                                      7400
    ##   In metropolitan area: In central/principal city                              98000
    ##   In metropolitan area: Not in central/principal city                          84800
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)   26400
    ##                                                                             LANGUAGE
    ## METRO                                                                        Albanian
    ##   Metropolitan status indeterminable (mixed)                                     1000
    ##   Not in metropolitan area                                                          0
    ##   In metropolitan area: In central/principal city                                4200
    ##   In metropolitan area: Not in central/principal city                            2800
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)      200
    ##                                                                             LANGUAGE
    ## METRO                                                                        Russian
    ##   Metropolitan status indeterminable (mixed)                                    2400
    ##   Not in metropolitan area                                                      3800
    ##   In metropolitan area: In central/principal city                              43200
    ##   In metropolitan area: Not in central/principal city                          27000
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)    9800
    ##                                                                             LANGUAGE
    ## METRO                                                                        Ukrainian, Ruthenian, Little Russian
    ##   Metropolitan status indeterminable (mixed)                                                                 3200
    ##   Not in metropolitan area                                                                                   2600
    ##   In metropolitan area: In central/principal city                                                           12000
    ##   In metropolitan area: Not in central/principal city                                                       22400
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)                                 7400
    ##                                                                             LANGUAGE
    ## METRO                                                                          Czech
    ##   Metropolitan status indeterminable (mixed)                                   11200
    ##   Not in metropolitan area                                                     29400
    ##   In metropolitan area: In central/principal city                              14400
    ##   In metropolitan area: Not in central/principal city                          24400
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)   19200
    ##                                                                             LANGUAGE
    ## METRO                                                                         Polish
    ##   Metropolitan status indeterminable (mixed)                                   41800
    ##   Not in metropolitan area                                                     48800
    ##   In metropolitan area: In central/principal city                             199800
    ##   In metropolitan area: Not in central/principal city                         230600
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)   78600
    ##                                                                             LANGUAGE
    ## METRO                                                                         Slovak
    ##   Metropolitan status indeterminable (mixed)                                    5600
    ##   Not in metropolitan area                                                      7200
    ##   In metropolitan area: In central/principal city                              10800
    ##   In metropolitan area: Not in central/principal city                          29200
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)   13000
    ##                                                                             LANGUAGE
    ## METRO                                                                        Serbo-Croatian, Yugoslavian, Slavonian
    ##   Metropolitan status indeterminable (mixed)                                                                   3400
    ##   Not in metropolitan area                                                                                     5000
    ##   In metropolitan area: In central/principal city                                                             38000
    ##   In metropolitan area: Not in central/principal city                                                         42000
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)                                   8600
    ##                                                                             LANGUAGE
    ## METRO                                                                        Slovene
    ##   Metropolitan status indeterminable (mixed)                                    1000
    ##   Not in metropolitan area                                                       800
    ##   In metropolitan area: In central/principal city                               2600
    ##   In metropolitan area: Not in central/principal city                           5600
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)    1000
    ##                                                                             LANGUAGE
    ## METRO                                                                        Lithuanian
    ##   Metropolitan status indeterminable (mixed)                                       5200
    ##   Not in metropolitan area                                                         2800
    ##   In metropolitan area: In central/principal city                                 18800
    ##   In metropolitan area: Not in central/principal city                             15000
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)       6200
    ##                                                                             LANGUAGE
    ## METRO                                                                        Other Balto-Slavic
    ##   Metropolitan status indeterminable (mixed)                                                600
    ##   Not in metropolitan area                                                                  400
    ##   In metropolitan area: In central/principal city                                          2400
    ##   In metropolitan area: Not in central/principal city                                      2200
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)               1200
    ##                                                                             LANGUAGE
    ## METRO                                                                        Armenian
    ##   Metropolitan status indeterminable (mixed)                                     2400
    ##   Not in metropolitan area                                                       1200
    ##   In metropolitan area: In central/principal city                               33600
    ##   In metropolitan area: Not in central/principal city                           23200
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)     4200
    ##                                                                             LANGUAGE
    ## METRO                                                                        Persian, Iranian, Farsi
    ##   Metropolitan status indeterminable (mixed)                                                    4400
    ##   Not in metropolitan area                                                                      5000
    ##   In metropolitan area: In central/principal city                                              30800
    ##   In metropolitan area: Not in central/principal city                                          27600
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)                    9800
    ##                                                                             LANGUAGE
    ## METRO                                                                        Other Persian dialects
    ##   Metropolitan status indeterminable (mixed)                                                      0
    ##   Not in metropolitan area                                                                      400
    ##   In metropolitan area: In central/principal city                                               400
    ##   In metropolitan area: Not in central/principal city                                          1000
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)                      0
    ##                                                                             LANGUAGE
    ## METRO                                                                        Hindi and related
    ##   Metropolitan status indeterminable (mixed)                                              5000
    ##   Not in metropolitan area                                                                6600
    ##   In metropolitan area: In central/principal city                                        56200
    ##   In metropolitan area: Not in central/principal city                                    77600
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)             20000
    ##                                                                             LANGUAGE
    ## METRO                                                                        Romany, Gypsy
    ##   Metropolitan status indeterminable (mixed)                                             0
    ##   Not in metropolitan area                                                               0
    ##   In metropolitan area: In central/principal city                                      800
    ##   In metropolitan area: Not in central/principal city                                 1400
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)             0
    ##                                                                             LANGUAGE
    ## METRO                                                                        Finnish
    ##   Metropolitan status indeterminable (mixed)                                    7600
    ##   Not in metropolitan area                                                     19800
    ##   In metropolitan area: In central/principal city                               8000
    ##   In metropolitan area: Not in central/principal city                          13200
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)    3800
    ##                                                                             LANGUAGE
    ## METRO                                                                        Magyar, Hungarian
    ##   Metropolitan status indeterminable (mixed)                                              4800
    ##   Not in metropolitan area                                                                7000
    ##   In metropolitan area: In central/principal city                                        27200
    ##   In metropolitan area: Not in central/principal city                                    38400
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)             13400
    ##                                                                             LANGUAGE
    ## METRO                                                                         Uralic
    ##   Metropolitan status indeterminable (mixed)                                       0
    ##   Not in metropolitan area                                                       200
    ##   In metropolitan area: In central/principal city                                400
    ##   In metropolitan area: Not in central/principal city                            200
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)       0
    ##                                                                             LANGUAGE
    ## METRO                                                                        Turkish
    ##   Metropolitan status indeterminable (mixed)                                     200
    ##   Not in metropolitan area                                                       400
    ##   In metropolitan area: In central/principal city                               8000
    ##   In metropolitan area: Not in central/principal city                           8000
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)    3000
    ##                                                                             LANGUAGE
    ## METRO                                                                        Other Altaic
    ##   Metropolitan status indeterminable (mixed)                                          600
    ##   Not in metropolitan area                                                            200
    ##   In metropolitan area: In central/principal city                                     800
    ##   In metropolitan area: Not in central/principal city                                   0
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)          600
    ##                                                                             LANGUAGE
    ## METRO                                                                        Caucasian, Georgian, Avar
    ##   Metropolitan status indeterminable (mixed)                                                         0
    ##   Not in metropolitan area                                                                           0
    ##   In metropolitan area: In central/principal city                                                  200
    ##   In metropolitan area: Not in central/principal city                                              200
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)                       200
    ##                                                                             LANGUAGE
    ## METRO                                                                         Basque
    ##   Metropolitan status indeterminable (mixed)                                       0
    ##   Not in metropolitan area                                                       800
    ##   In metropolitan area: In central/principal city                                200
    ##   In metropolitan area: Not in central/principal city                            800
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)    1000
    ##                                                                             LANGUAGE
    ## METRO                                                                        Dravidian
    ##   Metropolitan status indeterminable (mixed)                                      2000
    ##   Not in metropolitan area                                                        1000
    ##   In metropolitan area: In central/principal city                                 8800
    ##   In metropolitan area: Not in central/principal city                            12400
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)      3000
    ##                                                                             LANGUAGE
    ## METRO                                                                         Kurukh
    ##   Metropolitan status indeterminable (mixed)                                       0
    ##   Not in metropolitan area                                                         0
    ##   In metropolitan area: In central/principal city                               1000
    ##   In metropolitan area: Not in central/principal city                              0
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)     400
    ##                                                                             LANGUAGE
    ## METRO                                                                        Burushaski
    ##   Metropolitan status indeterminable (mixed)                                          0
    ##   Not in metropolitan area                                                            0
    ##   In metropolitan area: In central/principal city                                     0
    ##   In metropolitan area: Not in central/principal city                                 0
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)          0
    ##                                                                             LANGUAGE
    ## METRO                                                                        Chinese
    ##   Metropolitan status indeterminable (mixed)                                    7400
    ##   Not in metropolitan area                                                     13000
    ##   In metropolitan area: In central/principal city                             200000
    ##   In metropolitan area: Not in central/principal city                         133200
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)   31400
    ##                                                                             LANGUAGE
    ## METRO                                                                        Tibetan
    ##   Metropolitan status indeterminable (mixed)                                    1600
    ##   Not in metropolitan area                                                         0
    ##   In metropolitan area: In central/principal city                               3200
    ##   In metropolitan area: Not in central/principal city                            400
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)    2000
    ##                                                                             LANGUAGE
    ## METRO                                                                        Burmese, Lisu, Lolo
    ##   Metropolitan status indeterminable (mixed)                                                   0
    ##   Not in metropolitan area                                                                     0
    ##   In metropolitan area: In central/principal city                                            600
    ##   In metropolitan area: Not in central/principal city                                       2400
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)                   0
    ##                                                                             LANGUAGE
    ## METRO                                                                        Thai, Siamese, Lao
    ##   Metropolitan status indeterminable (mixed)                                               3400
    ##   Not in metropolitan area                                                                 4000
    ##   In metropolitan area: In central/principal city                                         22400
    ##   In metropolitan area: Not in central/principal city                                     17600
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)               6200
    ##                                                                             LANGUAGE
    ## METRO                                                                        Japanese
    ##   Metropolitan status indeterminable (mixed)                                     5600
    ##   Not in metropolitan area                                                      24800
    ##   In metropolitan area: In central/principal city                              102600
    ##   In metropolitan area: Not in central/principal city                           84200
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)    20000
    ##                                                                             LANGUAGE
    ## METRO                                                                         Korean
    ##   Metropolitan status indeterminable (mixed)                                    7600
    ##   Not in metropolitan area                                                      9000
    ##   In metropolitan area: In central/principal city                              73200
    ##   In metropolitan area: Not in central/principal city                          82800
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)   25400
    ##                                                                             LANGUAGE
    ## METRO                                                                        Vietnamese
    ##   Metropolitan status indeterminable (mixed)                                       6000
    ##   Not in metropolitan area                                                         6800
    ##   In metropolitan area: In central/principal city                                 45000
    ##   In metropolitan area: Not in central/principal city                             35400
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)      17200
    ##                                                                             LANGUAGE
    ## METRO                                                                        Other East/Southeast Asian
    ##   Metropolitan status indeterminable (mixed)                                                        600
    ##   Not in metropolitan area                                                                         1000
    ##   In metropolitan area: In central/principal city                                                  1000
    ##   In metropolitan area: Not in central/principal city                                              1800
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)                       1200
    ##                                                                             LANGUAGE
    ## METRO                                                                        Indonesian
    ##   Metropolitan status indeterminable (mixed)                                        200
    ##   Not in metropolitan area                                                         1800
    ##   In metropolitan area: In central/principal city                                  3200
    ##   In metropolitan area: Not in central/principal city                               800
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)       2200
    ##                                                                             LANGUAGE
    ## METRO                                                                        Other Malayan
    ##   Metropolitan status indeterminable (mixed)                                           800
    ##   Not in metropolitan area                                                             600
    ##   In metropolitan area: In central/principal city                                     1400
    ##   In metropolitan area: Not in central/principal city                                 4800
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)          1200
    ##                                                                             LANGUAGE
    ## METRO                                                                        Filipino, Tagalog
    ##   Metropolitan status indeterminable (mixed)                                              7200
    ##   Not in metropolitan area                                                               20400
    ##   In metropolitan area: In central/principal city                                       146000
    ##   In metropolitan area: Not in central/principal city                                   130200
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)             28000
    ##                                                                             LANGUAGE
    ## METRO                                                                        Micronesian, Polynesian
    ##   Metropolitan status indeterminable (mixed)                                                     800
    ##   Not in metropolitan area                                                                      2000
    ##   In metropolitan area: In central/principal city                                              14200
    ##   In metropolitan area: Not in central/principal city                                          11600
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)                    6400
    ##                                                                             LANGUAGE
    ## METRO                                                                        Hawaiian
    ##   Metropolitan status indeterminable (mixed)                                      400
    ##   Not in metropolitan area                                                       1200
    ##   In metropolitan area: In central/principal city                                2000
    ##   In metropolitan area: Not in central/principal city                            4000
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)      200
    ##                                                                             LANGUAGE
    ## METRO                                                                         Arabic
    ##   Metropolitan status indeterminable (mixed)                                    5000
    ##   Not in metropolitan area                                                      8400
    ##   In metropolitan area: In central/principal city                              55800
    ##   In metropolitan area: Not in central/principal city                          56800
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)   19200
    ##                                                                             LANGUAGE
    ## METRO                                                                        Near East Arabic dialect
    ##   Metropolitan status indeterminable (mixed)                                                        0
    ##   Not in metropolitan area                                                                        200
    ##   In metropolitan area: In central/principal city                                                2800
    ##   In metropolitan area: Not in central/principal city                                            2800
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)                      600
    ##                                                                             LANGUAGE
    ## METRO                                                                        Hebrew, Israeli
    ##   Metropolitan status indeterminable (mixed)                                            1200
    ##   Not in metropolitan area                                                              2800
    ##   In metropolitan area: In central/principal city                                      32200
    ##   In metropolitan area: Not in central/principal city                                  19600
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)            4000
    ##                                                                             LANGUAGE
    ## METRO                                                                        Amharic, Ethiopian, etc
    ##   Metropolitan status indeterminable (mixed)                                                       0
    ##   Not in metropolitan area                                                                       200
    ##   In metropolitan area: In central/principal city                                               4600
    ##   In metropolitan area: Not in central/principal city                                           3000
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)                     200
    ##                                                                             LANGUAGE
    ## METRO                                                                        Hamitic
    ##   Metropolitan status indeterminable (mixed)                                       0
    ##   Not in metropolitan area                                                         0
    ##   In metropolitan area: In central/principal city                               1800
    ##   In metropolitan area: Not in central/principal city                            800
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)     600
    ##                                                                             LANGUAGE
    ## METRO                                                                        Sub-Saharan Africa
    ##   Metropolitan status indeterminable (mixed)                                               1800
    ##   Not in metropolitan area                                                                 2400
    ##   In metropolitan area: In central/principal city                                         21600
    ##   In metropolitan area: Not in central/principal city                                      8200
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)               4200
    ##                                                                             LANGUAGE
    ## METRO                                                                        African, n.s
    ##   Metropolitan status indeterminable (mixed)                                            0
    ##   Not in metropolitan area                                                            200
    ##   In metropolitan area: In central/principal city                                    2800
    ##   In metropolitan area: Not in central/principal city                                 600
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)          400
    ##                                                                             LANGUAGE
    ## METRO                                                                        American Indian (all)
    ##   Metropolitan status indeterminable (mixed)                                                 17000
    ##   Not in metropolitan area                                                                  144800
    ##   In metropolitan area: In central/principal city                                            22200
    ##   In metropolitan area: Not in central/principal city                                        26400
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)                 11200
    ##                                                                             LANGUAGE
    ## METRO                                                                        Other or not reported
    ##   Metropolitan status indeterminable (mixed)                                                 16200
    ##   Not in metropolitan area                                                                   32800
    ##   In metropolitan area: In central/principal city                                            41000
    ##   In metropolitan area: Not in central/principal city                                        60800
    ##   In metropolitan area: Central/principal city status indeterminable (mixed)                 27600

``` r
write.csv(tableHLSpeakersSpeakMETRO[,HLTableOrder],file=paste("Output07_TableHLSpeakersByMetro",fileYear,".csv",sep=""))

sum(thisData[thisData$USBorn==FALSE,"PERWT"])/sum(thisData[,"PERWT"])
```

    ## [1] 0.06691623
