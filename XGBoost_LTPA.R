library(haven)
library(caret)
library(xgboost)
library(ggplot2)
library(shapviz)
library(Ckmeans.1d.dp)
library(ggpubr)
library(dplyr)
library(SHAPforxgboost)
library(readr)
library(reshape)
library(tidyr)

set.seed(0305202421)
searchGridSubCol <- expand.grid(eta = c(0.005, 0.01, 0.015, 0.02, 0.025),
                                gamma =c(0,1,2),
                                max_depth = c(2L,3L,4L,5L), 
                                subsample = c(0.25, 0.5, 0.75),
                                min_child_weight = c(0,0.5,1))


urban_PA_apu_METhours  <- data.frame(read_csv("apu_METhours_ML.csv"))
urban_PA_apu_METhours$zygocity=NULL

rownames(urban_PA_apu_METhours)<-urban_PA_apu_METhours[, 1]
urban_PA_apu_METhours <-urban_PA_apu_METhours[,-1]

label=urban_PA_apu_METhours$log_apu_METhours
urban_PA_apu_METhours$log_apu_METhours=NULL

n = nrow(urban_PA_apu_METhours)
train.index_apu_METhours = sample(n,floor(0.75*n))
train_data_apu_METhours = as.matrix(urban_PA_apu_METhours[train.index_apu_METhours,])
train_label_apu_METhours = label[train.index_apu_METhours]
test_data_apu_METhours = as.matrix(urban_PA_apu_METhours[-train.index_apu_METhours,])
test_label_apu_METhours = label[-train.index_apu_METhours]

dtrain_apu_METhours <- xgb.DMatrix(data = train_data_apu_METhours , label = train_label_apu_METhours, missing=NA)
dtest_apu_METhours <- xgb.DMatrix(data = test_data_apu_METhours , label = test_label_apu_METhours, missing=NA)

system.time(
  rmseErrorssHyperparameters_apu_METhours <- apply(searchGridSubCol, 1, function(parameterList){
    
    #Extract Parameters to test
    currentSubsampleRate <- parameterList[["subsample"]]
    currentDepth <- parameterList[["max_depth"]]
    currentEta <- parameterList[["eta"]]
    currentMinChild <- parameterList[["min_child_weight"]]
    currentgamma<- parameterList[["gamma"]]
    xgboostModelCV_apu_METhours <- xgb.cv(data =  dtrain_apu_METhours, nrounds = 1000 , nfold = 5, showsd = TRUE, 
                                          verbose = TRUE, 
                                          objective="reg:linear",
                                          metrics = "rmse",
                                          eval_metric="rmse", 
                                          "max.depth" = currentDepth, 
                                          "eta" = currentEta,                               
                                          "subsample" = currentSubsampleRate, 
                                          "gamma" = currentgamma,
                                          print_every_n = 10, 
                                          "min_child_weight" = currentMinChild, 
                                          booster = "gbtree",
                                          early_stopping_rounds = 10)
    
    
    xvalidationScores_apu_METhours <- as.data.frame(xgboostModelCV_apu_METhours$evaluation_log)
    rmse_apu_METhours <- tail(xvalidationScores_apu_METhours$test_rmse_mean, 1)
    trmse_apu_METhours <- tail(xvalidationScores_apu_METhours$train_rmse_mean,1)
    output_apu_METhours <- return(c(rmse_apu_METhours, trmse_apu_METhours,currentSubsampleRate, currentgamma, currentDepth, currentEta, currentMinChild))}))

output_apu_METhours <- as.data.frame(t(rmseErrorssHyperparameters_apu_METhours))
varnames <- c("TestRMSE", "TrainRMSE", "SubSampRate", "Gamma", "Depth", "eta", "currentMinChild")
names(output_apu_METhours) <- varnames
head(output_apu_METhours)


fit_tuned_apu_METhours <- xgboost(data = train_data_apu_METhours , label = train_label_apu_METhours,
                                  nrounds = 3000,
                                  verbose = TRUE, 
                                  objective="reg:linear",
                                  metrics = "rmse",
                                  max.depth= 4, 
                                  eta = 0.025,                               
                                  subsample = 0.25, 
                                  gamma = 1,
                                  min_child_weight = 1, 
                                  booster = "gbtree")

mytrain_rmse <-(fit_tuned_apu_METhours$evaluation_log$train_rmse)^2
for(k in 21:length(mytrain_rmse)){
  if(mytrain_rmse[k]< 0.99 * mean(mytrain_rmse[(k-21):(k-1)])){
    print(k)
  }
}

final_model_apu_METhours <- xgboost(data = train_data_apu_METhours , label = train_label_apu_METhours,
                                    nrounds = 56,
                                    verbose = TRUE, 
                                    objective="reg:linear",
                                    metrics = "rmse",
                                    max.depth= 4, 
                                    eta = 0.025,                               
                                    subsample = 0.25, 
                                    gamma = 1,
                                    min_child_weight = 1, 
                                    booster = "gbtree")
pred_apu_METhours <- predict(final_model_apu_METhours, test_data_apu_METhours)

