clear all

do "/Users/sahajjhajharia/Downloads/J345213/data_prep.do"
use "/Users/sahajjhajharia/Downloads/J345213/wage_process_data.dta", clear

// Display initial info
di "Initial number of observations: " _N

// Checking Variables
foreach var in year age wages hours lnwages {
    capture confirm variable `var'
    if _rc {
        di as error "Variable `var' not found in dataset"
        exit 498
    }
}

// Display summary statistics
di "Summary of key variables:"
sum year age wages hours lnwages
di "Value ranges before filtering:"
tab year
tab age

// Keeping Relevant Periods
keep if year >= 1990 & year <= 2025
di "Observations after year filter: " _N

keep if age >= 20 & age <= 65
di "Observations after age filter: " _N

keep if wages > 0 & hours > 0
di "Observations with valid wages and hours: " _N

tsset ID year

// Run wage regression
reg lnwages age i.year
