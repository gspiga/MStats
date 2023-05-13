require(KMsurv)
require(survival)
data(burn)

burn1 <- burn
burn1 <- data.frame(burn1,Treatment=factor(burn1$Z1,labels=c("Routine","Cleansing")))
burn1 <- data.frame(burn1,Gender=factor(burn1$Z2,labels=c("Male","Female")))
burn1 <- data.frame(burn1,Race=factor(burn1$Z3,labels=c("Nonwhite","White")))
burn1 <- data.frame(burn1,PercentBurned=burn1$Z4)
burn1 <- data.frame(burn1,SiteHead=factor(burn1$Z5,labels=c("NotBurned","Burned")))
burn1 <- data.frame(burn1,SiteButtock=factor(burn1$Z6,labels=c("NotBurned","Burned")))
burn1 <- data.frame(burn1,SiteTrunk=factor(burn1$Z7,labels=c("NotBurned","Burned")))
burn1 <- data.frame(burn1,SiteUpperLeg=factor(burn1$Z8,labels=c("NotBurned","Burned")))
burn1 <- data.frame(burn1,SiteLowerLeg=factor(burn1$Z9,labels=c("NotBurned","Burned")))
burn1 <- data.frame(burn1,SiteRespTract=factor(burn1$Z10,labels=c("NotBurned","Burned")))
burn1 <- data.frame(burn1,BurnType=factor(burn1$Z11,labels=c("Chemical","Scald","Electric","Flame")))

burn1.surv <- with(burn1,Surv(T3,D3))
plot(survfit(burn1.surv~Treatment,data=burn1),col=1:2,lwd=2)
title("Time to Infection for Routine Care and Total Body Cleansing")
legend("topright",c("Routine Care","Total Body Cleansing"),col=1:2,lwd=2)

print(survdiff(burn1.surv~Treatment,data=burn1))
