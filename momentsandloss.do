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

di "Empirical moments:"
di "Variance: " `emp_var'
di "Autocovariance: " `emp_autocov'

// Calculate theoretical moments for different values of persistence and variance
local best_loss = .
local best_rho = .
local best_sigma2 = .

// Grid search for optimal parameters
forvalues rho = -0.9(0.1)0.9 {
    forvalues sigma2 = 0.1(0.1)2.0 {
        local theo_var = `sigma2'/(1-`rho'^2)
        local theo_autocov = `rho'
        local loss = (`emp_var' - `theo_var')^2 + 2*(`emp_autocov' - `theo_autocov')^2
        if `loss' < `best_loss' | `best_loss' == . 
        {
            local best_loss = `loss'
            local best_rho = `rho' 
            local best_sigma2 = `sigma2'
        }
    }
}

di "Estimation Results:"
di "Persistence parameter (rho): " `best_rho'
di "Variance parameter (sigma2): " `best_sigma2'
di "Empirical variance: " `emp_var'
di "Empirical autocovariance: " `emp_autocov'
di "Theoretical variance: " `best_sigma2'/(1-`best_rho'^2)
di "Theoretical autocovariance: " `best_rho'
di "Best loss value: " `best_loss'