caret::RMSE(test_label_apu_METhours, pred_apu_METhours)

shap_apu_METhours <- shapviz(final_model_apu_METhours , X_pred = train_data_apu_METhours)
mean_shap_apu_METhours<- data.frame(colMeans(abs(data.frame(get_shap_values(shap_apu_METhours)))))
write.csv(mean_shap_apu_METhours, "mean_shap_apu_METhours.csv", row.names=TRUE)

hist_apu_METhours_bee<-sv_importance(shap_apu_METhours, kind = "bar", show_numbers=TRUE, bee_width = 0.2, max_display = 10L)+ 
  theme(axis.line.y = element_line(colour = "black"), axis.text.y = element_text(colour = "black", size=10),axis.title.x=element_text(size=10),
        axis.line.x = element_line(colour = "black"), panel.grid.major = element_blank(), plot.title.position = "plot",panel.background = element_blank())+
  ggtitle("E. outcome: LTPA")+xlab("mean(|SHAP value|)")


shap_apu_METhours_2 <- shap.prep(final_model_apu_METhours , X_train = train_data_apu_METhours)

shap_apu_METhours_dep_1<-shap.plot.dependence(data_long = shap_apu_METhours_2 , "count_pocketparks_800")+ ylab("SHAP value") + 
  geom_point(color='#B28282', size=2, stroke = 0)+ geom_smooth(color="#b14e53", se = FALSE) + geom_hline(yintercept = 0, color = "gray", linetype='dashed')+ 
  theme(  axis.title.x=element_text( size=10),  axis.title.y=element_text(size=10), aspect.ratio=1/2.2, plot.title.position = "plot",
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank())+ggtitle("F. outcome: LTPA")+scale_x_continuous(breaks=seq(0,12,2))

shap_apu_METhours_dep_2<-shap.plot.dependence(data_long = shap_apu_METhours_2 , "sumarea_pocketparks_800")+ ylab("SHAP value") + 
  geom_point(color='#B28282', size=2, stroke = 0)+ geom_smooth(color="#b14e53", se = FALSE) + geom_hline(yintercept = 0, color = "gray", linetype='dashed')+ 
  theme(  axis.title.x=element_text( size=10),  axis.title.y=element_text(size=10), aspect.ratio=1/2.2, plot.title.position = "plot",
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank())+ggtitle("G. outcome: LTPA")

shap_apu_METhours_dep_3<-shap.plot.dependence(data_long = shap_apu_METhours_2 , "ints_500")+ ylab("SHAP value") + 
  geom_point(color='#B28282', size=2, stroke = 0)+ geom_smooth(color="#b14e53", se = FALSE) + geom_hline(yintercept = 0, color = "gray", linetype='dashed')+ 
  theme(  axis.title.x=element_text( size=10),  axis.title.y=element_text(size=10), aspect.ratio=1/2.2, plot.title.position = "plot",
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank())+ggtitle("H. outcome: LTPA")


shap_apu_METhours_dep<-ggarrange(shap_apu_METhours_dep_1, shap_apu_METhours_dep_2, shap_apu_METhours_dep_3,
                                 ncol = 1, nrow = 3,align="hv",
                                 common.legend =FALSE)



shap_apu_METhours_interaction <- shap.prep.interaction(final_model_apu_METhours , X_train = train_data_apu_METhours)

shap_apu_METhours_mean_interaction<-as.data.frame(apply(shap_apu_METhours_interaction, c(2, 3), function(x) mean(abs(x))))
shap_apu_METhours_mean_interaction$BIAS=NULL


shap_apu_METhours_mean_interaction <- shap_apu_METhours_mean_interaction[!(row.names(shap_apu_METhours_mean_interaction) 
                                                                           %in% c("BIAS")),]

get_lower_tri<-function(cormat){
  cormat[upper.tri(cormat)] <- NA
  return(cormat)
}

lower_shap_apu_METhours_mean_interaction <- get_lower_tri(as.matrix(shap_apu_METhours_mean_interaction))
melted_shap_apu_METhours_mean_interaction  <-melt(lower_shap_apu_METhours_mean_interaction, na.rm = TRUE)
melted_shap_apu_METhours_mean_interaction<-melted_shap_apu_METhours_mean_interaction%>% drop_na()

interaction_apu_METhours<-ggplot(data = melted_shap_apu_METhours_mean_interaction, aes(x=X1, y=X2, fill=value)) + 
  geom_tile(color = "white")+scale_fill_gradient2( high = "#b1182c",  mid = "#f5f5f5", 
                                                   midpoint = 0, limit = c(0,0.01169), space = "Lab", 
                                                   name="mean(|SHAP interaction value|)") +   theme_minimal()+ 
  theme(axis.text.x = element_text(angle = 35, vjust = 1.1, size = 8, hjust = 1), axis.text.y = element_text(size = 8))+
  coord_fixed() +labs(y= " ", x = " ") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                                               legend.title = element_text(vjust =0.9),plot.title.position =  "plot")
