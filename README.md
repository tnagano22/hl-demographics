# R scripts to analyze heritage language spakers in the U.S.
## Backgrounds
- Project: Source codes for "Demographics of Adult Heritage Language Speakers in the United States: Differences by Region and Language and Their Implications" (The Modern Language Journal, vol. 99, No. 4)
- Author: Tomonori Nagano (tnagano@lagcc.cuny.edu)
- Date: Monday, June 19, 2023
- Script purpose: This R script will analyze the U.S. Census/ACE data and compute the number of adult heritage language speakers in the U.S. in different regions, at different time period (1980-2010), and by languages. See the following article for more information: Nagano, T. (2015). Demographics of Adult Heritage Language Speakers in the United States: Differences by Region and Language and their Implications. The Modern Language Journal, 99(4), 771-792.
- Note: Download the U.S. Census/ACE data from the IPUMS website https://usa.ipums.org. 
	- For the article, I used the following date:
		- 1980 5% state
		- 1990 5%
		- 2000 5%
		- 2010 ACS
	- The variables to extract in each dataset are: YEAR, DATANUM, SERIAL, HHWT, REGION, STATEFIP, COUNTY, METRO, METAREA (general), METAREAD (detailed), CITY, CITYPOP, CONSPUMA, CNTRY, GQ, NFAMS, MULTGEN (general), MULTGEND (detailed), PERNUM, PERWT, FAMSIZE, NCHILD, NCHLT5, FAMUNIT, ELDCH, YNGCH, NSIBS, MOMLOC, POPLOC, SUBFAM, RELATE (general), RELATED (detailed), SEX, AGE, MARST, HISPAN (general), HISPAND (detailed), BPL (general), BPLD (detailed), ANCESTR1 (general), ANCESTR1D (detailed), ANCESTR2 (general), ANCESTR2D (detailed), CITIZEN, YRIMMIG, YRSUSA1, YRSUSA2, LANGUAGE (general), LANGUAGED (detailed), SPEAKENG, RACESING (general), RACESINGD (detailed), EDUC (general), EDUCD (detailed), GRADEATT (general), GRADEATTD (detailed), OCC, IND, INCTOT, FTOTINC, POVERTY, OCCSCORE, and SEI
	- Download the data as SPSS file (which can be read by R). The full data (about 2G-3G) will be extremely large and you won't be able to process them unless you have a very powerful computer. Use sampled/partial data with the "Customize Sample Size" fundation on IPUMS if necessary.

