# library
library(edgeR)
library(tidyverse)
library(readr)
library(readxl)
library(cowplot) # for plotting both genotypes or density
#
# load reads mapped to Brassica genome (either v1.5 annotation or v3.0 annotation)
getwd()
## for exp1 v1.5annotation
counts.exp1.v1.5 <- readr::read_csv(file.path("..","v1.5annotation","20170617-samples","input","raw_counts.csv.gz"),col_names=TRUE)
counts.exp1.v1.5 # make sure this is v1.5 annotation (look target_id column)
## for exp1 v3.0annotation
counts.exp1.v3.0 <- readr::read_csv(file.path("..","v3.0annotation","20170617-samples","input","20170617_V3.0_raw_counts.csv.gz"),col_names=TRUE)
counts.exp1.v3.0 # make sure this is v3.0 annotation (look target_id column)
## for exp3 v3.0annotation
counts.exp3.v3.0 <- readr::read_csv(file.path("..","v3.0annotation","20180202-samples","input","20180202_V3.0_raw_counts.csv.gz"),col_names=TRUE)
counts.exp3.v3.0
#
# cpm
## for exp1 v3.0annotation
cpm.exp1.v3.0.leaf <- readr::read_csv(file.path("..","v3.0annotation","20170617-samples","output","cpm_wide_20170617_leaf_samples.csv.gz"),col_names=TRUE)
cpm.exp1.v3.0.root <- readr::read_csv(file.path("..","v3.0annotation","20170617-samples","output","cpm_wide_20170617_root_samples.csv.gz"),col_names=TRUE)

# sample files
# exp1 (20170617-samples)
sample.description.exp1<-readr::read_csv(file.path("..","v1.5annotation","20170617-samples","output","Br.mbio.e1.sample.description.csv"))
# exp3 (20180202-samples)
sample.description.exp3<-readr::read_csv(file.path("..","v3.0annotation","20180202-samples","output","Br.mbio.e3.sample.description.csv"))

