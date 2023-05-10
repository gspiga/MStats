########################################
# HW 2 Problem 7, Part c
########################################

#Adjust parts that look like "#CAPITAL LETTERS"
#If a comment is not in capital letters, it is just a comment that does not need to be changed.

n <- #SET SAMPLE SIZE
p <- #SET TRUE POPULATION PROPORTION
p1_vec <- #SET VECTOR OF VALUES OF p_1 TO ITERATE OVER
N1_prop_vec <- #SET VECTOR OF VALUES OF N_1/N TO ITERATE OVER

V_opt <- matrix(0, nrow=length(p1_vec), ncol=length(N1_prop_vec))  #matrix to store results of the variance under optimal allocation
V_prop <- matrix(0, nrow=length(p1_vec), ncol=length(N1_prop_vec)) #matrix to store results of the variance under proportional allocation

for(i in 1:length(p1_vec)){
  for(j in 1:length(N1_prop_vec)){
    p1 <- p1_vec[i]  #pick a specific p_1
    N1_prop <- N1_prop_vec[j]  #pick a specific N_1/N
    N2_prop <- #USING THE SPECIFIC N_1/N ABOVE, SET N_2/N    
    p2 <- #COMPUTE p_2, USING THE SPECIFC p_1 AND N_1/N ABOVE
    
    S1 <- #COMPUTE S_1
    S2 <- #COMPUTE S_2
    n1_opt <- #COMPUTE n_1 UNDER OPTIMAL ALLOCATION
    n2_opt <- #COMPUTE n_2 UNDER OPTIMAL ALLOCATION
    V_opt[i,j] <- #COMPUTE VARIANCE OF p_hat UNDER OPTMAL ALLOCATION
    
    n1_prop <- #COMPUTE n_1 UNDER PROPORTIONAL ALLOCATION
    n2_prop <- #COMPUTE n_2 UNDER PROPORTIONAL ALLOCATION
    V_prop[i,j] <- #COMPUTE VARIANCE OF p_hat UNDER PROPORTIONAL ALLOCATION
  }
}

#Note: Some of the results in the V_opt and V_prop may be NA. This is because some of the combinations of choices from
# p1_vec and N1_prop_vec may be impossible given p is .05.

#If you would like to make the results to be more readable, you may consider multiplying it by a large number, say 10000:
colnames(V_opt) <- p1_vec
rownames(V_opt) <- N1_prop_vec
round(V_opt*10000, digits=4)

colnames(V_prop) <- p1_vec
rownames(V_prop) <- N1_prop_vec
round(V_prop*10000, digits=4)
