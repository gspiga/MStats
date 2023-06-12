 ########################################################################
#Example for (One-Stage) Unequal Probability Sampling Without Replacement
########################################################################

#This example follows the supermarket example in the textbook.
#IMPORTANT NOTE: the nhanes data is not in the same form as the supermarket data given below. 
## To get it in the same format, see section 6 after going through this example.

####################################
#Section 1: Data Construction
####################################

#The data for this example is constructed below.

supermarket <- data.frame(store=c('A','B','C','D'), area=c(100,200,300,1000), ti=c(11,20,24,245))
View(supermarket)

#The data has each row corresponding to a store (psu) with a corresponding size of the store and t_i (the total sales for the store)

####################################
#Section 2: Setup before sampling
####################################

#From the 4 psus/clusters/stores, we are going to sample 2 with probability proportional to size of the store without replacement.
N <- 4
n <- 2

#First compute the psi_i (probability that store i is selected on first draw) for each store.
psi <- (supermarket$area)/(sum(supermarket$area))

#Also add this to the data frame
supermarket$psi <- psi

#For the Horvitz-Thompson estimator, we need to compute the pi_ik's (probability that store i and store k are both selected in the sample)
#A matrix with pi_ik in the i,k th entry is produced below:

pi_ik <- matrix(0, nrow=N, ncol=N)
for(i in 1:(N-1)){    #For loop filling in upper triangle of the matrix
  for(k in (i+1):N){
    pi_ik[i,k] = (psi[i]*psi[k])/(1-psi[i]) + (psi[k]*psi[i])/(1-psi[k])
  }
}
pi_ik[lower.tri(pi_ik)] <- t(pi_ik)[lower.tri(pi_ik)]  #pi_ik = pi_ki (matrix is symmetric)

#The single inclusion probabilities pi_i (probability that store i is included in the sample can be computed from the pi_ik's)
pi_i <- rowSums(pi_ik)    #You would typically also divide by (n-1), in this case n-1=1

#Assign the single inclusion probabilities pi_i to be the diagonals of the pi_ik matrix:
diag(pi_ik) <- pi_i
#Also add them to the data frame:
supermarket$pi_i <- pi_i

####################################
#Section 3: Perform an unequal probability sample (proportional to store size) without replacement
####################################

#Sample two of the four stores proportional to size
set.seed(144)
sample_index <- sample(1:N, size=2, replace=FALSE, prob=psi)
#The fourth and second stores (D and B) were sampled

#Construct new objects with just the known sample data (the population data is now unknown).
#I will name the sample objects after the population objects, but with _samp following them.
supermarket_samp <- supermarket[sample_index,]

pi_ik_samp <- pi_ik[sample_index, sample_index]

####################################
#Section 4: Compute estimators using the survey package (for manual calculations, see following section)
####################################
library(survey)

#About the arguments for setting the design:
#Set id=~1
#Set fpc=~pi_i where pi_i is referenceing the column name of the sample data corresponding to the inclusion probabilities pi_i
#Set pps=ppsmat(pi_ik_samp) where pi_ik_samp is the pairwise inclusion probabilities for the sample (not the population).
## ppsmat is a function in the survey package working on the pairwise inclusion probabilities for the sampled units
#Set data=name of your data (for the sample)
#Set variance="HT" OR "YG". 
## "HT" refers to Horvitz-Thompson type variance estimator (Vhat_1 near the end of the cluster lecture notes)
## "YG" referes to Sen-Yates-Grundy type variance estimator (Vhat_2 near the end of the cluster lecture notes)
## If one type of variance turns out negative (which will lead to an NaN SE), you can try the other type.
## If both are negative, you should report that or you can try taking a different sample.
## Yes, it is possible that these variance estimators turn out to be negative.
supermarket_design <- svydesign(id=~1, fpc=~pi_i, pps=ppsmat(pi_ik_samp), data=supermarket_samp, variance="HT")

#OR (depending on what variance estimator you want to use)

supermarket_design <- svydesign(id=~1, fpc=~pi_i, pps=ppsmat(pi_ik_samp), data=supermarket_samp, variance="YG")

#Compute the estimated total and SE
svytotal(~ti, supermarket_design)

#Although not that applicable for this specific problem, if we had M0=K=total number of ssus (individual units), we can just
# divide the estimated total and SE by M0=K, to get the estimated mean.
#For the sake of example, let's say M0=K=10000 in this problem. Then the estimated mean and SE are below:
M0 = 10000

#Estimated mean
(svytotal(~ti, supermarket_design)/M0)[1]
#Estimated SE
SE(svytotal(~ti, supermarket_design))/M0

####################################
#Section 5: Compute estimators manually using formulas
####################################

