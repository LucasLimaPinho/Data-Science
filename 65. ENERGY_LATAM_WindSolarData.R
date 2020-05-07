library(data.table)
library(corrplot)
library(descr)
library(fitdistrplus)
library(knitr)
library(ggplot2)
library(xlsx)
library(mosaic)
library(WriteXLS)
library(nortest)

load("C:/Users/Francisco/Desktop/BID/WorkspaceBID.RData")



##PARTE DA IMPORTACAO###
setwd("C:/Users/Francisco/Desktop/BID/Eolica")
Eolica <- read.csv("WIND_AR_A01_035-040.csv")
Eolica$DateTime <- as.POSIXct(Eolica$DateTime,format = '%d/%m/%Y %H:%M')
Eolica$Ano <- as.numeric(format(Eolica$DateTime,'%Y')) 
Eolica$Mes <- as.numeric(format(Eolica$DateTime,'%m'))
Eolica$Dia <- as.numeric(format(Eolica$DateTime,'%d'))
Eolica$Hora <- as.numeric(format(Eolica$DateTime,'%H'))
Eolica <- Eolica[,-(1:2)]
tempEol<-list.files(pattern="*.csv",full.names=TRUE)
for (i in 1:length(tempEol)) {
    temp2 = read.csv(tempEol[i])
    Eolica[i+4] <- as.double(temp2$Value)
    names(Eolica)[i+4] <- gsub(".csv","",tempEol[i])
}

setwd("C:/Users/Francisco/Desktop/BID/Solar")
Solar <- read.csv("SOLAR_AR_A01_000-175.csv")
tempSolar<-list.files(pattern="*.csv",full.names=TRUE)
for (i in 1:length(tempSolar)){
  temp2 = read.csv(tempSolar[i])
  Solar[i+1] <- as.double(temp2$Value)
  names(Solar)[i+1] <- gsub(".csv","",tempSolar[i])
}

###OBTENCAO DA MATRIZ DE CORRELAÇÃO. A FUNÇÃO CORRPLOT PLOTA O CORRELOGRAMA
Total <- data.frame(Eolica,Solar[,-1])


for (i in 5:length(Total)){
  Total[i] <- ts(Total[i],frequency=8760,start=c(2016,1))
}
##OBTENÇÃO DOS PERFIS HORARIOS
#PerfilHorario2 <- matrix(NA,nrow=12*24,ncol=length(Total2)+2)
#PerfilHorario2[,1] <- gl(12,24)
#aux <- 0:23
#PerfilHorario2[,2] <- rep.int(aux,12)
#aux<-1
#colnames(PerfilHorario2) <- c("Mes","Hora",tempEol,tempSolar)
#for (j in 5:length(Total)){
 # for (mes in 1:12){
#    for (i in 0:23){
      
#      temp <- sapply(split(Total[,j], f=(Total$Mes==mes & Total$Hora==i)),mean)
 #     PerfilHorario2[aux,j-2] <- temp[2]
#      aux <- aux+1
#    }
      
  #}
 # aux <- 1
#}

##OBTENÇÃO DO PERFIL HORÁRIO MODO ALTERNATIVO


Hora <- rep.int(0:23,12)
aux <- c("Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto",
           "Setembro","Outubro","Novembro","Dezembro")
Meses <- gl(12,24,labels=aux)
PerfilHorario <- data.frame(Meses,Hora)
temp2 <-c()
for (j in 5:length(Total)){
  for (mes in 1:12){
    for (i in 0:23){
      temp <- sapply(split(Total[,j], f=(Total$Mes==mes & Total$Hora==i)),mean)
      temp2 <- rbind(temp2,temp[2])
    }
    
  }
  PerfilHorario <- cbind(PerfilHorario,temp2)
  temp2 <-c()
}
colnames(PerfilHorario) <- c("Mes","Hora",tempEol,tempSolar)



     
##OBTENÇÃO DAS MÉDIAS MENSAIS, PERFIL ANUAL CAPTURANDO SAZONALIDE

PerfilAnual <- data.frame(aux)
temp2<-c()
for (j in 5:length(Total)){
  for (mes in 1:12){
      temp <- sapply(split(Total[,j],Total$Mes==mes),mean)
      temp2 <- rbind(temp2,temp[2])
  }
  PerfilAnual <- cbind(PerfilAnual,temp2)
  temp2 <-c()
}
colnames(PerfilAnual) <- c("Meses",tempEol,tempSolar)

##Variação Inter-Anual da Geração Eólica! Fatores de Capacidade médios para cada Ano

Anos <- 2016:2030
VarInterAnual <- data.frame(Anos)
temp2 <- c()
for (j in 5:length(Total)){
  for (anos in 2016:2030){
    temp <- sapply(split(Total[,j],Total$Ano==anos),mean)
    temp2 <- rbind(temp2,temp[2])
  }
  VarInterAnual <- cbind(VarInterAnual,temp2)
  temp2 <-c()
}

colnames(VarInterAnual) <- c("Anos",tempEol,tempSolar)

