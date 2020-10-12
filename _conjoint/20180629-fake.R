require(cjoint)
require(tidyverse)

csv <- read_csv("20180629-fake-2.csv")


data <- read.qualtrics("20180629-test3.csv", 
                       responses=c("Q12","Q13","Q14","Q15","Q16"), 
                       covariates = c("Q2","Q3","Q4","Q5","Q6","Q7","Q8"),
                       respondentID="ResponseId",
                       new.format = TRUE)

View(data)

results <- amce(selected ~  `安全保障` +  `挑発行為` + `歴史` + Q2,
                data=data,
                cluster=TRUE, respondent.id="Response.ID")


summary(results)
