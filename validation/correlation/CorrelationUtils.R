library(ggplot2)

get.correlation.plot <- function(data.df) {
  p <- ggplot(data.df,aes(tao,rate)) + 
       geom_point(colour="darkblue",size=1) + 
       geom_smooth(method="lm",se=FALSE,colour="deeppink2",size=1.5) + 
       theme(
              panel.grid.minor = element_blank(),
              panel.background = element_blank(),
              plot.background = element_blank(),
              panel.border = element_rect(fill=NA,size=1.1),
              plot.title = element_blank(),
              axis.line = element_blank(),
              axis.ticks = element_blank(),
              axis.text.x = element_blank(),
              axis.text.y = element_blank(),
              axis.title.x = element_blank(),
              axis.title.y = element_blank()
        )
        return (p)
}