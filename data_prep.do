***********************************************
*  Econ 484, Wage Process Estimation
*  Data preparation for analysis
***********************************************

clear all
* create a directory and install several programs
cap ssc install blindschemes
cap ssc install estout
cap ssc install binscatter
set scheme plotplain

* Import the cleaned data
use "/Users/sahajjhajharia/Downloads/J345213/cleandata.dta", clear

* Rename variables
rename ER10001 release1997
rename ER10002 seq1997
rename ER10009 age1997
rename ER10010 sex1997
rename ER10016 marital1997
rename ER12080 wages1997
rename ER12174 hours1997
rename ER12222 educ1997

rename ER13001 release1999
rename ER13002 seq1999
rename ER13010 age1999
rename ER13011 sex1999
rename ER13021 marital1999
rename ER16463 wages1999
rename ER16471 hours1999
rename ER16516 educ1999

rename ER17001 release2001
rename ER17002 seq2001
rename ER17013 age2001
rename ER17014 sex2001
rename ER17024 marital2001
rename ER20399 hours2001
rename ER20443 wages2001
rename ER20457 educ2001

rename ER21001 release2003
rename ER21002 seq2003
rename ER21017 age2003
rename ER21018 sex2003
rename ER21023 marital2003
rename ER24080 hours2003
rename ER24116 wages2003
rename ER24148 educ2003

rename ER25001 release2005
rename ER25002 seq2005
rename ER25017 age2005
rename ER25018 sex2005
rename ER25023 marital2005
rename ER27886 hours2005
rename ER27931 wages2005
rename ER28047 educ2005

rename ER36001 release2007
rename ER36002 seq2007
rename ER36017 age2007
rename ER36018 sex2007
rename ER36023 marital2007
rename ER40876 hours2007
rename ER40921 wages2007
rename ER41037 educ2007

rename ER42001 release2009
rename ER42002 seq2009
rename ER42017 age2009
rename ER42018 sex2009
rename ER42023 marital2009
rename ER46767 hours2009
rename ER46829 wages2009
rename ER46981 educ2009

rename ER47301 release2011
rename ER47302 seq2011
rename ER47317 age2011
rename ER47318 sex2011
rename ER47323 marital2011
rename ER52175 hours2011
rename ER52237 wages2011
rename ER52405 educ2011

rename ER53001 release2013
rename ER53002 seq2013
rename ER53017 age2013
rename ER53018 sex2013
rename ER53023 marital2013
rename ER57976 hours2013
rename ER58038 wages2013
rename ER58223 educ2013

rename ER60001 release2015
rename ER60002 seq2015
rename ER60017 age2015
rename ER60018 sex2015
rename ER60024 marital2015
rename ER65156 hours2015
rename ER65216 wages2015
rename ER65459 educ2015

rename ER66001 release2017
rename ER66002 seq2017
rename ER66017 age2017
rename ER66018 sex2017
rename ER66024 marital2017
rename ER71233 hours2017
rename ER71293 wages2017
rename ER71538 educ2017

rename ER72001 release2019
rename ER72002 seq2019
rename ER72017 age2019
rename ER72018 sex2019
rename ER72024 marital2019
rename ER77255 hours2019
rename ER77315 wages2019
rename ER77599 educ2019

rename ER78001 release2021
rename ER78002 seq2021
rename ER78017 age2021
rename ER78018 sex2021
rename ER78025 marital2021
rename ER81582 hours2021
rename ER81642 wages2021
rename ER81926 educ2021

* Generate a unique ID
gen ID = .
replace ID = seq1997 if !missing(seq1997)
replace ID = seq1999 if !missing(seq1999)
replace ID = seq2001 if !missing(seq2001)
replace ID = seq2003 if !missing(seq2003)
replace ID = seq2005 if !missing(seq2005)
replace ID = seq2007 if !missing(seq2007)
replace ID = seq2009 if !missing(seq2009)
replace ID = seq2011 if !missing(seq2011)
replace ID = seq2013 if !missing(seq2013)
replace ID = seq2015 if !missing(seq2015)
replace ID = seq2017 if !missing(seq2017)
replace ID = seq2019 if !missing(seq2019)
replace ID = seq2021 if !missing(seq2021)