#Variação da Geração Mensal ao Longo dos Anos

Meses2 <- gl(12,15,labels=aux)
VarMensInterAnual <- data.frame(Meses2,Anos)
temp2 <- c()
for (j in 5:length(Total)){
  for (mes in 1:12){
  for (anos in 2016:2030){
    temp <- sapply(split(Total[,j],f=(Total$Ano==anos & Total$Mes == mes)),mean)
    temp2 <- rbind(temp2,temp[2])
  }

  }
  VarMensInterAnual <- cbind(VarMensInterAnual,temp2)
  temp2 <-c()
}
colnames(VarMensInterAnual) <- c("Meses","Anos",tempEol,tempSolar)

## Perfil ao longo do ano para diversos anos


aux2 <- gl(15,12,labels=Anos)
PerfilAnual.VarInterAnual <- data.frame(aux2,aux)
temp2<-c()
for (j in 5:length(Total)){
  for (anos in 2016:2030){
    for (mes in 1:12){
    temp <- sapply(split(Total[,j],f = (Total$Mes==mes & Total$Ano == anos)),mean)
    temp2 <- rbind(temp2,temp[2])
    }

  }
  PerfilAnual.VarInterAnual <- cbind(PerfilAnual.VarInterAnual,temp2)
  temp2 <-c()
}
colnames(PerfilAnual.VarInterAnual) <- c("Ano","Mes",tempEol,tempSolar)


#MATRIZES DE CORRELACAO

matrizCorrelacoesSerieTemporal <- cor(Total[,-(1:4)])
matrizCorrelacoesHorario <- cor(PerfilHorario[,-(1:2)])
matrizCorrelacoesAnual <- cor(PerfilAnual[,-1])
matrizCorrelacoesVarInterAnual <- cor(VarInterAnual[,-1])
####################

###Exportando para o Excel

setwd("C:/Users/Francisco/Desktop/BID")

write.xlsx(PerfilHorario, file ="PerfilHorario.xlsx")
write.xlsx(PerfilAnual, file ="PerfilAnual.xlsx")
write.xlsx(VarInterAnual, file ="VariacaoInterAnual.xlsx")
write.xlsx(VarMensInterAnual, file ="Variacao_Mensal_InterAnual.xlsx")
write.xlsx(PerfilAnual.VarInterAnual, file ="PerfilAnual_VariacaoInterAnual.xlsx")
write.xlsx(matrizCorrelacoesAnual, file ="Matriz_Correlacoes_PerfilAnual.xlsx")
write.xlsx(matrizCorrelacoesHorario, file ="Matriz_Correlacoes_PerfilHorario.xlsx")
write.xlsx(matrizCorrelacoesSerieTemporal, file ="Matriz_Correlacoes_SerieTemporal.xlsx")
write.xlsx(matrizCorrelacoesVarInterAnual, file ="Matriz_Correlacoes_VarInterAnual.xlsx")

write.xlsx((tempSolar), file = "CapacidadeSolar2.xlsx")

##############################################################################################

##Importando as capacidades instaláveis
setwd("C:/Users/Francisco/Desktop/BID")
Cap_Eolica <- read.csv("CapacidadeEolica.csv",header = FALSE)
Eolica_Cap <- data.frame(Eolica$Ano,Eolica$Mes,Eolica$Dia,Eolica$Hora)
for (i in 5:length(Eolica)){
  
  Eolica_Cap <- cbind(Eolica_Cap,Eolica[,i]*Cap_Eolica[i-4,1])
}
colnames(Eolica_Cap) <- c("Ano","Mes","Dia","Hora",tempEol)

setwd("C:/Users/Francisco/Desktop/BID")
Cap_Solar <- read.csv("CapacidadeSolar.csv",header = FALSE)
Solar_Cap <- data.frame(Eolica$Ano,Eolica$Mes,Eolica$Dia,Eolica$Hora)
for (i in 2:length(Solar)){
  
  Solar_Cap <- cbind(Solar_Cap,Solar[,i]*Cap_Solar[i-1,1])
}
colnames(Solar_Cap) <- c(tempSolar)
Solar_Cap <- Solar_Cap[,-(1:4)]
colnames(Solar_Cap) <- c(tempSolar)
Total_Cap <- data.frame(Eolica_Cap,Solar_Cap)


##Aglutinacao de áreas por energia para eólica

