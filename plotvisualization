// 1. Scatter plot of wage deviations vs lags
twoway (scatter wage_dev wage_dev_lag if !missing(wage_dev) & !missing(wage_dev_lag), ///
    msize(tiny) mcolor(blue%30)) ///
    (function y = `best_rho'*x, range(-3 3) lcolor(red) lwidth(medium)), ///
    title("Wage Deviations vs Lagged Wage Deviations") ///
    subtitle("Red line shows theoretical AR(1) relationship") ///
    xtitle("Lagged Wage Deviation") ytitle("Wage Deviation") ///
    legend(off) ///
    note("Slope = `best_rho' (estimated persistence)") ///
    graphregion(color(white)) ///
    plotregion(color(white))
graph export "wage_dev_scatter.pdf", replace

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
