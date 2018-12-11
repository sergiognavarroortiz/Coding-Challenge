######################
# Solucion problema 1#
######################

#Cargar Data
library(readxl)
data <- read_excel("~/TRABAJO/USA/Examen final/Data ejemplo.xlsx", 
                           sheet = "Entrenamiento")
View(data)

#########################################################
# Comenzamos con unalisis exploratorio de las variables #
#########################################################

#Revisar clase de la data y  nombre de las variables
str(data)
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
chisq.test(table_Age_CID)    
chisq.test(table_Age_Device)

#Con lo anterior podemos entonces determinar el grado de coorrelacion de las variables, esto lo hacemos
#para poder determinar si las variables que tenemmos nos sirven para predecir las metricas desconocidas.

#############################################################################
# Redes neuronales profundas para la prediccion de las metricas desconocidas#
#############################################################################

#El proceso aqui mostrado se debe realizar con todas las variables de prediccion (Metrics unknown),
#La primera varieble a predecir debera ser la que mayor coorrelacion tenga con el resto de las variables 
#conocidas, de forma que al llegar a la variable de menor correlacion ayamos sumado otras variables mas para su
#prediccion de forma que pueda ser mas precisa.

#Como fines ilustrativos realizaremos la prediccion del CPE, pero debera comenzar por la variable que mayor
#correlacion tenga con el resto de las variables conocidas y continuar por las siguientes, dejando como ultima el 
#CPE por ser la variable de mayor imprtancia. 

#Observar la distribucion de la variable de prediccion
hist(data$CPE ,col = "red",xlab = "Histograma de CPE")

#Converion de los atributos a factores
require(nnet)
LineItemID<-class.ind(data$LineItemID)   #Es como extraer el atributo del dataset y crea una matriz de cada variable categorica
colnames(LineItemID)=c("lid1","lid2","lid3",.......,"lid30000000")   #Esto agrega a un valor numerico una etiqueta de lo que significa su factor
head(LineItemID)

ContentUrl<-class.ind(data$ContentUrl)   
colnames(ContentUrl)=c("url1",.......,"url543040")  
head(ContentUrl)

CampaignID<-class.ind(data$CampaignID)   
colnames(CampaignID)=c("cid1",.......,"cid100")  
head(CampaignID)

StoryID<-class.ind(data$StoryID)   
colnames(StoryID)=c("sid1_1",.......,"sid100_1")  
head(StoryID)

Channel<-class.ind(data$Channel)   
colnames(Channel)=c("fb",.......,"yh")  
head(Channel)

Preview_Headline<-class.ind(data$Preview_Headline)   
colnames(Preview_Headline)=c("hl1",.......,"hl2")  
head(Preview_Headline)


Channel_Ad_ID<-class.ind(data$Channel_Ad_ID)   
colnames(Channel_Ad_ID)=c("adfb1","adfb2","adyh1",.......,"adyh154")  
head(Channel_Ad_ID)

Gender_Targeting<-class.ind(data$Gender_Targeting)   
colnames(Gender_Targeting)=c("M","F")  
head(Gender_Targeting)

Age_Targeting<-class.ind(data$Age_Targeting)   
colnames(Age_Targeting)=c("35a44",.......,"55a64")  
head(Age_Targeting)

Device_Targeting<-class.ind(data$Device_Targeting)   
colnames(Device_Targeting)=c("D",.......,"M")  
head(Device_Targeting)

Interest_Targeting<-class.ind(data$Interest_Targeting)   
colnames(Interest_Targeting)=c("intid_fb1","intid_yh1",.......,"intid_yh30")  
head(Interest_Targeting)

#Creacion de Objetos de R separados para el resto de los atributos
Lifetime_Spend<-as.data.frame(dataset$Lifetime_Spend)
colnames(Lifetime_Spend)=c("Lifetime_Spend")

Lifetime_Clicks<-as.data.frame(dataset$Lifetime_Clicks)
colnames(Lifetime_Clicks)=c("Lifetime_Clicks")

Lifetime_Engagements<-as.data.frame(dataset$Lifetime_Engagements)
colnames(Lifetime_Engagements)=c("Lifetime_Engagements")

#Unir todos los objetos de R en un solo data frame
sample<-cbind(LineItemID,ContentUrl,CampaignID,StoryID,Channel,Preview_Headline,Channel_Ad_ID,Gender_Targeting,Gender_Targeting,Age_Targeting,Device_Targeting,Interest_Targeting,Lifetime_Spend,Lifetime_Clicks,Lifetime_Engagements)

#Normalizar los atributos
sample<-scale(sample)

#Separar variable de prediccion
target<-as.matrix(data$CPE)
colnames(target)=c("target")

#Combinar las variables de entrenamiento con la variable de prediccion
data_completa<-cbind(sample,target) 
data_completa<-as.data.frame(data_completa)

#Preparar train set
rand_seed=2018
set.seed(rand_seed)
train<-sample(1:nrow(data_completa),"numero de datos adecuado para el entrenamiento",FALSE)

#Funcion para poder aderir todas las variables para poder realizar el ajuste

formu<-function(y_label,x_labels){
  as.formula(sprintf("%s~%s",y_label,
                     paste(x_labels,collapse = "+")))
}

#Formula almacenada en f de a~b+c+d+e+f...
f<-formu("target",colnames(data_completa[,-15]))
f

