library(LACPD)
library(parallel)
set.seed(1234)
x <- replicate(500,rnorm(168),simplify = FALSE)
########################################################### other methods
library(strucchange)
FP.str <- unlist(lapply(X=1:length(x), function(i){
  if(i<length(x)) {
    cat(paste(i),",")
    flush.console()
  } else {
    cat(paste(i),"\n")
    flush.console()
  }
  y <- x[[i]]
  breakpoints(y~1)$breakpoints[1]
}))
sum(!is.na(FP.str))/length(x)
# [1] 0.026

library(bfast)
FP.bfast <- unlist(lapply(X=1:length(x), function(i){
  y <- x[[i]]
  bfast(ts(y),max.iter = 1,season = "none")$Time[1]
}))
sum(!is.na(FP.bfast))/length(x)
# [1] 0.002

library(ecp)
FP.div <- unlist(lapply(X=1:length(x), function(i){
  if(i<length(x)) {
    cat(paste(i),",")
    flush.console()
  } else {
    cat(paste(i),"\n")
    flush.console()
  } 
  y <- x[[i]]
  e.divisive(matrix(y,ncol=1))$order.found[3]
}))
sum(!is.na(FP.div))/length(x)
# [1] 0.054

library(trend)
FP.bu <- lapply(X=1:length(x), function(i){
  if(i<length(x)) {
    cat(paste(i),",")
    flush.console()
  } else {
    cat(paste(i),"\n")
    flush.console()
  } 
  y <- x[[i]]
  
  R <- bu.test(y)
  return(list(cp=as.numeric(R$estimate),p=R$p.value))
})
FP.bu <- do.call(rbind,FP.bu)
sum(unlist(FP.bu[,2])<0.05)/length(x)
# [1] 0.068

FP.pettitt <- lapply(X=1:length(x), function(i){
  if(i<length(x)) {
    cat(paste(i),",")
    flush.console()
  } else {
    cat(paste(i),"\n")
    flush.console()
  } 
  y <- x[[i]]
  R <- pettitt.test(y)
  return(list(cp=as.numeric(R$estimate),p=R$p.value))
})

FP.pettitt <- do.call(rbind,FP.pettitt)

sum(unlist(FP.pettitt[,2])<0.05)/length(x)
# 0.044


FP.mk <- lapply(X=1:length(x), function(i){
  if(i<length(x)) {
    cat(paste(i),",")
    flush.console()
  } else {
    cat(paste(i),"\n")
    flush.console()
  } 
  R <- mk.test(x[[i]])
  return(R$p.value)
})


sum(unlist(FP.mk)<0.05)/length(x)
# [1] 0.072


FP.cs <- lapply(X=1:length(x), function(i){
  if(i<length(x)) {
    cat(paste(i),",")
    flush.console()
  } else {
    cat(paste(i),"\n")
    flush.console()
  } 
  R <- cs.test(x[[i]])
  return(R$p.value)
})


sum(unlist(FP.cs)<0.05)/length(x)
# [1] 0.05