#To get the estimated total using the Horvitz-Thompson estimator:

total_est <- sum(supermarket_samp$ti/supermarket_samp$pi_i)

#To get the estimated variance for the total using one of two possible methods, see below.
## It is possible that either of the two variance estimators gives a negative result, and thus a SE cannot be recorded.
## If you run into this issue of a variance coming back negative, you may have done the calculation wrong, but it may also be fine.
## In the case that you are sure your computations were correct, you may want to try the other method of variance estimation.
## If both methods return negative results, you should report that or you can try taking a different sample.

#####
# method 1: Horvitz-Thompson type variance estimator (Vhat_1 near the end of the cluster lecture notes)
#####

#We first compute the double sum (i.e. the latter part of the formula).
#You would typically need to go over a lot of pairs of indices.
#But in the case of only two sampled clusters, the double sum consists of summing for the pairs of indices (1=D, 2=B) and (2=B, 1=D).
## Note that 1 and 2 here are the indices for the rows in supermarket_samp for D and B.
## Due to symmetry of the summand in the double sum, you can just compute the summand for (1=D, 2=B) and then multiply by 2

double_sum <- 2*(((pi_ik_samp[1,2] - supermarket_samp$pi_i[1]*supermarket_samp$pi_i[2])/pi_ik_samp[1,2])*(supermarket_samp$ti[1]/supermarket_samp$pi_i[1])*(supermarket_samp$ti[2]/supermarket_samp$pi_i[2]))

#Now that we have the double sum computed, the estimated variance of the total is:
total_var_HT <- sum(((1-supermarket_samp$pi_i)/(supermarket_samp$pi_i^2))*(supermarket_samp$ti^2)) + double_sum
#And the SE for the estimated total is:
total_SE_HT <- sqrt(total_var_HT)


#####
# method 2: Sen-Yates-Grundy type variance estimator (Vhat_2 near the end of the cluster lecture notes)
#####

#This formula just consists of 1/2 times a double summation.
## In the case of only two sampled clusters, you are summing over the indices (1=D, 2=B) and (2=B, 1=D).
## Due to symmetry of the summand, you are summing the same thing twice.
## Due to the 1/2 multiplier and the fact that both summands are the same, just compute the summand for (1=D, 2=B).

total_var_SYG <- ((supermarket_samp$pi_i[1]*supermarket_samp$pi_i[2] - pi_ik_samp[1,2])/ pi_ik_samp[1,2]) * (supermarket_samp$ti[1]/supermarket_samp$pi_i[1] - supermarket_samp$ti[2]/supermarket_samp$pi_i[2])^2
#And the SE for the estimated total is:
total_SE_SYG <- sqrt(total_var_SYG)

#####

#Although not that applicable for this specific problem, if we had M0=K=total number of ssus (individual units), we can just
# divide the estimated total and SE by M0=K, to get the estimated mean.
#For the sake of example, let's say M0=K=10000 in this problem. Then the estimated mean and SE are below:
M0 = 10000

mean_est <- total_est/M0

#Two possible SE for the mean:
mean_SE_HT <- total_SE_HT/M0
mean_SE_SYG <- total_SE_SYG/M0

####################################
#Section 6: But wait! The data for nhanes is not set up this way!
####################################

#The nhanes data has each row corresponding to an ssu (a single person) inside of a psu/cluster (those given by sdmvstra).
#On the contrary the supermarket data has each row corresponding to a psu/cluster.
#I suggest for at least this part, you make a new data frame that matches that of the supermarket example.
#You can use the aggregate function, explanation below:

#Assuming you saved the data as nhanes:
## Suppose we want the total ridageyr and total bmxwt for each cluster specified in sdmvstra. Then we can do:
cluster_data <- aggregate(cbind(age, bmxwt)~sdmvstra, data=nhanes, FUN=sum)   #This line of code is not designed to work unless you have the nhanes data loaded
View(cluster_data)                                                                   #This line of code is not designed to work unless you have the nhanes data loaded
## NOTE: For the final, these are not the exact columns of interest so please adjust the above accordingly.

#You also need to find the size of each cluster and add those
cluster_data$size <- aggregate(bmxwt~sdmvstra, data=nhanes, FUN=length)[,2]          #This line of code is not designed to work unless you have the nhanes data loaded
## NOTE: This line is correct and should not have to be changed assuming variable names are the same. 
## bmxwt in the line of code above could be replaced with any other column

#Now you have the data aggregated for the clusters and it is in the form of the supermarket data.
#You can then follow the code for the supermarket example.
#NOTE: The final asks you to do this for multiple variables though, so first the bmxwt column would take the place of the ti column in the supermarket example.
## And then the _______ column (variable of interest) would take the place of the ti column and so on.