temp2AR <- c()
temp2BO<- c()
temp2BR<- c()
temp2CL<- c()
temp2CO<- c()
temp2CR<- c()
temp2EC<- c()
temp2ES<- c()
temp2GU<- c()
temp2HO<- c()
temp2MX<- c()
temp2NI<- c()
temp2PA<- c()
temp2PE<- c()
temp2PY<- c()
temp2SU<- c()
temp2UY<- c()
temp2VE<- c()
tempnamesAR<- c()
tempnamesBO<- c()
tempnamesBR<- c()
tempnamesCL<- c()
tempnamesCO<- c()
tempnamesCR<- c()
tempnamesEC<- c()
tempnamesES<- c()
tempnamesGU<- c()
tempnamesHO<- c()
tempnamesMX<- c()
tempnamesNI<- c()
tempnamesPA<- c()
tempnamesPE<- c()
tempnamesPY<- c()
tempnamesSU<- c()
tempnamesUY<- c()
tempnamesVE<- c()
Total.Cap.Area <- data.frame(Eolica$Ano,Eolica$Mes,Eolica$Dia,Eolica$Hora)
for (i in 1:10){
  tempAR <- Total_Cap[,grep(paste0("WIND_AR_A0",i),names(Total_Cap))]
  tempnamesAR <- cbind(tempnamesAR,paste0("WIND_AR_A0",i))
  if (!is.null(ncol(tempAR))) tempAR <- rowSums(tempAR)
  temp2AR <- cbind(temp2AR,tempAR)
  tempBO <- Total_Cap[,grep(paste0("WIND_BO_A0",i),names(Total_Cap))]
  tempnamesBO <- cbind(tempnamesBO,paste0("WIND_BO_A0",i))
  if (!is.null(ncol(tempBO)))tempBO <- rowSums(tempBO)
  temp2BO <- cbind(temp2BO,tempBO)
  tempBR <- Total_Cap[,grep(paste0("WIND_BR_A0",i),names(Total_Cap))]
  tempnamesBR <- cbind(tempnamesBR,paste0("WIND_BR_A0",i))
  if (!is.null(ncol(tempBR)))tempBR <- rowSums(tempBR)
  temp2BR <- cbind(temp2BR,tempBR)
  if (i==10){
    tempBR <- Total_Cap[,grep("WIND_BR_A10",names(Total_Cap))]
    tempnamesBR <- cbind(tempnamesBR,"WIND_BR_A10")
    if (!is.null(ncol(tempBR)))tempBR <- rowSums(tempBR)
    temp2BR <- cbind(temp2BR,tempBR)
    
  }

  tempCL <- Total_Cap[,grep(paste0("WIND_CL_A0",i),names(Total_Cap))]
  tempnamesCL <- cbind(tempnamesCL,paste0("WIND_CL_A0",i))
  if (!is.null(ncol(tempCL))) tempCL <- rowSums(tempCL)
  temp2CL <- cbind(temp2CL,tempCL)
  tempCO <- Total_Cap[,grep(paste0("WIND_CO_A0",i),names(Total_Cap))]
  tempnamesCO <- cbind(tempnamesCO,paste0("WIND_CO_A0",i))
  if (!is.null(ncol(tempCO)))tempCO <- rowSums(tempCO)
  temp2CO <- cbind(temp2CO,tempCO)
  tempCR <- Total_Cap[,grep(paste0("WIND_CR_A0",i),names(Total_Cap))]
  tempnamesCR <- cbind(tempnamesCR,paste0("WIND_CR_A0",i))
  if (!is.null(ncol(tempCR)))tempCR <- rowSums(tempCR)
  temp2CR <- cbind(temp2CR,tempCR)
  tempEC <- Total_Cap[,grep(paste0("WIND_EC_A0",i),names(Total_Cap))]
  tempnamesEC <- cbind(tempnamesEC,paste0("WIND_EC_A0",i))
  if (!is.null(ncol(tempEC)))tempEC <- rowSums(tempEC)
  temp2EC <- cbind(temp2EC,tempEC)
  tempES <- Total_Cap[,grep(paste0("WIND_ES_A0",i),names(Total_Cap))]
  tempnamesES <- cbind(tempnamesES,paste0("WIND_ES_A0",i))
  if (!is.null(ncol(tempES)))tempES <- rowSums(tempES)
  temp2ES <- cbind(temp2ES,tempES)
  tempGU <- Total_Cap[,grep(paste0("WIND_GU_A0",i),names(Total_Cap))]
  tempnamesGU <- cbind(tempnamesGU,paste0("WIND_GU_A0",i))
  if (!is.null(ncol(tempGU)))tempGU <- rowSums(tempGU)
  temp2GU <- cbind(temp2GU,tempGU)
  tempHO <- Total_Cap[,grep(paste0("WIND_HO_A0",i),names(Total_Cap))]
  tempnamesHO <- cbind(tempnamesHO,paste0("WIND_HO_A0",i))
  if (!is.null(ncol(tempHO)))tempHO <- rowSums(tempHO)
  temp2HO <- cbind(temp2HO,tempHO)
  tempMX <- Total_Cap[,grep(paste0("WIND_MX_A0",i),names(Total_Cap))]
  tempnamesMX <- cbind(tempnamesMX,paste0("WIND_MX_A0",i))
  if (!is.null(ncol(tempMX)))tempMX <- rowSums(tempMX)
  temp2MX <- cbind(temp2MX,tempMX)
  tempNI <- Total_Cap[,grep(paste0("WIND_NI_A0",i),names(Total_Cap))]
  tempnamesNI <- cbind(tempnamesNI,paste0("WIND_NI_A0",i))
  if (!is.null(ncol(tempNI)))tempNI <- rowSums(tempNI)
  temp2NI <- cbind(temp2NI,tempNI)
  tempPA <- Total_Cap[,grep(paste0("WIND_PA_A0",i),names(Total_Cap))]
  tempnamesPA <- cbind(tempnamesPA,paste0("WIND_PA_A0",i))
  if (!is.null(ncol(tempPA)))tempPA <- rowSums(tempPA)
  temp2PA <- cbind(temp2PA,tempPA)
  tempPE <- Total_Cap[,grep(paste0("WIND_PE_A0",i),names(Total_Cap))]
  tempnamesPE <- cbind(tempnamesPE,paste0("WIND_PE_A0",i))
  if (!is.null(ncol(tempPE)))tempPE <- rowSums(tempPE)
  temp2PE <- cbind(temp2PE,tempPE)
  tempPY <- Total_Cap[,grep(paste0("WIND_PY_A0",i),names(Total_Cap))]
  tempnamesPY <- cbind(tempnamesPY,paste0("WIND_PY_A0",i))
  if (!is.null(ncol(tempPY)))tempPY <- rowSums(tempPY)
  temp2PY <- cbind(temp2PY,tempPY)
  tempSU <- Total_Cap[,grep(paste0("WIND_SU_A0",i),names(Total_Cap))]
  tempnamesSU <- cbind(tempnamesSU,paste0("WIND_SU_A0",i))
  if (!is.null(ncol(tempSU)))tempSU <- rowSums(tempSU)
  temp2SU <- cbind(temp2SU,tempSU)
  tempUY <- Total_Cap[,grep(paste0("WIND_UY_A0",i),names(Total_Cap))]
  tempnamesUY <- cbind(tempnamesUY,paste0("WIND_UY_A0",i))
  if (!is.null(ncol(tempUY)))tempUY <- rowSums(tempUY)
  temp2UY <- cbind(temp2UY,tempUY)
  tempVE <- Total_Cap[,grep(paste0("WIND_VE_A0",i),names(Total_Cap))]
  tempnamesVE <- cbind(tempnamesVE,paste0("WIND_VE_A0",i))
  if (!is.null(ncol(tempVE)))tempVE <- rowSums(tempVE)
  temp2VE <- cbind(temp2VE,tempVE)
  
  
}



