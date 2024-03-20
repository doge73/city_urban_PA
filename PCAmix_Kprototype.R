split <- splitmix(urbanset)
pcamix <- PCAmix(X.quanti=split$X.quanti,
                 X.quali=split$X.quali,
                 rename.level=TRUE, 
                 graph=FALSE, ndim=2)

pcamix$eig
coord.var <- as.data.frame(pcamix$ind$coord[,1:2])
coord.var$person_nb<-rownames(coord.var)

coord.var$'dim 1'<-scale(coord.var$'dim 1')
coord.var$'dim 2'<-scale(coord.var$'dim 2')
coord.var$x<-as.numeric(coord.var$'dim 1')
coord.var$y<-as.numeric(coord.var$'dim 2')
print(coord.var)


urbanset<- urbanset[!(row.names(urbanset ) %in% c("119621", "134591", "124814")),]
validation<-validation_kproto(method="silhouette", k=2:10, kp_obj= "optimal", data=urbanset, na.rm="imp.onestep",  nstart=10)
k_cluster<-kproto(urbanset,3,iter.max=1000, na.rm="imp.onestep", nstart=10)
k_cluster$tot.withinss

cluster<- factor(k_cluster$cluster, order =  TRUE,
                 levels = c(1:3))
urban_PA_cluster_f <- data.frame(urbanset, cluster)
urban_PA_cluster_f$person_nb<-as.numeric(row.names(urban_PA_cluster_f))