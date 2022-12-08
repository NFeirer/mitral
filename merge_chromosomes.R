library(dplyr)
library(data.table)
library(parallel)

path = '../Chromosom1_22_rda'

read.one <- function(file,
                     path       = '.',
		     drop.NA    = TRUE,
		     which.cols = c(1,4),
                     ...){
  var <- load(file.path(path,file),     # var is name of variable just loaded
	      ...)  
  one <- get(var)
  if(drop.NA && ncol(one)==4) {
    one <- subset(one,
	 	  subset = !is.na(one[,2]),  # non-NA rows
	          select = which.cols)       # rs + chr:pos
  } else {
    one <- one[,which.cols]
  }
  assign(var,
         one,
         env = .GlobalEnv)   # make sure the variable is created in the global
                             # environment to be availble for the seesion
}

read.all <- function(base  = 'new_chr',
	    	     ext   = '.rda', 
		     path  = '.',
		     index = 1:22,
		     ...){

  lapply(index, function(i){read.one(file = paste0(base,i,ext),
				     path = path,
				     ...)})
}

combine.all <- function(base  = 'new_chr',
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
    read.all(path = path,
             ...)
    merge.tbl <- combine.all(...)
    saveRDS(merge.tbl, file="merge.tbl.rds")
}
