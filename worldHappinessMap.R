library(ggplot2)
library(ggmap)
library(mapdata)
library(plyr)
library(sqldf)


worldMap <- map_data('world')
worldMap <- worldMap[,1:5]
worldMap$region[worldMap$region == 'USA'] <- 'United States'
worldMap$region[worldMap$region == 'UK'] <- 'United Kingdom'
worldMap$region[worldMap$region == 'Democratic Republic of the Congo'] <- 'Congo (Kinshasa)'
worldMap$region[worldMap$region == 'Republic of Congo'] <- 'Congo (Brazzaville)'
worldMap$region[worldMap$region == 'Somaliland'] <- 'Somaliland Region'
worldMap <- worldMap[!(worldMap$region %in% c('Antarctica','Greenland')),]


happiness <- read.csv('/Users/yezhuang/Downloads/2016.csv')
happinessRank <- happiness[,c(1,3,4,7,11)]
names(happinessRank)[1] <- 'region'
head(worldMap)
hm <- join(worldMap, happinessRank, by='region', type = 'full')

ggplot(hm, aes(x=long, y=lat, group=group, fill=Happiness.Score)) + 
  geom_polygon() +
  scale_fill_gradient2(low='#3b66b0',high = '#bf4d40',midpoint = 5,name="Happiness") +
  theme(legend.position = c(0.15,0.2)) 

cinm <- worldMap[,'region']
cinh <- happinessRank[,'region']

sqldf("select distinct region from worldMap where region not in (select Country from happiness)")
sqldf("select Country from happiness where Country not in (select distinct region from worldMap)")





