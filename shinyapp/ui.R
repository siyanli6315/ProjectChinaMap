library(shiny)
library(plotly)

shinyUI(fluidPage(
  titlePanel("城镇居民人均可支配收入"),
  sidebarLayout(
    sidebarPanel(
      selectInput('type1','图像类型',c('map','bubble')),
      selectInput("time1","时间",c('2015.03','2015.06','2015.09','2015.12','2016.03','2016.06','2016.09','2016.12'))
    ),
    mainPanel(
    plotlyOutput("plot1",height=600,width=700)
    )
  ),
  
  titlePanel("房地产开发企业商品房销售平均价格"),
  sidebarLayout(
    sidebarPanel(
      selectInput('type2','图像类型',c('map','bubble')),
      selectInput("time2","时间",c('2015.02','2015.03','2015.04','2015.05','2015.06','2015.07','2015.08','2015.09','2015.10','2015.11','2015.12','2016.02','2016.03','2016.04','2016.05','2016.06','2016.07','2016.08','2016.09','2016.10','2016.11','2016.12'))
    ),
    mainPanel(
      plotlyOutput("plot2",height=600,width=700)
    )
  ),
  
  titlePanel("回归分析"),
  sidebarLayout(
    sidebarPanel(
      selectInput("time3","时间",c('2015.03','2015.06','2015.09','2015.12','2016.03','2016.06','2016.09','2016.12'))
      ),
    mainPanel(
      plotlyOutput("plot3",height=600,width=700)
    )
  )
))