Total.Cap.Area <- data.frame(Total.Cap.Area,temp2AR,temp2BO,temp2BR,temp2CL,temp2CO,temp2CR,temp2EC,temp2ES,temp2GU,temp2HO,temp2MX,temp2NI,temp2PA,temp2PE,temp2PY,temp2SU,temp2UY,temp2VE)
tempEolica.Area <- c(tempnamesAR,tempnamesBO,tempnamesBR,tempnamesCL,tempnamesCO,tempnamesCR,tempnamesEC,tempnamesES,tempnamesGU,tempnamesHO,tempnamesMX,tempnamesNI,tempnamesPA,tempnamesPE,tempnamesPY,tempnamesSU,tempnamesUY,tempnamesVE)
colnames(Total.Cap.Area) <- c("Ano","Mes","Dia","Hora",tempEolica.Area)
remove(temp2AR,temp2BO,temp2BR,temp2CL,temp2CO,temp2CR,temp2EC,temp2ES,temp2GU,temp2HO,temp2MX,temp2NI,temp2PA,temp2PE,temp2PY,temp2SU,temp2UY,temp2VE)
remove(tempnamesAR,tempnamesBO,tempnamesBR,tempnamesCL,tempnamesCO,tempnamesCR,tempnamesEC,tempnamesES,tempnamesGU,tempnamesHO,tempnamesMX,tempnamesNI,tempnamesPA,tempnamesPE,tempnamesPY,tempnamesSU,tempnamesUY,tempnamesVE)
contador <- c()
for (j in 5:length(Total.Cap.Area)){
  if (sum(Total.Cap.Area[(1:10),j] == 0)){
    contador <- c(contador,j)
  }
}
Total.Cap.Area <- Total.Cap.Area [,-contador]

