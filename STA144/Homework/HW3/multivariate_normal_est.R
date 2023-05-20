##### Sampling from a multivariate normal distribution

#Use the MASS package, you may need to install it if you have not already

library(survey)
library(MASS)

#Sample Size
n <- 20

#Sample from a multivariate normal with both means 0, both SDs 1, and 0.5 correlation

my_sample <- mvrnorm(n, mu=c(0,0), Sigma=matrix(c(1,0.5,0.5,1), nrow=2, ncol=2))

#If you want to use the survey functions on this data, you should convert it to a data frame:
my_sample <- as.data.frame(my_sample)
colnames(my_sample) <- c("x","y")

#If you are not given the population sizes, then you can ignore the fpc by setting the following weights:
my_sample$sampwt <- rep(1, n)

#and not using the fpc argument in the sampling design:
my_design <- svydesign(id=~1, weights=~sampwt, data=my_sample)

#Then you can obtain the standard SRS estimate for the mean of y:
coef(svymean(~y, design=my_design))

#And the regression estimate for the mean of y, given the true mean of the x's is 0:
my_fit <- svyglm(y~x, design=my_design)
true_mean_x <- data.frame(x=0)
coef(predict(my_fit, true_mean_x))


