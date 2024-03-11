#PSYC 86001 SEM at CUNY GC Spring 2024 Assignment 2

#Install and Load in Necessary Packages
install.packages(laavan, dependencies = TRUE)
library(laavan)
install.packages(lavaanPlot, dependencies = TRUE)
library(lavaanPlot)

#Loading in the Data/Input Correlation Matrix
cor.tri <- '
1.00
0.77     1.00
0.25     0.26     1.00
0.57     0.52     0.37     1.00
'

#Generate Variable Titled cor.table and Input Triangular Elements of Covariance Matrix
cor.table <- getCov(cor.tri, names=c("Parenting", "Teaching", "Learning", "ExamPerf"))

#Generate Output for cor.table in Console
cor.table

#Specify Path Model (path.model1) without Error
path.model1 <- ' 
ExamPerf ~ c*Learning
Learning ~ a*Parenting + b*Teaching
'

#Fit Model 1 with Sample Size at 1000
path.fit1 <-sem(model=path.model1, sample.cov=cor.table, sample.nobs = 1000)

#Summarizing the Results of Model 1 (path.fit1)

#Extract Parameters
parTable(path.fit1)

#Parameter Estimates for Model 1
parameterEstimates(path.fit1)

#Return Standardized Parameter Estimates
standardizedSolution(path.fit1)

#Model 1 Output 
summary(path.fit1, rsquare=TRUE, standardized=TRUE, ci=TRUE)

#Plot Fitted SEM 
lavaanPlot::lavaanPlot(model=path.fit1, node_options = list(shape='box', fontname= 'Helvetica'),
                       edge_options = list(color='black'), coefs=T, stand = T,  covs = F,
                       graph_options = list(overlap = F))


#Specify Path Model (path.model1) with Indirect Effects without Error
path.model1_Indirect_Effects <- ' 
ExamPerf ~ c*Learning
Learning ~ a*Parenting + b*Teaching
ind1 := a*c
ind2 := b*c
'
#Summary of Results 
summary(path.fit1, rsquare=TRUE, standardized=TRUE, ci=TRUE)


#Specifying Model 2 (path.fit2)
path.model2 <-'
ExamPerf ~ e*Teaching + c*Learning + d*Parenting
Learning ~ a*Parenting + b*Teaching
'

#Fit Model 2
path.fit2 <-sem(model=path.model2,sample.cov=cor.table,sample.nobs=1000)

#Summarizing the Results of Model 2 (path.fit2)

#Extract Parameters
parTable(path.fit2)

#Parameter Estimates for Model 2
parameterEstimates(path.fit2)

#Return Standardized Parameter Estimates
standardizedSolution(path.fit2)

#Model 2 Output
summary(path.fit2, rsquare=TRUE, standardized=TRUE, ci=TRUE)

#Plot Fitted SEM 
lavaanPlot::lavaanPlot(model=path.fit2, node_options = list(shape='box', fontname= 'Helvetica'),
                       edge_options = list(color='black'), coefs=T, stand = T,  covs = F,
                       graph_options = list(overlap = F))


#Specifying Model 2 (path.fit2) with Indirect Effects
path.model2 <-'
ExamPerf ~ e*Teaching + c*Learning + d*Parenting
Learning ~ a*Parenting + b*Teaching
ind1 :=a:c
ind2 :=b:c
'

#Summary of Results/Model 2 Output for Indirect Effects
summary(path.fit2, rsquare=TRUE, standardized=TRUE, ci=TRUE)

##END ------------------------------------------------------------------------------------------- ##END 