temp2AR <- c()
temp2BO<- c()
temp2BR<- c()
temp2CL<- c()
temp2CO<- c()
temp2CR<- c()
temp2EC<- c()
temp2ES<- c()
temp2GU<- c()
temp2HO<- c()
temp2MX<- c()
temp2NI<- c()
temp2PA<- c()
temp2PE<- c()
temp2PY<- c()
temp2SU<- c()
temp2UY<- c()
temp2VE<- c()
tempnamesAR<- c()
tempnamesBO<- c()
tempnamesBR<- c()
tempnamesCL<- c()
tempnamesCO<- c()
tempnamesCR<- c()
tempnamesEC<- c()
tempnamesES<- c()
tempnamesGU<- c()
tempnamesHO<- c()
tempnamesMX<- c()
tempnamesNI<- c()
tempnamesPA<- c()
tempnamesPE<- c()
tempnamesPY<- c()
tempnamesSU<- c()
tempnamesUY<- c()
tempnamesVE<- c()
Total.Cap.Area2 <-data.frame(Eolica$Ano)
for (i in 1:10){
  tempAR <- Total_Cap[,grep(paste0("SOLAR_AR_A0",i),names(Total_Cap))]
  tempnamesAR <- cbind(tempnamesAR,paste0("SOLAR_AR_A0",i))
  if (!is.null(ncol(tempAR))) tempAR <- rowSums(tempAR)
  temp2AR <- cbind(temp2AR,tempAR)
  tempBR <- Total_Cap[,grep(paste0("SOLAR_BR_A0",i),names(Total_Cap))]
  tempnamesBR <- cbind(tempnamesBR,paste0("SOLAR_BR_A0",i))
  if (!is.null(ncol(tempBR)))tempBR <- rowSums(tempBR)
  temp2BR <- cbind(temp2BR,tempBR)
  tempCL <- Total_Cap[,grep(paste0("SOLAR_CL_A0",i),names(Total_Cap))]
  tempnamesCL <- cbind(tempnamesCL,paste0("SOLAR_CL_A0",i))
  if (!is.null(ncol(tempCL))) tempCL <- rowSums(tempCL)
  temp2CL <- cbind(temp2CL,tempCL)
  tempCO <- Total_Cap[,grep(paste0("SOLAR_CO_A0",i),names(Total_Cap))]
  tempnamesCO <- cbind(tempnamesCO,paste0("SOLAR_CO_A0",i))
  if (!is.null(ncol(tempCO)))tempCO <- rowSums(tempCO)
  temp2CO <- cbind(temp2CO,tempCO)
  tempEC <- Total_Cap[,grep(paste0("SOLAR_EC_A0",i),names(Total_Cap))]
  tempnamesEC <- cbind(tempnamesEC,paste0("SOLAR_EC_A0",i))
  if (!is.null(ncol(tempEC)))tempEC <- rowSums(tempEC)
  temp2EC <- cbind(temp2EC,tempEC)
  tempES <- Total_Cap[,grep(paste0("SOLAR_ES_A0",i),names(Total_Cap))]
  tempnamesES <- cbind(tempnamesES,paste0("SOLAR_ES_A0",i))
  if (!is.null(ncol(tempES)))tempES <- rowSums(tempES)
  temp2ES <- cbind(temp2ES,tempES)
  tempGU <- Total_Cap[,grep(paste0("SOLAR_GY_A0",i),names(Total_Cap))]
  tempnamesGU <- cbind(tempnamesGU,paste0("SOLAR_GY_A0",i))
  if (!is.null(ncol(tempGU)))tempGU <- rowSums(tempGU)
  temp2GU <- cbind(temp2GU,tempGU)
  tempMX <- Total_Cap[,grep(paste0("SOLAR_MX_A0",i),names(Total_Cap))]
  tempnamesMX <- cbind(tempnamesMX,paste0("SOLAR_MX_A0",i))
  if (!is.null(ncol(tempMX)))tempMX <- rowSums(tempMX)
  temp2MX <- cbind(temp2MX,tempMX)
  tempPA <- Total_Cap[,grep(paste0("SOLAR_PA_A0",i),names(Total_Cap))]
  tempnamesPA <- cbind(tempnamesPA,paste0("SOLAR_PA_A0",i))
  if (!is.null(ncol(tempPA)))tempPA <- rowSums(tempPA)
  temp2PA <- cbind(temp2PA,tempPA)
  tempPE <- Total_Cap[,grep(paste0("SOLAR_PE_A0",i),names(Total_Cap))]
  tempnamesPE <- cbind(tempnamesPE,paste0("SOLAR_PE_A0",i))
  if (!is.null(ncol(tempPE)))tempPE <- rowSums(tempPE)
  temp2PE <- cbind(temp2PE,tempPE)
  tempPY <- Total_Cap[,grep(paste0("SOLAR_PY_A0",i),names(Total_Cap))]
  tempnamesPY <- cbind(tempnamesPY,paste0("SOLAR_PY_A0",i))
  if (!is.null(ncol(tempPY)))tempPY <- rowSums(tempPY)
  temp2PY <- cbind(temp2PY,tempPY)
  tempSU <- Total_Cap[,grep(paste0("SOLAR_SU_A0",i),names(Total_Cap))]
  tempUY <- Total_Cap[,grep(paste0("SOLAR_UY_A0",i),names(Total_Cap))]
  tempnamesUY <- cbind(tempnamesUY,paste0("SOLAR_UY_A0",i))
  if (!is.null(ncol(tempUY)))tempUY <- rowSums(tempUY)
  temp2UY <- cbind(temp2UY,tempUY)
  tempVE <- Total_Cap[,grep(paste0("SOLAR_VE_A0",i),names(Total_Cap))]
  tempnamesVE <- cbind(tempnamesVE,paste0("SOLAR_VE_A0",i))
  if (!is.null(ncol(tempVE)))tempVE <- rowSums(tempVE)
  temp2VE <- cbind(temp2VE,tempVE)
  
  
}
Total.Cap.Area2 <- data.frame(Total.Cap.Area2,temp2AR,temp2BR,temp2CL,temp2CO,temp2EC,temp2ES,temp2GU,temp2MX,temp2PA,temp2PE,temp2PY,temp2UY,temp2VE)
Total.Cap.Area2 <- Total.Cap.Area2[,-1]
tempSolar.Area <- c(tempnamesAR,tempnamesBR,tempnamesCL,tempnamesCO,tempnamesEC,tempnamesES,tempnamesGU,tempnamesMX,tempnamesPA,tempnamesPE,tempnamesPY,tempnamesUY,tempnamesVE)
colnames(Total.Cap.Area2) <- tempSolar.Area
remove(temp2AR,temp2BO,temp2BR,temp2CL,temp2CO,temp2CR,temp2EC,temp2ES,temp2GU,temp2HO,temp2MX,temp2NI,temp2PA,temp2PE,temp2PY,temp2SU,temp2UY,temp2VE)
remove(tempnamesAR,tempnamesBO,tempnamesBR,tempnamesCL,tempnamesCO,tempnamesCR,tempnamesEC,tempnamesES,tempnamesGU,tempnamesHO,tempnamesMX,tempnamesNI,tempnamesPA,tempnamesPE,tempnamesPY,tempnamesSU,tempnamesUY,tempnamesVE)
cont <- c()
cont2 <- c()

