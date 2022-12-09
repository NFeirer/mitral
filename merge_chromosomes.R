library(dplyr)
library(data.table)
library(parallel)

path = '../Chromosom1_22_rda'

#' Read one Roselli chromosome data file 
#'
#' 
#' @param file 
#' @param path 
#' @param drop.NA 
#' @param which.cols 
#' @param ... 
#'
#' @return
#' @export
#'
#' @examples
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
         envir = .GlobalEnv)   # make sure the variable is created in the global
                               # environment to be availble for the seesion
}

#' Read all Roselli chromosome data files
#'
#' @param base 
#' @param ext 
#' @param path 
#' @param index 
#' @param ... 
#'
#' @return
#' @export
#'
#' @examples
read.all <- function(base  = 'new_chr',
                     ext   = '.rda', 
                     path  = '.',
                     index = 1:22,
                     ...){
  
  lapply(index, function(i){read.one(file = paste0(base,i,ext),
                                     path = path,
                                     ...)})
}

#' combine previously loaded Roselli chromosome dataframes
#'
#'
#' @param base base name of input variables
#' @param index vector if chromosome indices to process
#' @param ... 
#'
#' @return
#' @export
#'
#' @examples
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

#' read and combine  Roselli chromosome data files
#'
#' The merged dataframe is saved in RDS format and also returned (invisibly)
#'
#' @param outfile name of outputfile (extension ".rds" optional)
#' @param ... passed on to all internal calls
#'
#' @return merged dataframe (invisibly)
#' @export
#'
#' @examples
do.all <- function(outfile = "merge.tbl",
                   ...){
    read.all(path = path,
             ...)
    merge.tbl <- combine.all(...)
    if (!grepl("\\.rds$", 
               outfile, 
               ignore.case = TRUE)){
      outfile <- paste0(outfile, ".rds")
    }
    saveRDS(merge.tbl,
            file = outfile)
    return(invisible(merge.tbl))
}
