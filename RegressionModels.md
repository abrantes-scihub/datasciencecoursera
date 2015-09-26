Regression Models in Shiny
========================================================
author: ds1800
date: 2015/09/25

Regression models
========================================================

**Regression models**  are very important in data science for being:

- The most well described, practical and theoretically understood models in statistics
- Able to solve a large array of problems
- Produce highly interpretable model fits
- Simple, parsimonious and interpretable

A linear regression model
========================================================

An example of a linear model, computed in R is


```r
summary(lm(mpg ~ wt + sqrt(wt), data=mtcars))
```

```

Call:
lm(formula = mpg ~ wt + sqrt(wt), data = mtcars)

Residuals:
    Min      1Q  Median      3Q     Max 
-3.4500 -2.0052 -0.6889  1.2488  6.5204 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)   84.375     14.961   5.639  4.3e-06 ***
wt             9.622      4.752   2.025  0.05217 .  
sqrt(wt)     -53.709     16.961  -3.167  0.00361 ** 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 2.67 on 29 degrees of freedom
Multiple R-squared:  0.8163,	Adjusted R-squared:  0.8037 
F-statistic: 64.45 on 2 and 29 DF,  p-value: 2.129e-11
```

This shiny application allows
========================================================

1. Select the database to be used.
2. Pick the resulting variable of the regression.
3. Choose one of the regressors
4. Define one of the several predefined linear models
5. Define some characteristics of the resulting plot.
6. Compute the linear regression model.

References
===

1. Brian Caffo, [ Regression Models for Data Science in R](https://leanpub.com/regmods)

2. Francis Smart, [ A Shiny App for Playing with OLS](http://www.econometricsbysimulation.com/2013/11/a-shiny-app-for-playing-with-ols.html)

3. The shiny application can be found in: [Regression Models in shiny](http://ds1800.shinyapps.io/RegrModelsApp)

4. Code and presentation in: [Code and presentation](http://rpubs.com/ds1800/112243)

