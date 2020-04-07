#!/usr/bin/env Rscript

library(caret, lib.loc="./R_libs/")
library(randomForest, lib.loc="./R_libs/")

args = commandArgs(trailingOnly=TRUE)

model = readRDS("mammalian_rf_model.rds")

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("An argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  df = read.csv(args[1], header=TRUE, sep=",")
  score = predict(model, df)
  score
}
