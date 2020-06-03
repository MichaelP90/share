#relevante Pakete, hier vorschalten
#install.packages
#install.packages("read_excel")
#install.packages("car")
#install.packages("pastecs")

getwd()

#---------------------------------------------------------------------------------
#A. Einlesen der Meldedaten
#RKI variante
#Aktuelle Meldedaten werden aus dem Lage Ordner kopiert und im Ordner
library(readxl)
Cov19 <- read_excel("S:/Projekte/FG24_Burden2020/09 Daten_Analyse/Covid-19/Daten/Covid19_Liste_2020-05-30.xlsm", 
                   sheet = 4, 
                   skip = 4, 
                   range = cell_cols("I:BQ"))
library(dplyr)
Cov19 <- transform(Cov19,count=1)
Cov19_ag <- aggregate(Cov19$count,by=list(Region = Cov19$MeldeLandkreis, Todesfall = Cov19$VerstorbenStatus),FUN=sum)

#COV19_ag <- aggregate(Cov19$count,by=list(Region = Cov19$MeldeLandkreis, Geschlecht = Cov19$Geschlecht, Alter = Cov19$AlterBerechnet, Todesfall = Cov19$VerstorbenStatus),FUN=sum)

kkz <- read_excel("S:/Projekte/FG24_Burden2020/09 Daten_Analyse/Covid-19/Daten/Schlüssel Landkreisstring KKZ.xlsx", 
                    sheet = 1,
                    range = cell_cols("A:C"))
library(tidyr)
library(dplyr)
kkz <- rename(kkz, Region = MeldeLandkreis)
Cov19_ag <- left_join(Cov19_ag, kkz, by="Region", copy = TRUE)

setwd("S:/Tausch/PorstM")
save(Cov19_ag, file="Covid_Faelle_02062020.RData")

