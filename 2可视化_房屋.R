library(ggplot2)
library(maps)
library(maptools)
library(plyr)
library(RCurl)
library(showtext)
library(scales)
library("latex2exp")
library(plyr)
library(reshape2)
library(grid)
library(grDevices)
showtext.auto(enable=T)

#setwd('~/Desktop/探索性数据分析_刘老师/')
squre=read.csv('./data/squre.csv',header=T,sep=',')
amount=read.csv('./data/amount.csv',header=T,sep=',')
x1=as.matrix(squre[,c(5:26)])*10000
x2=as.matrix(amount[,c(5:26)])*100000000
price=data.frame(name=squre$地区,x2/x1)
map=readShapePoly('./data/china_map/bou2_4p.shp')
map$NAME=iconv(map$NAME,from='GBK')
map=join(fortify(map),data.frame(id=0:924,name=map@data$NAME),by='id')
if(is.null('./data/state.csv')){
  state=readLines('省_省会.txt')
  state=data.frame(x1=state[(1:34)*3-2],x2=state[(1:34)*3])
  urlall=sapply(paste(state$x1,state$x2,sep=''),function(x)sub("xxx",x,"http://apis.map.qq.com/ws/geocoder/v1/?address='xxx'&key=L3CBZ-DK5WF-DNZJJ-JGRJ6-6QSDS-7OBNX"))
  test=getURL(urlall[1])
  lng=strsplit(strsplit(test,"\"lng\": ")[[1]][2],",\n")[[1]][1]
  lat=strsplit(strsplit(test,"\"lat\": ")[[1]][2],"\n")[[1]][1]
  for(i in 2:length(urlall)){
    test=getURL(urlall[i])
    lng1=strsplit(strsplit(test,"\"lng\": ")[[1]][2],",\n")[[1]][1]
    lat1=strsplit(strsplit(test,"\"lat\": ")[[1]][2],"\n")[[1]][1]
    lng=c(lng,lng1)
    lat=c(lat,lat1)
    Sys.sleep(0.3)
  }
  state$long=as.numeric(lng)
  state$lat=as.numeric(lat)
  write.csv(state,file='./data/state.csv',row.names=F)
}else{
  state=read.csv('./data/state.csv',header=T,sep=',')
}

pfun=function(time){
  options(warn=-1)
  dat1=data.frame(price['name'],price[paste('X',time,sep='')])
  names(dat1)=c('name','y')
  price_map=join(map,dat1,by='name')
  ph1=ggplot()+
    geom_polygon(data=price_map,
                 aes(x=long,y=lat,group=group,fill=y),
                 color="black",size=0.3)+
    scale_fill_gradient(low='gray',high='darkblue')+
    geom_text(data=state,aes(x=long,y=lat,label=x1),size=2)+
    annotate('text',x=85,y=10,
             label=paste(strsplit(time,'[.]')[[1]][1],'.01-',
                         time,sep=''),size=5)+
    labs(x='经度',y='纬度')+
    coord_map()+
    theme_bw()+
    theme(axis.text=element_text(size=10),
          axis.title=element_text(size=12),
          legend.position='None')

  ave=dat1$y[dat1$name=='全国']
  dat1=dat1[dat1$name!='全国',]
  dat1$name=factor(dat1$name,levels=dat1$name[order(dat1$y)])
  ph2=ggplot()+
    geom_bar(data=dat1[dat1$name!='全国',],
             aes(x=name,y=y,fill=y),stat='identity')+
    geom_hline(yintercept=ave,linetype=2,size=0.5)+
    annotate('text',x=2,y=ave,label=paste('平均数:',round(ave,2)))+
    scale_fill_gradient(high='darkblue',low='gray')+
    labs(x='',y='房地产开发企业商品房销售平均价格(元/平方米)',fill='')+
    theme_bw()+
    theme(axis.text=element_text(size=9),
          axis.title=element_text(size=12))+
    coord_flip()
  grid.newpage()
  pushViewport(viewport(layout=grid.layout(1,2)))
  vplayout=function(x,y){
    viewport(layout.pos.row=x,layout.pos.col=y)
  }
  print(ph1,vp=vplayout(1,1))
  print(ph2,vp=vplayout(1,2))
}

for(time in c('2015.02','2015.03','2015.04','2015.05','2015.06','2015.07','2015.08','2015.09','2015.10','2015.11','2015.12','2016.02','2016.03','2016.04','2016.05','2016.06','2016.07','2016.08','2016.09','2016.10','2016.11','2016.12')){
  pdf(paste('房地产开发企业商品房销售平均价格',time,'.pdf',sep=''),height=5,width=10)
  pfun(time)
  dev.off()
}
