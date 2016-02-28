################################################################################
#                                                                              #
#	Lennon Lab Growth Curve Analysis Example                                     #
#   Parameter Estimate Code                                                    #
#                                                                              #
################################################################################
#                                                                              #
#	Written by: M. Muscarella                                                    #
#	  Last update: 11/24/2015 by M. Muscarella & V. Kuo                          #
#                                                                              #
################################################################################

# Setup Work Environment
rm(list=ls())
setwd("~/GitHub/BiofilmTrait/test")

# Load Dependencies
source("../bin/modified_Gomp.R")

# Create Directory For Output
dir.create("../output", showWarnings = FALSE)

# Run Example (CSV file)
growth.modGomp("../data/Biofilm_Gompertz.csv", "csv_test", synergy=F, temp=F)
