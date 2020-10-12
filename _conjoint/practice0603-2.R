
responses = NULL
covariates = NULL
respondentID = NULL
letter = "F"
new.format = FALSE
ranks = NULL
responses=c("Task 2","Task 1","Task 3","Task 4","Task 5")
respondentID="ResponseId"

qualtrics_results <- read.csv("20180603b.csv", stringsAsFactors = F) 
qualtrics_results <- qualtrics_results[-2, ]

View(qualtrics_results)