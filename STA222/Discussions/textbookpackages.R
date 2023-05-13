install.packages("KMsurv")
library(KMsurv)

##Times to Death for Patients with Cancer of the Tongue
##section 1.11 (page 12) in Klein & Moeschberger
data(tongue)
?tongue

tongue[10,]
#this patient had aneuploid tumor, 24 weeks from time of surgery to death
tongue[75,]
#this patient had diploid tumor, spent 8 weeks in the study after surgery, censored (death was not observed)

install.packages("asaur")
library(asaur)

#Channing House Data
#section 3.5 (page 39) in Moore
data(ChanningHouse)
?ChanningHouse

ChanningHouse[10,]
#this was a male resident, entered the house at 837 months, spent 108 months, died at 945 months
ChanningHouse[20,]
#this was a male resident, entered the house at 923 months, spent 137 months, censored at 1060 months