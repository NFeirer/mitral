#aim: make a list of all 22 rds-files which contain the data of Roselli and the reference chromosomes combined
#example for a name of the files: "chr1_roselli.rds"

library(dplyr)
library(data.table)
library(parallel)

path = "../refchr_roselli" 
  
  #read one chr_roselli file (including all columns)
  
  read.one <- function(file,
                       path       = '.',
                       drop.NA    = TRUE,
                       #which.cols = c(1,4), -> not needed as we want all columns now
                       ...){
    var <- readRDS(file.path(path,file),     # var is name of variable just loaded
                ...)  
    assign(var,
           envir = .GlobalEnv)   # make sure the variable is created in the global
    # environment to be availble for the seesion
  }

#read all chr_roselli files
read.all <- function(base  = 'chr', 
                     ext   = '_roselli.rds', #is this correct?
                     path  = '.',
                     index = 1:22,
                     ...){
  
  lapply(index, function(i){read.one(file = paste0(base,i,ext),
                                     path = path,
                                     ...)})
}

#' combine previously loaded chromosome_roselli dataframes

combine.all <- function(base  = 'chr',
                        index = 1:22,
                        ...){
  all <- eval(parse(text = paste0('rbind(',
                                  paste0(base,
                                         index,
                                         collapse = ","),
                                  ")")))
  return(all)
}

#' read and combine chromosome_roselli data files

do.all <- function(outfile = "all_refchr_roselli",
                   ...){
  read.all(path = path,
           ...)
  all_refchr_roselli <- combine.all(...)
  if (!grepl("\\.rds$", 
             outfile, 
             ignore.case = TRUE)){
    outfile <- paste0(outfile, ".rds")
  }
  saveRDS(all_refchr_roselli,
          file = outfile)
  return(invisible(all_refchr_roselli))
}
