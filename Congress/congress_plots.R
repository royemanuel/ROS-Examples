#' ---
#' title: "Regression and Other Stories: Congress"
#' author: "Andrew Gelman, Jennifer Hill, Aki Vehtari"
#' date: "`r format(Sys.Date())`"
#' output:
#'   html_document:
#'     theme: readable
#'     toc: true
#'     toc_depth: 2
#'     toc_float: true
#'     code_download: true
#' ---

#' Predictive uncertainty for congressional elections. See Chapter 2
#' in Regression and Other Stories.
#' 
#' -------------
#' 

#+ setup, include=FALSE
knitr::opts_chunk$set(message=FALSE, error=FALSE, warning=FALSE, comment=NA)
# switch this to TRUE to save figures in separate files
savefigs <- FALSE

#' #### Load packages
library("rprojroot")
root<-has_dirname("RAOS-Examples")$make_fix_file()

#' #### Load and pre-process data
congress <- vector("list", 49)
for (i in 1:49){
  year <- 1896 + 2*(i-1)
  file <- root("Congress/data",paste(year, ".asc", sep=""))
  data_year <- matrix(scan(file), byrow=TRUE, ncol=5)
  data_year <- cbind(rep(year, nrow(data_year)), data_year)
  congress[[i]] <- data_year
}
region_name <- c("Northeast", "Midwest", "South", "West")

#+ eval=FALSE, include=FALSE
if (savefigs) pdf(root("Congress/figs","congress_plot_grid.pdf"), height=3.8, width=7, colormodel="gray")
#+
par(mfrow=c(3,5), mar=c(0.1,3,0,0), mgp=c(1.7, .3, 0), tck=-.02, oma=c(1,0,2,0))
for (i in c(27, 37, 47)) {
  year <- 1896 + 2*(i-1)
  cong1 <- congress[[i]]
  cong2 <- congress[[i+1]]
  state_code <- cong1[,2]
  region<- floor(state_code/20) + 1
  inc <- cong1[,4]
  dvote1 <- cong1[,5]/(cong1[,5] + cong1[,6])
  dvote2 <- cong2[,5]/(cong2[,5] + cong2[,6])
  contested <- (abs(dvote1 - 0.5)) < 0.3 & (abs(dvote2 - 0.5) < 0.3)
  plot(c(0, 1), c(0, 1), type="n", xlab="", ylab="", xaxt="n", yaxt="n", bty="n")
  text(0.8, 0.5, paste(year,"\nto\n", year+2, sep=""), cex=1.1)
  for (j in 1:4){
    plot(c(.2, .8), c(-.4, .3), type="n", xlab= "" , ylab=if (j==1) "Vote swing" else "", xaxt="n", yaxt="n", bty="n", cex.lab=.9)
    if (i==47) {
      text(c(.25, .5, .75), rep(-.4, 3), c("25%", "50%", "75%"), cex=.8)
      abline(-.35, 0, lwd=.5, col="gray60")
      segments(c(.25, .5, .75), rep(-.35, 35), c(.25, .5, .75), rep(-.37, 3), lwd=.5)
      mtext("Dem. vote in election 1", side=1, line=.2, cex=.5)
    }
    axis(2, c(-0.25, 0, 0.25), c("-25%", "0", "25%"),  cex.axis=.8)
    abline(0, 0)
    if (i==27) mtext(region_name[j], side=3, line=1, cex=.75)
    ok <- contested & abs(inc)==1 & region==j
    points(dvote1[ok], dvote2[ok] - dvote1[ok], pch=20, cex=.3, col="gray60")
    ok <- contested & abs(inc)==0 & region==j
    points(dvote1[ok], dvote2[ok] - dvote1[ok], pch=20, cex=.5, col="black")
  }
}
#+ eval=FALSE, include=FALSE
if (savefigs) dev.off()

