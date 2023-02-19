library(dplyr)
library(tidyr)
library(tidyverse)
library(Rcpp)
library(corrplot)
library(rstatix)

############## Environments ################

#list for raw data
data <- new.env(parent=emptyenv())
#list for full dataset (from raw data)
data_full <- new.env(parent=emptyenv())
#list with parameters
parameters <- new.env(parent=emptyenv())

############## upload base de dados ################

data$a <- c(0.51,
       0.75,
       1.25,
       0.66,
       0.71,
       0.47,
       0.89,
       1.51,
       1.36,
       0.94,
       -0.17,
       1.38,
       0.05,
       -0.08,
       0.03,
       0.39,
       0.44,
       0.26,
       0.42,
       0.26,
       0.51,
       -0.46,
       1.69,
       0.72,
       0.41,
       0.29,
       -0.63,
       0.17,
       0.8,
       0.54,
       0.72,
       0.16,
       -0.26,
       0.1,
       0.39,
       0.72)
data$b <- c(-1.15,
       0.38,
       3.18,
       0.63,
       0.47,
       -0.13,
       -1.17,
       1.79,
       1.01,
       0.94,
       -1.11,
       -0.5,
       -1.33,
       -0.85,
       -0.88,
       1.36,
       0.79,
       0.25,
       0.2,
       -1.35,
       -0.33,
       -4.52,
       4.68,
       0.46,
       0.43,
       0.28,
       -7.1,
       0.85,
       1.08,
       1.97,
       5.06,
       -1.53,
       -2.59,
       0.94,
       1.75,
       5.26)
data$c <- c(0.83,
       0.86,
       1.05,
       0.89,
       1.07,
       1.08,
       1.07,
       1.23,
       1.15,
       1.12,
       1.09,
       0.97,
       0.22,
       0.28,
       0.41,
       0.45,
       0.51,
       0.54,
       0.54,
       0.58,
       0.68,
       0.73,
       0.58,
       0.78,
       0.39,
       0.22,
       -1.81,
       -0.94,
       0.43,
       0.51,
       0.88,
       0.48,
       0.37,
       1,
       0.48,
       0.55)

############## list for raw data ################

datalst <- eapply(data, "[")

total_assets <- c(length(datalst))

############## list for full dataset (from raw data) ################

data_full$asset_base <- datalst[1][[1]]

for (i in 2:total_assets) {
  
  data_full$asset_base <- cbind(data_full$asset_base,datalst[i][[1]])
  
}

data_fullst <- eapply(data_full, "[")

############## list for raw data ################

parameters$mean <- matrix(0,total_assets,1)

for (i in 1:total_assets) {
  
  parameters$mean[i] <- mean(datalst[i][[1]])
  
}

paramlst <- eapply(parameters, "[")

# e$meanA <- mean(datalst[1][[1]])
# e$meanB <- mean(datalst[2][[1]])
# e$meanC <- mean(datalst[3][[1]])

parameters$var <- matrix(0,total_assets,1)

for (i in 1:total_assets) {
  
  parameters$var[i] <- var(datalst[i][[1]])
  
}

paramlst <- eapply(parameters, "[")

# e$varA <- var(datalst[1][[1]])
# e$varB <- var(datalst[2][[1]])
# e$varC <- var(datalst[3][[1]])

parameters$correl <- matrix(0,total_assets,total_assets)

parameters$correl <- cor(data_fullst[1][[1]])

# parameters$correl <- unique(c(cor(data_fullst[1][[1]])))

# parameters$correl <- parameters$correl[-1]

paramlst <- eapply(parameters, "[")

# e$AB <- cor(elst[1][[1]],elst[2][[1]])
# e$AC <- cor(elst[1][[1]],elst[3][[1]])
# e$BC <- cor(elst[2][[1]],elst[3][[1]])

#elst <- eapply(e, "[")

weights <- as.data.frame(matrix(0,10000,total_assets))
invest_return <- as.data.frame(matrix(0,10000,1))
invest_return1 <- as.data.frame(matrix(0,10000,total_assets))
invest_risk <- as.data.frame(matrix(0,10000,1))
invest_risk1 <- as.data.frame(matrix(0,10000,total_assets))

for (i in 1:nrow(weights)) {
  
  weights[i,] <- rlnorm(total_assets,0,1)
  weights[i,] <- (weights[i,]/sum(weights[i,]))
  
    for (j in 1:total_assets) {
    
      invest_return1[i,j] <- weights[i,j] * paramlst$mean[j,1]

      invest_risk1[i,j] <- weights[i,j]^2 * paramlst$var[j,1] + 2 * weights[i,ifelse(j == total_assets, 1,j)] * weights[i,ifelse(j < total_assets, j+1,j)] * sqrt(paramlst$var[ifelse(j == total_assets, 1,j),1]) * sqrt(paramlst$var[ifelse(j < total_assets, j+1,j),1]) * paramlst$correl[ifelse(j == total_assets, 1,j),ifelse(j < total_assets, j+1,j)]
    
    # invest_risk1[i,1] <- weights[i,1]^2 * e$varA +
    #                       weights[i,2]^2 * e$varB +
    #                       weights[i,3]^2 * e$varC +
    #                       2 * weights[i,1] * weights[i,2] * sqrt(e$varA) * sqrt(e$varB) * e$AB +
    #                       2 * weights[i,2] * weights[i,3] * sqrt(e$varB) * sqrt(e$varC) * e$BC +
    #                       2 * weights[i,1] * weights[i,3] * sqrt(e$varA) * sqrt(e$varC) * e$AC

    
    }
  
  invest_return[i,1] <- sum(invest_return1[i,])
  invest_risk[i,1] <- sum(invest_risk1[i,])
  
  }

colname <- c("w1")

for (i in 1:total_assets) {
  
  colname <- c(cbind(colname,paste0("w",i)))
  
}

colname <- unique(c(cbind(c("retorno","risco"),colname)))

result <- as.data.frame(cbind(invest_return,invest_risk,weights)) 

colnames(result) <- c(colname)

result <- result %>% mutate(sharpe = (retorno-0.1375)/risco) %>% arrange(desc(sharpe))

# elst <- eapply(e, "[")

plot(x = result$retorno, y = result$risco)

elected <- result %>% filter(sharpe == max(sharpe))

elected

gc()

rm(list=ls())

