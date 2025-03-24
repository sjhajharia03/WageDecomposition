local best_loss = .
local best_rho = .
local best_sigma2 = .

// Grid search for optimal parameters
        // Update best values if current loss is better
        if `loss' < `best_loss' | `best_loss' == . {
            local best_loss = `loss'
            local best_rho = `rho' 
            local best_sigma2 = `sigma2'
        }
    }
}

// Display results
di "Estimation Results:"
di "Persistence parameter (rho): " `best_rho'
di "Variance parameter (sigma2): " `best_sigma2'
di "Empirical variance: " `emp_var'
di "Best loss value: " `best_loss'

// Generate plots for visualization
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
