
responses = NULL
covariates = NULL
respondentID = NULL
letter = "F"
new.format = FALSE
ranks = NULL
responses=c("Q2.3", "Q2.7", "Q2.10", "Q2.13", "Q2.16")
covariates=c("Q6.6")
respondentID="V1"

qualtrics_results <- read.csv("CandidateConjointQualtrics.csv", stringsAsFactors = F) 



qualtrics_results2 <- read.csv("20180603.csv", stringsAsFactors = F) 
qualtrics_results2 <- qualtrics_results2[-2, ]


new.format.test <- grepl("ImportId", qualtrics_results[2, 1])

var_names <- as.character(qualtrics_results[1, ])
q_names <- colnames(qualtrics_results)
qualtrics_data <- qualtrics_results[2:nrow(qualtrics_results), 
                                    ]
colnames(qualtrics_data) == var_names