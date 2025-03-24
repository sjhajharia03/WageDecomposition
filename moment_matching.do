// Calculate empirical moments
bysort ID: egen mean_wage = mean(lnwages)
gen wage_dev = lnwages - mean_wage

// Calculate variance and autocovariance
bysort ID: egen var_wage = sd(wage_dev)
gen var_wage_sq = var_wage^2

// Calculate mean of variances
sum var_wage_sq if !missing(var_wage_sq), meanonly
local emp_var = r(mean)

// Calculate autocovariance
bysort ID: gen wage_dev_lag = wage_dev[_n-1]
corr wage_dev wage_dev_lag if !missing(wage_dev) & !missing(wage_dev_lag)
local emp_autocov = r(rho)

// Display empirical moments
di "Empirical moments:"
di "Variance: " `emp_var'
di "Autocovariance: " `emp_autocov'

// Calculate theoretical moments for different values of persistence and variance
// Try negative values for rho since empirical autocovariance is negative
forvalues rho = -0.9(0.1)0.9 {
    forvalues sigma2 = 0.1(0.1)2.0 {
        // Calculate theoretical variance
        local theo_var = `sigma2'/(1-`rho'^2)
        
        // Calculate theoretical autocovariance
        local theo_autocov = `rho'
        
        // Calculate loss (weighted to put more emphasis on matching autocovariance)
        local loss = (`emp_var' - `theo_var')^2 + 2*(`emp_autocov' - `theo_autocov')^2
        
di "Empirical autocovariance: " `emp_autocov'
di "Theoretical variance: " `best_sigma2'/(1-`best_rho'^2)
di "Theoretical autocovariance: " `best_rho'
// 2. Empirical vs Theoretical Autocovariance Function
preserve
clear
set obs 5
gen lag = _n - 1
gen theo_autocov = `best_rho'^lag
gen emp_autocov = .
replace emp_autocov = 1 if lag == 0
replace emp_autocov = `emp_autocov' if lag == 1
replace emp_autocov = `emp_autocov'^2 if lag == 2
replace emp_autocov = `emp_autocov'^3 if lag == 3
replace emp_autocov = `emp_autocov'^4 if lag == 4

twoway (connected theo_autocov lag, lcolor(red) mcolor(red)) ///
    (connected emp_autocov lag, lcolor(blue) mcolor(blue)), ///
    title("Empirical vs Theoretical Autocovariance Function") ///
    xtitle("Lag") ytitle("Autocovariance") ///
    legend(label(1 "Theoretical") label(2 "Empirical")) ///
    graphregion(color(white)) ///
    plotregion(color(white))
graph export "autocov_function.pdf", replace
restore

// 3. Empirical vs Theoretical Variance
preserve
clear
set obs 2
gen type = _n
label define type 1 "Empirical" 2 "Theoretical"
label values type type
gen variance = .
replace variance = `emp_var' if type == 1
replace variance = `best_sigma2'/(1-`best_rho'^2) if type == 2

graph bar variance, over(type) ///
    title("Empirical vs Theoretical Variance") ///
    ytitle("Variance") ///
    bar(1, color(blue)) bar(2, color(red)) ///
    graphregion(color(white)) ///
    plotregion(color(white))
graph export "variance_comparison.pdf", replace
restore

// Run bootstrap estimation (optional)
// bootstrap_estimates "/Users/sahajjhajharia/Downloads/J345213/wage_process_data.dta" 100 