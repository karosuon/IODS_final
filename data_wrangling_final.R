
#set working directory
setwd("Z:/Jatko-opinnot/Tilastotiede 2016/IODS")

#read the data
ESS <- read.table("ESS7e02.1_F1.csv", sep=",", header = T)

#check the data
dim(ESS)
str(ESS)
summary(ESS)

##filter out missing data 
library(plyr)
library(dplyr)

#filter out (66=Not applicable, 77=Refusal, 88=Don't know, 99=No answer, i.e. Missing data not elsewhere explained)
ESS <- filter(ESS, rlgdgr<11)
ESS <- filter(ESS, rlgatnd<11)
ESS <- filter(ESS, pray<11)

#filter out (7=Refusal, 8=Don't know, 9=No answer, i.e. Missing data not elsewhere explained)
ESS <- filter(ESS, rlgblg<3)
ESS <- filter(ESS, gndr<3)

#keep only the working age population (15-64).
ESS <- filter(ESS, agea<65, agea>14)

#code reverse (now 1=every day, 7=never, code that 7=every day, 1=never)
ESS$rlgatnd <- 8-ESS$rlgatnd
ESS$pray <- 8-ESS$pray

#rename the countries
attach(ESS)
ESS$country <- revalue(ESS$cntry, c("AT"="Austria", "BE"="Belgium", "CH"="Switzerland", "CZ"="Czech Republic",
                                    "DE"="Germany", "DK"="Denmark", "EE"="Estonia", "ES"="Spain", "FI"="Finland", "FR"="France", 
                                    "GB"="United Kingdom", "HU"="Hungary", "IE"="Ireland", "IL"="Israel", "LT"="Lithuania", 
                                    "NL"="Netherlands", "NO"="Norway", "PL"="Poland", "PT"="Portugal", "SE"="Sweden", "SI"="Slovenia"))
detach(ESS)



#check the data
summary(ESS$country)

#center and standardize the variables measured with different scales (1-7 and 1-10)
ESS$rel_how <- as.vector(scale(ESS$rlgdgr))
ESS$rel_pray <- as.vector(scale(ESS$pray))
ESS$rel_att <- as.vector(scale(ESS$rlgatnd))

#create  a new logical column "belong" which is TRUE for paticipants for which "rlgblg" is smaller than 2  (meaning they belong to particular religion or denomination
ESS$belong <- ESS$rlgblg < 2

#transform to categorical
ESS$gender <- as.factor(ESS$gndr)
ESS$gender <- revalue(ESS$gender, c("1"="Male", "2"="Female")) 

#Remove the useless variables from the data 
library(dplyr)
ESS <- dplyr::select(ESS, -cntry, -ppltrst, -pplfair, -pplhlp, -rlgblg, -rlgdgr, -rlgatnd,  -pray, -gndr, -X)

#check that everything is OK
names(ESS)

#Write CSV in and save to the Data-folder
write.csv(ESS, file = "ESS.csv")

