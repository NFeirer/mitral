#system.time(readRDS('/home/nfeirer/mitral/merge.tbl.rds')-> reference_chromosomes)
roselli <- readRDS("/home/nfeirer/roselli_for_merging_with_chrpos.rds")
merge("roselli", "reference_chromosomes", 
      by = "V4", #in beiden Dateien column "chrpos" auf V4 angeglichen
      all.x = TRUE, #keep all rows of x-data (NA for empty)
      all.y = TRUE, #keep all rows of y-data (NA for empty)
      #ich will nach Chromosom-Nr sortieren, nicht nach merged columns
      no.dups = TRUE,
      incomparables = NULL
)
