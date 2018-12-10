#install.packages("xlsx", dependencies = TRUE)
#install.packages('ggmap')
#install.packages('zipcode')
#install.packages('ggplot2')
#install.packages("RCurl")

library(RCurl)
library(xlsx)
library(zipcode)
library(ggmap)
library(ggplot2)

# download raw data file for analysis
# file shows median household income for the United States from the 2006 to 2010 census, file contains zipcode, mean income, median income and population columns.  File is downloaded from University of Michigan's Institute for Social Research
# use Rcurl and xlsx packages to download and process the file
urlfile<-'http://www.psc.isr.umich.edu/dis/census/Features/tract2zip/MedianZIP-3.xlsx'
destfile<- 'ac3.xlsx'
download.file(urlfile,destfile,mode="wb")
census<- read.xlsx2(destfile,sheetName = "Median")

#cleanup the data formats
names(census) <- c('Zip','Median',"Population")
census<- na.omit(census)
census$Median <- as.character(census$Median)
census$Median <- as.numeric(gsub(',','',census$Median))
census$Population <- as.character(census$Population)
census$Population <- as.numeric(gsub(',','',census$Population))

#get geographical coordinates, cities and states from zipcode (using zipcode package)
data(zipcode)
census$Zip <- clean.zipcodes(census$Zip)
census <- merge(census, zipcode, by.x='Zip', by.y='zip')
census<- na.omit(census)

#find the state average Median income by aggregating by states
statedf<- aggregate(census$Median,list(census$state), mean)
names(statedf) <- c('state','median')

#find the geographical coordinates and population for each state 
lat<-aggregate(census$latitude,list(census$state), mean)
statedf$latitude<- lat$x
long<- aggregate(census$longitude,list(census$state), mean)
statedf$longitude<- long$x
pop<- aggregate(census$Population,list(census$state), sum )
statedf$population<- pop$x

#get US map from Google map
map<-get_map(location='united states', zoom=4, maptype = "terrain",
             source='google',color='bw')


#plot state median income with ggplot2
ggmap(map) + geom_point(
  aes(x=longitude, y=latitude,colour=median,size=population), 
  data=statedf, na.rm = T)  + 
  scale_color_gradient(low="yellow", high="red") + ggtitle(" US median household income by states")
