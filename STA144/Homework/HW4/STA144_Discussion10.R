##################
# Discussion 10
##################

################## Two-Stage Cluster Sample Example (see discussion sheet for info)

###### With the Survey Package

library(survey)

#Form the Data Frame
N <- 50   #number of wards
n <- 3    #number of sampled wards
Mi <- c(20, 15, 22)   #size of sampled wards
mi <- c(5, 4, 6)      #number sampled in each ward
count_typeO <- c(4, 1, 3)   #number of type O patients in the wards

ward <- rep(1:n, mi)   #vector for ward id
patient <- c(1:5, 1:4, 1:6)   #vector for patient id in each ward
typeO <- c(rep(1,4), rep(0,1), rep(1,1), rep(0,3), rep(1,3), rep(0,3))   #0-1 vector, 1 if type O, 0 if not

blood <- data.frame(ward, patient, typeO)   #make data frame
blood$psufpc <- rep(N, nrow(blood))       #add column with number of clusters repeated
blood$ssufpc <- rep(Mi, mi)               #add column with cluster sizes

blood_design <- svydesign(id=~ward+patient, fpc=~psufpc+ssufpc, data=blood)
#id specifies the cluster structure. The psu is ward, the ssu is patient.
#fpc: There are two fpc, one for psu and one for ssu. For psu, it is number of clusters. For ssu, it is size of the clusters
#weight can be omitted

svymean(~typeO, blood_design)  #calculate a mean/proportion as normal.
svytotal(~typeO, blood_design)

###### Manually

#Estimate of proportion
p_hat <- sum(Mi*(count_typeO/mi))/sum(Mi)   #same as above

#Standard error for proportion:
M_bar <- mean(Mi)
sr2 <- sum((Mi^2)*(((count_typeO/mi) - p_hat)^2))/(n-1)
si2 <- aggregate(typeO~ward, data=blood, FUN=var)$typeO
SE_p <- sqrt(((1/(M_bar^2))*(1-n/N)*(sr2/n)) + (1/(n*N*(M_bar^2)))*sum((Mi^2)*(1- mi/Mi)*(si2/mi)))   #same as above

#Estimate of total
t_hat <- sum((N/n)*(Mi/mi)*count_typeO)   #same as above

#Standard error for proportion
ti_hat <- count_typeO*(Mi/mi)
SE_t <- sqrt(((N^2)*(1-n/N)*(var(ti_hat)/n)) + ((N/n)*sum((Mi^2)*(1- mi/Mi)*(si2/mi))))   #same as above

################## Two-Stage Cluster Design Example (see discussion sheet for info)

MSW <- sum(si2*(mi-1))/(sum(mi) - n)   #estimated MSW
S2 <- sum((blood$typeO - p_hat)^2)/(sum(mi) - 1)   #estimate S2
Ra2 <- 1 - MSW/S2   #estimated Ra2

N <- 100   #number of wards at new hospital
M_bar <- mean(Mi)   #estimate the mean ward size by the wards in our sample

C <- 10000  #budget
c1 <- 1000  #cost of psu
c2 <- 100   #cost of ssu

#Guidelines for number of psus and ssus
m_opt <- sqrt((c1/c2)*((M*(N-1))/(M*N-1))*((1-Ra2)/Ra2))
n_opt <- C/(c1 + c2*m_opt)


################## Unequal Probability Example (see discussion sheet for info)

##### Data, sample

num_students <- c(250, 300, 350, 100)
num_profs <- c(20, 35, 30, 15)
psi_profs <- num_profs/sum(num_profs)
n <- 3

university <- data.frame(num_students, num_profs, psi_profs)
cumsum(num_profs) #A:1-20, B:21-55, C:56-85, D:86-100

set.seed(144)
sample(1:100, n, replace=TRUE)  #5, 71, 73 -> A, C, C
profs_samp <- c(1,3,3)   #A, C, C

university_samp <- university[profs_samp,]

##### With survey package

university_samp$wt <- (1/(university_samp$psi_profs*n))
university_design <- svydesign(id=~1, weights=~wt, data=university_samp)
#can omit fpc, just input weights

svytotal(~num_students, university_design)


###### Manually

t_hat <- (1/n)*(sum(university_samp$num_students/university_samp$psi_profs))

SE_t_hat <- sqrt((1/n)*(1/(n-1))*sum(((university_samp$num_students/university_samp$psi_profs) - t_hat)^2))

