############
# Solucion #
############

#Cargar Data
library(readxl)
data <- read_excel("TRABAJO/USA/Examen final/Data ejemplo.xlsx", 
                   sheet = "Entrenamiento")
View(data)

# Comenzamos con unalisis exploratorio de las variables #
#########################################################

#Revisar clase de la data y  nombre de las variables
class(data)
names(data)

#nombres de las variables
var<-names(data)
var

#Revisar la clase de las variables
class(data$LineItemID)
class(data$ContentUrl)
class(data$CampaignID)
class(data$StoryID)
class(data$Channel)
class(data$Preview_Headline)
class(data$Preview_Image)
class(data$Channel_Ad_ID)
class(data$Gender_Targeting)
class(data$Age_Targeting)
class(data$Device_Targeting)
class(data$Geo_Targeting)
class(data$Interest_Targeting)
class(data$Language_Targeting)
class(data$OS_Targeting)
class(data$Lifetime_Spend)
class(data$Lifetime_Clicks)
class(data$Lifetime_Engagements)
class(data$CPE)

#Conversion a clase correcta de las variables (en caso de que no lo haga bien el automatico de R)
data$LineItemID<-as.factor(data$LineItemID)
data$ContentUrl<-as.factor(data$ContentUrl)
data$CampaignID<-as.factor(data$CampaignID)
data$StoryID<-as.factor(data$StoryID)
data$Channel<-as.factor(data$Channel)
data$Preview_Headline<-as.factor(data$Preview_Headline)
data$Preview_Image<-as.factor(data$Preview_Image)
data$Channel_Ad_ID<-as.factor(data$Channel_Ad_ID)
data$Gender_Targeting<-as.factor(data$Gender_Targeting)
data$Age_Targeting<-as.factor(data$Age_Targeting)  #Se realizo un pretratamiento para cambiar - por a para mejor lectura en R
data$Device_Targeting<-as.factor(data$Device_Targeting)
data$Geo_Targeting<-as.factor(data$Geo_Targeting)
data$Interest_Targeting<-as.factor(data$Interest_Targeting)
data$Language_Targeting<-as.factor(data$Language_Targeting)
data$OS_Targeting<-as.factor(data$OS_Targeting)
data$Lifetime_Spend<-as.numeric(data$Lifetime_Spend)  #Se realizo un pretratamiento para eliminar valores de $
data$Lifetime_Clicks<-as.numeric(data$Lifetime_Clicks)
data$Lifetime_Engagements<-as.numeric(data$Lifetime_Engagements)
data$CPE<-as.numeric(data$CPE)  #Se realizo un pretratamiento para eliminar valores de $

#Sospechamos que las variables Preview_Image, Geo_Targeting, Language_Targeting, OS_Targeting,Lifetime_Clicks y Lifetime_Engagements
#solo contienen un valor, si esto es cierto entonces tales columnas se eliminaran dado que
#este valor no podria ayudarnos a predecir las variables "Available metrics at lineitem level"

#Determinando si las variables Preview_Image, Geo_Targeting, Language_Targeting, OS_Targeting, Lifetime_Clicks y 
#Lifetime_Engagements tienen solo un valor
factor(data$Preview_Image)
factor(data$Geo_Targeting)
factor(data$Language_Targeting)
factor(data$OS_Targeting)
range(data$Lifetime_Clicks)
range(data$Lifetime_Engagements)

#Para este ejemplo consideraremos que las variables Preview_Image, Geo_Targeting, Language_Targeting y
#OS_Targetin tiene un solo valor y por tanto no sirven para realizar la prediccion, mientras que las
#variavles Lifetime_Engagements y Lifetime_Clicks posen un rango de valores, esto es debido a que
#parece que se uso la misma imagen para el mismo pais, con el mismo lenguaje y el mismo sistema operativo movil.
#Mientras que las otras dos variables son de prediccion y por tanto pensamos que estas variables si deberian tener 
#diferentes valores numericos.

#Borrar variables  que no sirven para prediccion
library(dplyr)
data <- select(data, -Preview_Image, -Geo_Targeting, -Language_Targeting, -OS_Targeting)

#Analisis de coorrelaciones
library(psych)
pairs.panels(data,cex=16)

#Con este trabajo podriamos observar si existe o no relacion entre variables. 

#Suponiendo que las variables CampaignID, Age_Targeting y Device_Targeting tuvieran relacion, se podria realizar un
#estudio un poco mas avanzado para comprobarlo, esto se muestra a continuacion.

#Descripcion de cada una de las variables categoricas
attach(data)
table(CampaignID)
table(Age_Targeting)
table(Device_Targeting)

#Relacion entre Age_Targetin con CampaignID y Device_Targeting con grafica
table_Age_CID<-table(Age_Targeting,CampaignID)
plot(table_Age_CID,col=c("red","blue"),main="Age vs CampaignID")

table_Age_Device<-table(Age_Targeting,Device_Targeting)
plot(table_Age_Device,col=c("red","blue"),main="Age vs Device")

detach(data)

#Prueba chi-cuadrado para ambas relaciones
chisq.test(table_Age_CID)    #Revisar significado de valor chi
chisq.test(table_Age_Device)