data.file=file.path("train.csv")
data=read.table(data.file,header=T,sep=",")

data$Name<-NULL
data$PassengerId<-NULL
data$Ticket=NULL
data$Cabin=NULL
#data$Embarked=NULL

data$Survived<-as.factor(data$Survived)
data$Pclass<-as.factor(data$Pclass)

mu=mean(data$Age,na.rm=T)
mu_fare=mean(data$Fare)
data$Age[is.na(data$Age)]<-mu
#class=data$Survived
#data$Survived=NULL
#data<-cbind(data,Survived=class)

levels(data$Embarked)<-list(C="C",Q="Q",S="S")
data=data[!is.na(data$Embarked),]

library(randomForest)
library(caret)
#inTrain<-createDataPartition(data$Survived,p=0.75,list=F)
#train<-data[inTrain,]
#test<-data[-inTrain,]
#modelfit=randomForest(Survived~.,data=train)
modelfit=randomForest(Survived~.,data=data)
#pred<-predict(modelfit,newdata=test)
#confusionMatrix(pred,test$Survived)

data.file=file.path("test.csv")
data=read.table(data.file,header=T,sep=",")

data$Name<-NULL
ID<-data$PassengerId
data$PassengerId<-NULL
data$Ticket=NULL
data$Cabin=NULL
#data$Embarked=NULL

data$Pclass<-as.factor(data$Pclass)

data$Age[is.na(data$Age)]<-mu
data$Fare[is.na(data$Fare)]<-mu_fare
pred<-predict(modelfit,newdata=data)

res=data.frame(PassengerId=ID,Survived=pred)
write.table(res,file="result.csv",quote=F,row.names=F,sep=",")
