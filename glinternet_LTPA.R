library(readr)
library(dplyr)
library(glinternet)

set.seed(011120242)

y <- urban_PA_apu_METhours$log_apu_METhours
x <- urban_PA_apu_METhours %>% select(-log_apu_METhours)

i_num <- sapply(x, is.numeric)
idx_num <- (1:length(i_num))[i_num]
idx_cat <- (1:length(i_num))[!i_num]

numLevels <- x %>% sapply(nlevels)
numLevels[numLevels==0] <- 1

x$edu<-as.integer(as.integer(x$edu)-1)
x$work<-as.integer(as.integer(x$work)-1)
x$smoking<-as.integer(as.integer(x$smoking)-1)
x$substance<-as.integer(as.integer(x$substance)-1)
x$marriage<-as.integer(as.integer(x$marriage)-1)
x$sex<-as.integer(as.integer(x$sex)-1)
x$alcohol<-as.integer(as.integer(x$alcohol)-1)
x$deprivation_bi<-as.integer(as.integer(x$deprivation_bi)-1)
x$bool_pocketparks_300<-as.integer(as.integer(x$bool_pocketparks_300)-1)


cv_fit <- glinternet.cv(x, y, numLevels, nFolds=10, family="gaussian")
i_1Std <- which(cv_fit$lambdaHat1Std == cv_fit$lambda)
coefs <- coef(cv_fit$glinternetFit)[[i_1Std]]

names(numLevels)[idx_cat[coefs$mainEffects$cat]]
names(numLevels)[idx_num[coefs$mainEffects$cont]]

coefs$mainEffects
coefs$mainEffectsCoef
coefs$interactions
coefs$interactionsCoef$contcont
coefs$interactionsCoef$catcont