#Creacion de un primero modelo simple con 2 hiden layers, donde la primera solo tiene una neurona
#La segunda tiene 2 neuronas

#Creacion del primer modelo simple
require(neuralnet)
set.seed(rand_seed)
fitn<-neuralnet(f,
                data = data_completa[train,],
                hidden = "Neuronas por capa",
                algorithm = "rprop+",     #algorithm puede ser tambien rprop-,sag,slr. Donde rprop+ y rprop- refer to resilence backpropagation with and without weight backtracking; and sag refers to the smallest absolute derivate, asnd slr(smallest learning rate) refer to the modified globally converget algorithm often called grprop
                err.fct="sse",         #Funcion de error se puede seleccionar entre: sum of squared errors and cross-entropy "ce"
                act.fct = "logistic",    #La funcion de activacion puede ser: logistica (sigmoid) o tanh 
                threshold = 0.01,
                rep="numero de repetiiones del algoritmo",
                linear.output = TRUE)      #linear.output=TRUE es para problemas de regresion y FALSE para problemas de clasificacion

#Para medir el desempeño del modelo se usara MSE and R-squared for a perfect fit the MSE will equal zero and
#R-Squared equal 1. 

#Medicion de la puntuacion
scoresn<-compute(fitn,data_completa[train,1:14])
pred1<-scoresn$net.result

y_train=data_completa[train,15]
require(Metrics)

round(mse(pred1,y_train),4)

round(cor(pred1,y_train)^2,4)

#Este proceso se debe ir ajustando segun el resultado, hasta obtener el modelo que mejor resultado pueda tener.
#Finalmente al determinar el modelo de mayor probabilidad se prueba en los datos prueba

#Prediccion en modelos de ajuste
y_test=data_completa[-train,15]
scores_testn<-compute(fitn,data_completa[-train,1:32])
pred_testn=scores_testn$net.result

round(mse(pred_testn,y_test),4)

round(cor(pred_testn,y_test),4)

#Si el modelo prueba poder realizar una prediccion acertada entonces se acepta y podemos continuar
#con el siguiente modelo de prediccion, para la segunda variable y asi sucesivamente hasta obtener la variable
#de prediccion CPE. La variable predecida se sumara a las variebles conocidas para mejorar la prediccion 
#de las otras variables desconocidas. 

#######################
# Solucion problema 2 #
#######################

#Los metodos de optimizacion que disponemos para resolver la situacion de estudio pueden llegar a ser de
#muchos tipos, pero para este problema al no tener una data real, usaremos algoritmos geneticos en una 
#regresion lineal, esto solo como demostracion. 

#Converiosn de variables categoricas a numericas
data$LineItemID<-as.numeric(data$LineItemID)
data$ContentUrl<-as.numeric(data$ContentUrl)
data$CampaignID<-as.numeric(data$CampaignID)
data$StoryID<-as.numeric(data$StoryID)
data$Channel<-as.numeric(data$Channel)
data$Preview_Headline<-as.numeric(data$Preview_Headline)
data$Channel_Ad_ID<-as.numeric(data$Channel_Ad_ID)
data$Gender_Targeting<-as.numeric(data$Gender_Targeting)
data$Age_Targeting<-as.numeric(data$Age_Targeting)
data$Device_Targeting<-as.numeric(data$Device_Targeting)
data$Interest_Targeting<-as.numeric(data$Interest_Targeting)

#Funcion de ajuste para nuestro algoritmo genetico
CPE<-function(data,b0,b1,b2,b3){
  attach(data,warn.conflicts = F)
  Y_hat<-b0+b1*LineItemID+b2*ContentUrl+b3*CampaignID+b4*StoryID+b5*Channel+b6*Preview_Headline+b7*Channel_Ad_ID+b8*Gender_Targeting+b9*Age_Targeting+b10*Device_Targeting+b11*Interest_Targeting+b12*Lifetime_Spend+b13*Lifetime_Clicks+b14*Lifetime_Engagements
  SSE=t(CPE-Y_hat) %*% (CPE-Y_hat)
  detach(data)
  return(SSE)
}

#Algoritmo genetico
library(genalg)
ga.CPE<-ga(type='real-valued',min(1,1,1,1,1,1,1,1,1,1,1,45,1000,500,0.09),   #Los vlores son supuestos, tomados de los datos con los que se contaba como ejemplo
           max=c(n,n,n,n,n,n,n,n,n,n,n,n,n,n,n),popSize=n,maxiter=n,
           names=c('intercept','LineItemID','ContentUrl','CampaignID','StoryID','Channel','Preview_Headline',
                   'Channel_Ad_ID','Gender_Targeting','Age_Targeting','Device_Targeting','Interest_Targeting',
                   'Lifetime_Spend','Lifetime_Clicks','Lifetime_Engagements'),
           keepBest=T,fitness=function(b)-CPE(data,b[1],b[2],b[3],b[4],b[5],b[6],b[7],b[8],b[9],b[10],b[11],b[12],b[13],b[14],b[15]))

#Grafico del algoritmo
plot(ga.CPE)

#Sumario
summary(ga.CPE)

#Finalmente obtenemos el ajuste idoneo de las variable. Tenemos que tener en cuenta que para este ejemplo
#se utilizo un modelo lineal como funcion objetivo, mas sin ambargo esto no es el caso siempre, para
#poder aplicar una funcion adecuada se debe tener un mejor conocimiento de la data.