for (i in 1:length(Total.Cap.Area2)){
  if (sum(Total.Cap.Area2[,i])==0){
    cont <- c(cont,i)
  }
}


Total.Cap.Area2 <- Total.Cap.Area2[,-cont]
Total.Cap.Area <- data.frame(Total.Cap.Area,Total.Cap.Area2)
colunas <- names(Total.Cap.Area)
colunas <- colunas[-(1:4)]

temp2 <- c()
x<-c()
aux4 <- 2016
for (i in 1:131496){
  if (is.na(Total.Cap.Area[i,1])){
    x <- c(x,i)
    Total.Cap.Area[i,2] <- 0
    Total.Cap.Area[i,1] <- aux4
    aux4<-aux4+1
  }
}


#############################################################################

##OBTENÇÃO DO PERFIL HORÁRIO MODO ALTERNATIVO


Hora <- rep.int(0:23,12)
aux <- c("Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto",
         "Setembro","Outubro","Novembro","Dezembro")
Meses <- gl(12,24,labels=aux)
PerfilHorario.Area <- data.frame(Meses,Hora)
temp2 <-c()
for (j in 5:length(Total.Cap.Area)){
  for (mes in 1:12){
    for (i in 0:23){
      temp <- sapply(split(Total.Cap.Area[,j], f=(Total.Cap.Area$Mes==mes & Total.Cap.Area$Hora==i)),mean)
      temp2 <- rbind(temp2,temp[2])
    }
    
  }
  PerfilHorario.Area <- cbind(PerfilHorario.Area,temp2)
  temp2 <-c()
}
colnames(PerfilHorario.Area) <- c("Mes","Hora",colunas)




##OBTENÇÃO DAS MÉDIAS MENSAIS, PERFIL ANUAL CAPTURANDO SAZONALIDE

PerfilAnual.Area <- data.frame(aux)
temp2<-c()
for (j in 5:length(Total.Cap.Area)){
  for (mes in 1:12){
    temp <- sapply(split(Total.Cap.Area[,j],Total.Cap.Area$Mes==mes),mean)
    temp2 <- rbind(temp2,temp[2])
  }
  PerfilAnual.Area <- cbind(PerfilAnual.Area,temp2)
  temp2 <-c()
}
colnames(PerfilAnual.Area) <- c("Meses",colunas)

##Variação Inter-Anual da Geração Eólica! Fatores de Capacidade médios para cada Ano

Anos <- 2016:2030
VarInterAnual.Area <- data.frame(Anos)
temp2 <- c()
for (j in 5:length(Total.Cap.Area)){
  for (anos in 2016:2030){
    temp <- sapply(split(Total.Cap.Area[,j],Total.Cap.Area$Ano==anos),mean)
    temp2 <- rbind(temp2,temp[2])
  }
  VarInterAnual.Area <- cbind(VarInterAnual.Area,temp2)
  temp2 <-c()
}

colnames(VarInterAnual.Area) <- c("Anos",colunas)

#Variação da Geração Mensal ao Longo dos Anos

Meses2 <- gl(12,15,labels=aux)
VarMensInterAnual.Area <- data.frame(Meses2,Anos)
temp2 <- c()
for (j in 5:length(Total.Cap.Area)){
  for (mes in 1:12){
    for (anos in 2016:2030){
      temp <- sapply(split(Total.Cap.Area[,j],f=(Total.Cap.Area$Ano==anos & Total.Cap.Area$Mes == mes)),mean)
      temp2 <- rbind(temp2,temp[2])
    }
    
  }
  VarMensInterAnual.Area <- cbind(VarMensInterAnual.Area,temp2)
  temp2 <-c()
}
colnames(VarMensInterAnual.Area) <- c("Meses","Anos",colunas)