* Generate year variable
gen year = .
replace year = 1997 if !missing(seq1997)
replace year = 1999 if !missing(seq1999)
replace year = 2001 if !missing(seq2001)
replace year = 2003 if !missing(seq2003)
replace year = 2005 if !missing(seq2005)
replace year = 2007 if !missing(seq2007)
replace year = 2009 if !missing(seq2009)
replace year = 2011 if !missing(seq2011)
replace year = 2013 if !missing(seq2013)
replace year = 2015 if !missing(seq2015)
replace year = 2017 if !missing(seq2017)
replace year = 2019 if !missing(seq2019)
replace year = 2021 if !missing(seq2021)

* Generate standardized variables
gen wages = .
replace wages = wages1997 if !missing(wages1997)
replace wages = wages1999 if !missing(wages1999)
replace wages = wages2001 if !missing(wages2001)
replace wages = wages2003 if !missing(wages2003)
replace wages = wages2005 if !missing(wages2005)
replace wages = wages2007 if !missing(wages2007)
replace wages = wages2009 if !missing(wages2009)
replace wages = wages2011 if !missing(wages2011)
replace wages = wages2013 if !missing(wages2013)
replace wages = wages2015 if !missing(wages2015)
replace wages = wages2017 if !missing(wages2017)
replace wages = wages2019 if !missing(wages2019)
replace wages = wages2021 if !missing(wages2021)


* Deflate wages to 2012 dollars using CPI
* CPI values (2012 = 100)
gen cpi = .
replace cpi = 82.4 if year == 1997
replace cpi = 85.5 if year == 1999
replace cpi = 88.5 if year == 2001
replace cpi = 91.7 if year == 2003
replace cpi = 95.3 if year == 2005
replace cpi = 97.8 if year == 2007
replace cpi = 95.4 if year == 2009
replace cpi = 98.2 if year == 2011
replace cpi = 100.0 if year == 2012
replace cpi = 100.0 if year == 2013
replace cpi = 100.0 if year == 2015
replace cpi = 103.4 if year == 2017
replace cpi = 107.4 if year == 2019
replace cpi = 114.3 if year == 2021

* Deflate wages to 2012 dollars
gen real_wages = wages * (100/cpi)
replace wages = real_wages
drop real_wages cpi

gen hours = .
replace hours = hours1997 if !missing(hours1997)
replace hours = hours1999 if !missing(hours1999)
replace hours = hours2001 if !missing(hours2001)
replace hours = hours2003 if !missing(hours2003)
replace hours = hours2005 if !missing(hours2005)
replace hours = hours2007 if !missing(hours2007)
replace hours = hours2009 if !missing(hours2009)
replace hours = hours2011 if !missing(hours2011)
replace hours = hours2013 if !missing(hours2013)
replace hours = hours2015 if !missing(hours2015)
replace hours = hours2017 if !missing(hours2017)
replace hours = hours2019 if !missing(hours2019)
replace hours = hours2021 if !missing(hours2021)

gen age = .
replace age = age1997 if !missing(age1997)
replace age = age1999 if !missing(age1999)
replace age = age2001 if !missing(age2001)
replace age = age2003 if !missing(age2003)
replace age = age2005 if !missing(age2005)
replace age = age2007 if !missing(age2007)
replace age = age2009 if !missing(age2009)
replace age = age2011 if !missing(age2011)
replace age = age2013 if !missing(age2013)
replace age = age2015 if !missing(age2015)
replace age = age2017 if !missing(age2017)
replace age = age2019 if !missing(age2019)
replace age = age2021 if !missing(age2021)

gen sex = .
replace sex = sex1997 if !missing(sex1997)
replace sex = sex1999 if !missing(sex1999)
replace sex = sex2001 if !missing(sex2001)
replace sex = sex2003 if !missing(sex2003)
replace sex = sex2005 if !missing(sex2005)
replace sex = sex2007 if !missing(sex2007)
replace sex = sex2009 if !missing(sex2009)
replace sex = sex2011 if !missing(sex2011)
replace sex = sex2013 if !missing(sex2013)
replace sex = sex2015 if !missing(sex2015)
replace sex = sex2017 if !missing(sex2017)
replace sex = sex2019 if !missing(sex2019)
replace sex = sex2021 if !missing(sex2021)

* Generate log wages
gen lnwages = ln(wages)

* Create unique identifier by combining ID and year (numeric format)
gen unique_id = ID*10000 + year

* Keep only necessary variables for wage process estimation
keep unique_id ID year wages hours age sex lnwages

* Save the prepared dataset
save "/Users/sahajjhajharia/Downloads/J345213/wage_process_data.dta", replace 