# functions for drawing expression pattern
## for exp1 (v1.5 annotation)
expression.pattern.Br.graph.exp1.v1.5annotation<-function(data=counts.exp1.v1.5,target.genes,sample.description=sample.description.exp1,title="",geno){
  data[is.na(data)] <- 0 #
  # select genes and add sample info
  data.temp<-data %>% filter(target_id %in% target.genes) %>% gather(sample,value,-target_id) %>%
    inner_join(sample.description, by="sample") 
  # 
  if(geno=="both") { # needs to impove this
    # ggplot(data.temp, aes(x=genotype,y=value))  + geom_jitter(alpha = 0.5,aes(colour=trt,shape=tissue) )  + theme_bw() + facet_grid(target_id~tissue,scales="free") + theme(strip.text.y=element_text(angle=0),axis.text.x=element_text(angle=90)) + theme(legend.position="bottom") + labs(title=title)
    p.FPsc<-data.temp %>% filter(genotype=="FPsc") %>% ggplot(aes(x=trt,y=value))  + geom_jitter(alpha = 0.5,aes(colour=trt,shape=tissue) )  + theme_bw() + facet_grid(target_id~tissue,scales="free") + theme(strip.text.y=element_text(angle=0),axis.text.x=element_text(angle=90)) + theme(legend.position="bottom") + labs(title=" ")
    p.R500<-data.temp %>% filter(genotype=="R500") %>% ggplot(aes(x=trt,y=value))  + geom_jitter(alpha = 0.5,aes(colour=trt,shape=tissue) )  + theme_bw() + facet_grid(target_id~tissue,scales="free") + theme(strip.text.y=element_text(angle=0),axis.text.x=element_text(angle=90)) + theme(legend.position="bottom") + labs(title=" ")
    # merge two plots
    plot_grid(p.FPsc,p.R500,labels=c(paste(title,"FPsc"),paste(title,"R500")))
  } else if(geno=="FPsc"|geno=="R500") {
    data.temp %>% filter(genotype==geno) %>% ggplot(aes(x=trt,y=value))  + geom_jitter(alpha = 0.5,aes(colour=trt,shape=tissue) )  + theme_bw() + facet_grid(target_id~tissue,scales="free") + theme(strip.text.y=element_text(angle=0),axis.text.x=element_text(angle=90)) + theme(legend.position="bottom") + labs(title=title)
  }  else {print("Specify genotype.");stop}
}
# for exp3 (v3.0 annotation)
expression.pattern.Br.graph.exp3<-function(data=counts.exp3.v3.0,target.genes,sample.description=sample.description.exp3,title="",dens="both"){
  data[is.na(data)] <- 0 #
  # select genes and add sample info
  data.temp<-data %>% filter(target_id %in% target.genes) %>% gather(sample,value,-target_id) %>%
    inner_join(sample.description, by="sample") 
  # plot (separated by density info)
  if(dens=="both") { # needs to improve using cowplot
    # ggplot(data.temp, aes(x=density,y=value))  + geom_jitter(alpha = 0.5,aes(colour=trt,shape=tissue) )  + theme_bw() + facet_grid(target_id~tissue,scales="free") + theme(strip.text.y=element_text(angle=0),axis.text.x=element_text(angle=90)) + theme(legend.position="bottom") + labs(title=title)
    p.cr<-data.temp %>% filter(density=="cr") %>% ggplot(aes(x=trt,y=value))  + geom_jitter(alpha = 0.5,aes(colour=trt,shape=tissue) )  + theme_bw() + facet_grid(target_id~tissue,scales="free") + theme(strip.text.y=element_text(angle=0),axis.text.x=element_text(angle=90)) + theme(legend.position="bottom") + labs(title=" ")
    p.un<-data.temp %>% filter(density=="un") %>% ggplot(aes(x=trt,y=value))  + geom_jitter(alpha = 0.5,aes(colour=trt,shape=tissue) )  + theme_bw() + facet_grid(target_id~tissue,scales="free") + theme(strip.text.y=element_text(angle=0),axis.text.x=element_text(angle=90)) + theme(legend.position="bottom") + labs(title=" ")
    # merge two plots
    plot_grid(p.cr,p.un,labels=c(paste(title,"cr"),paste(title,"un")))
  } else if(dens=="cr"|dens=="un") {
    data.temp %>% filter(density==dens) %>% ggplot(aes(x=trt,y=value))  + geom_jitter(alpha = 0.5,aes(colour=trt,shape=tissue) )  + theme_bw() + facet_grid(target_id~tissue,scales="free") + theme(strip.text.y=element_text(angle=0),axis.text.x=element_text(angle=90)) + theme(legend.position="bottom") + labs(title=title)
  }  else {print("Specify genotype.");stop}
}
## for exp1 (v3.0 annotation)
expression.pattern.Br.graph.exp1.v3.0annotation<-function(data=counts.exp1.v3.0,target.genes,sample.description=sample.description.exp1,title="",geno,tissue.type="root"){
  data[is.na(data)] <- 0 #
  # select genes and add sample info
  data.temp<-data %>% filter(target_id %in% target.genes) %>% gather(sample,value,-target_id) %>%
    inner_join(sample.description, by="sample") 
  # 
  if(geno=="both") { # needs to impove this
    # ggplot(data.temp, aes(x=genotype,y=value))  + geom_jitter(alpha = 0.5,aes(colour=trt,shape=tissue) )  + theme_bw() + facet_grid(target_id~tissue,scales="free") + theme(strip.text.y=element_text(angle=0),axis.text.x=element_text(angle=90)) + theme(legend.position="bottom") + labs(title=title)
    p.FPsc<-data.temp %>% filter(genotype=="FPsc",tissue==tissue.type) %>% ggplot(aes(x=trt,y=value))  + geom_jitter(alpha = 0.5,aes(colour=trt),width=0.2)  + theme_bw() + facet_grid(target_id~tissue,scales="free") + theme(strip.text.y=element_text(angle=0),axis.text.x=element_text(angle=90)) + theme(legend.position="bottom") + labs(title=" ")
    p.R500<-data.temp %>% filter(genotype=="R500",tissue==tissue.type) %>% ggplot(aes(x=trt,y=value))  + geom_jitter(alpha = 0.5,aes(colour=trt),width=0.2 )  + theme_bw() + facet_grid(target_id~tissue,scales="free") + theme(strip.text.y=element_text(angle=0),axis.text.x=element_text(angle=90)) + theme(legend.position="bottom") + labs(title=" ")
    # merge two plots
    plot_grid(p.FPsc,p.R500,labels=c(paste(title,"FPsc"),paste(title,"R500")))
  } else if(geno=="FPsc"|geno=="R500") {
    data.temp %>% filter(genotype==geno) %>% ggplot(aes(x=trt,y=value))  + geom_jitter(alpha = 0.5,aes(colour=trt,shape=tissue) )  + theme_bw() + facet_grid(target_id~tissue,scales="free") + theme(strip.text.y=element_text(angle=0),axis.text.x=element_text(angle=90)) + theme(legend.position="bottom") + labs(title=title)
  }  else {print("Specify genotype.");stop}
}

# only one tissue with the same y-axis for both genotypes
expression.pattern.Br.graph.exp1.v3.0annotation.2<-function(data=counts.exp1.v3.0,target.genes,sample.description=sample.description.exp1,title="",geno,tissue.type="root"){
  data[is.na(data)] <- 0 #
  # select genes and add sample info
  data.temp<-data %>% filter(target_id %in% target.genes) %>% gather(sample,value,-target_id) %>%
    inner_join(sample.description, by="sample") %>% filter(tissue==tissue.type)
  # 
  if(geno=="both") { # needs to impove this
    # ggplot(data.temp, aes(x=genotype,y=value))  + geom_jitter(alpha = 0.5,aes(colour=trt,shape=tissue) )  + theme_bw() + facet_grid(target_id~tissue,scales="free") + theme(strip.text.y=element_text(angle=0),axis.text.x=element_text(angle=90)) + theme(legend.position="bottom") + labs(title=title)
    p<-data.temp %>% ggplot(aes(x=trt,y=value))  + geom_jitter(alpha = 0.5,aes(colour=trt),width=0.2)  + theme_bw() + facet_grid(target_id~genotype,scales="free") + theme(strip.text.y=element_text(angle=0),axis.text.x=element_text(angle=90)) + theme(legend.position="bottom") + labs(title=" ")
    p
  } else if(geno=="FPsc"|geno=="R500") {
    data.temp %>% filter(genotype==geno) %>% ggplot(aes(x=trt,y=value))  + geom_jitter(alpha = 0.5,aes(colour=trt) )  + theme_bw() + facet_grid(target_id~.,scales="free") + theme(strip.text.y=element_text(angle=0),axis.text.x=element_text(angle=90)) + theme(legend.position="bottom") + labs(title=title)
  }  else {print("Specify genotype.");stop}
}