## Perfil ao longo do ano para diversos anos


aux2 <- gl(15,12,labels=Anos)
PerfilAnual.VarInterAnual.Area <- data.frame(aux2,aux)
temp2<-c()
for (j in 5:length(Total.Cap.Area)){
  for (anos in 2016:2030){
    for (mes in 1:12){
      temp <- sapply(split(Total.Cap.Area[,j],f = (Total.Cap.Area$Mes==mes & Total.Cap.Area$Ano == anos)),mean)
      temp2 <- rbind(temp2,temp[2])
    }
    
  }
  PerfilAnual.VarInterAnual.Area <- cbind(PerfilAnual.VarInterAnual.Area,temp2)
  temp2 <-c()
}
colnames(PerfilAnual.VarInterAnual.Area) <- c("Ano","Mes",colunas)

#MATRIZES DE CORRELACAO

matrizCorrelacoesSerieTemporal.Area <- cor(Total.Cap.Area[,-(1:4)])
matrizCorrelacoesHorario.Area <- cor(PerfilHorario.Area[,-(1:2)])
matrizCorrelacoesAnual.Area <- cor(PerfilAnual.Area[,-1])
matrizCorrelacoesVarInterAnual.Area <- cor(VarInterAnual.Area[,-1])
####################

setwd("C:/Users/Francisco/Desktop/BID")

write.csv2(PerfilHorario.Area, file ="PerfilHorario_Area.csv")
write.csv2(PerfilAnual.Area, file ="PerfilAnual_Area.csv")
write.csv2(VarInterAnual.Area, file ="VariacaoInterAnual_Area.csv")
write.csv2(VarMensInterAnual.Area, file ="Variacao_Mensal_InterAnual_Area.csv")
write.csv2(PerfilAnual.VarInterAnual.Area, file ="PerfilAnual_VariacaoInterAnual_Area.csv")
write.csv2(matrizCorrelacoesAnual.Area, file ="Matriz_Correlacoes_PerfilAnual_Area.csv")
write.csv2(matrizCorrelacoesHorario.Area, file ="Matriz_Correlacoes_PerfilHorario_Area.csv")
write.csv2(matrizCorrelacoesSerieTemporal.Area, file ="Matriz_Correlacoes_SerieTemporal_Area.csv")
write.csv2(matrizCorrelacoesVarInterAnual.Area, file ="Matriz_Correlacoes_VarInterAnual_Area.csv")

aux2 <- gl(15,12,labels=Anos)
VariacaoIA.GeracaoMensal <- data.frame(aux2,aux)
temp2<-c()
for (j in 5:length(Total.Cap.Area)){
  for (anos in 2016:2030){
    for (mes in 1:12){
      temp <- sapply(split(Total.Cap.Area[,j],f = (Total.Cap.Area$Mes==mes & Total.Cap.Area$Ano == anos)),sum)
      temp2 <- rbind(temp2,temp[2])
    }
    
  }
  VariacaoIA.GeracaoMensal <- cbind(VariacaoIA.GeracaoMensal,temp2)
  temp2 <-c()
}
colnames(VariacaoIA.GeracaoMensal) <- c("Ano","Mes",colunas)


VariacaoIA.GeracaoAnual <- data.frame(Anos)
temp2<-c()
for (j in 5:length(Total.Cap.Area)){
  for (anos in 2016:2030){
    
      temp <- sapply(split(Total.Cap.Area[,j],f = (Total.Cap.Area$Ano==anos)),sum)
      temp2 <- rbind(temp2,temp[2])
   
    
  }
  VariacaoIA.GeracaoAnual <- cbind(VariacaoIA.GeracaoAnual,temp2)
  temp2 <-c()
}
colnames(VariacaoIA.GeracaoAnual) <- c("Ano",colunas)

setwd("C:/Users/Francisco/Desktop/BID")

write.csv2(VariacaoIA.GeracaoAnual, file ="VariacaoInterAnual_GeracaoAnual.csv")
write.csv2(VariacaoIA.GeracaoMensal, file ="VariacaoInterAnual_GeracaoMensal.csv")

##############################################################################

GeracaoHoraria <- Total.Cap.Area
temp2 <- c()
GeracaoHoraria<-GeracaoHoraria[-(which(GeracaoHoraria$Mes == 2 & GeracaoHoraria$Dia == 29)),]

for (i in 2016:2030){
  temp <- which(GeracaoHoraria$Ano == i)
  temp2 <- c(temp2,length(temp))
}
horasAno <- 0:8759
GeracaoHoraria <- GeracaoHoraria[,-(2:3)]
GeracaoHoraria[,2] <- rep(horasAno,15)

