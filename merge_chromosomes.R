library(dplyr)
library(data.table)
library(parallel)
setwd ("Chromosom1_22_rda/")

#merged_data <- load("new_chr1.rda")
#for (i in 2:22) {
#  
#  current_chrom <- read.table(sprintf("new_chr%s.rda", i))
#  print(sprintf("Merging chromosome %s", i))
#  all_chr <- rbind (merged_data, current_chrom)#  
#}
#
#saveRDS(merged_data, "all_chr.rds")
#

read.one <- function(file,
                     path = '.',
                     ...){
  var <- load(file.path(path,file),...)
  one <- get (var)
  assign (var, subset(one, 
                      subset = !is.na(one[,2]),
		      select = c(1,4)))
}

read.all <- function(base = 'new_chr',
	    	     ext = '.rda',
		     path = '.',
		     index = 1:22,
		     ...){
##  for (i in index){    
##    load(file.path(path,base,i,ext))
##  }

  lapply(index, function(i){read.one(file.path(path,paste0(base,i,ext)))})
}

combine.all <- function(base = 'new_chr',
                        index = 1:22,
                        ...){
  all <- eval(parse(text = paste0('rbind(',
                                  paste0(base,
			                 index,
			        	 collapse = ","),
			          ")")))
  return(all)
}

do.all <- function(...){
    read.all(...)
    merge.tbl <- combine.all(...)
    saveRDS(merge.tbl, file="merge.tbl.rds")
}
