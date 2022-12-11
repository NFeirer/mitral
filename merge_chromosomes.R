library(dplyr)
library(data.table)
library(parallel)

path = '../Chromosom1_22_rda' #path is home/nfeirer/Chromosom1_22_rda directory

#' Read one chromosome data file 
#' aim: combine the information of 22 chromosomes as a reference list
#' 
#' @param file (new_chr1, ..., new_chr22)
#' @param path (Chromosom1_22_rda)
#' @param drop.NA (every file contains NAs -> keep only the non-NA rows)
#' @param which.cols (only column "rs" and "chr_pos" for rs-number and position of the SNP on the chromosome)
#' @param ... (for possible later changes)
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

#' Read all chromosome data files
#'
#' @param base = base name of input variables new_chr (1 to 22)
#' @param ext = .rda (all new_chr are .rda-files)
#' @param path = . or home/nfeirer/Chromosom1_22_rda directory
#' @param index = chr 1 to 22
#' @param ... = for possible later changes
#' @lapply = make a list with the index 1 to 22 for all chromosomes, use function read.one from above
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

#' combine previously loaded chromosome dataframes
#'
#'
#' @param base = base name of input variables -> does not net ext = ".rda" as the dataframes are already loaded
#' @param index = vector of chromosome indices to process
#' @param ... = for possible later changes
#'
#' @return = returns "all" vector for combine.all function
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

#' read and combine chromosome data files
#'
#' The merged dataframe is saved in RDS format and also returned (invisibly)
#'
#' @param outfile name of outputfile (extension ".rds" optional)
#' @param ... passed on to all internal calls
#'
#' @return merged dataframe (invisibly)
#' @export -> as RDS file (more practical than rda files!) --> "merge.tbl.rds"
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