temp2 <- c()
temp3 <- c()
temp4 <- c()
MediaHoraria <- data.frame(horasAno)
DesvioPadraoHorario <- data.frame(horasAno)
MedianaHoraria <- data.frame(horasAno)
for (j in 3:length(GeracaoHoraria)){
  for(hora in 0:max(horasAno)){
    temp <-GeracaoHoraria[which(GeracaoHoraria$Hora == hora),j]
    temp2 <- rbind(temp2,mean(temp))
    temp3 <- rbind(temp3,sd(temp))
    temp4 <- rbind(temp4,median(temp))
  }
  MediaHoraria <- cbind(MediaHoraria,temp2)
  DesvioPadraoHorario <- cbind(DesvioPadraoHorario,temp3)
  MedianaHoraria <- cbind(MedianaHoraria,temp4)
  temp2 <-c()
  temp3 <-c()
  temp4 <- c()
}
colnames(MediaHoraria) <- names(GeracaoHoraria[,-1])
colnames(DesvioPadraoHorario) <- names(MediaHoraria)
colnames(MedianaHoraria) <- names(MediaHoraria)
matrizCorrelacoes.MediaHoraria <- cor(MediaHoraria[,-1])
matrizCorrelacoes.DesvioPadraoHorario <- cor(DesvioPadraoHorario[,-1])
matrizCorrelacoes.MedianaHoraria <- cor(MedianaHoraria[,-1])


setwd("C:/Users/Francisco/Desktop/BID")
write.csv2(MediaHoraria, file =  "MediaHoraria.csv")
write.csv2(DesvioPadraoHorario, file ="DesvioPadraoHorario.csv")
write.csv2(MedianaHoraria, file ="MedianaHoraria.csv")
write.csv2(matrizCorrelacoes.MediaHoraria, file ="Matriz_Correlacoes_MediaHoraria.csv")
write.csv2(matrizCorrelacoes.DesvioPadraoHorario, file ="Matriz_Correlacoes_DP.csv")
write.csv2(matrizCorrelacoes.MedianaHoraria, file ="Matriz_Correlacoes_Mediana.csv")

### PARTE DO SCRIPT PARA COLOCAR AS 15 AMOSTRAS DE CADA HORA EM ORDEM PARA CADA PLANILHA. FACILITA
## A VIZUALICAO E CÁLCULO DE DESVIO PADRÃO, MÉDIA E TESTE DE ADERÊNCIA DE KOLMOGOROV-SMIRNOV (ESTE TESTE PODERIA SER
## FEITO DIRETAMENTE DO LAÇO ACIMA, PORÉM ESTA FORMA É PARA FACILITAR VISUALIZAÇÃO)

AmostrasHorarias <- data.frame(rep(Anos,8760),gl(8760,15,labels=horasAno))

temp2 <-c()

for (j in 3:length(GeracaoHoraria)){
  for(hora in 0:max(horasAno)){
    temp <- GeracaoHoraria[which(GeracaoHoraria$Hora == hora),j]
    temp2 <- c(temp2,temp)
    

  }
  AmostrasHorarias <- cbind(AmostrasHorarias,temp2)
  
  temp2 <-c()
  
  
}
colnames(AmostrasHorarias) <- names(GeracaoHoraria)

setwd("C:/Users/Francisco/Desktop/BID")
write.csv2(AmostrasHorarias, file =  "Amostras_Horarias.csv")

###APLICANDO TESTE DE NORMALIDADE

testeNormalidade <- data.frame(0:8759)
temp2 <-c()
aux5 <- c()

for (j in 3:length(GeracaoHoraria)){
  for(hora in 0:max(horasAno)){
    aux5 <- tapply(AmostrasHorarias[,j],AmostrasHorarias$Hora == hora,sum)
    if (aux5[2] != 0){
      temp <- tapply(AmostrasHorarias[,j],AmostrasHorarias$Hora == hora,lillie.test)
      temp2 <- rbind(temp2,temp[2])
    }else{
      temp <- NA
      temp2 <- rbind(temp2,temp)
    }

    
  }
  testeNormalidade <- cbind(testeNormalidade,temp2)
  temp2 <-c()
  aux5<-c()
  
}



colnames(testeNormalidade) <- names(GeracaoHoraria[,-1])


testeNormalidade.pvalor <- data.frame(0:8759)
temp2 <- c()
for (j in 2:length(testeNormalidade)){
  for (i in 1:8760){
    if (!is.na(testeNormalidade[i,j])){
      temp <- testeNormalidade[i,j][[1]]$p.value
      temp2 <- rbind(temp2,temp)
    }else{
      temp <- NA
      temp2 <- rbind(temp2,temp)
    }

  }
  testeNormalidade.pvalor <- cbind(testeNormalidade.pvalor,temp2)
  temp2<-c()
}

colnames(testeNormalidade.pvalor) <- names(testeNormalidade)
setwd("C:/Users/Francisco/Desktop/BID")

write.csv2(testeNormalidade.pvalor, file =  "TesteNormalidade_pvalue.csv")
########################TESTE DE NORMALIDADE





save.image("C:/Users/Francisco/Desktop/BID/WorkspaceBID.RData")
