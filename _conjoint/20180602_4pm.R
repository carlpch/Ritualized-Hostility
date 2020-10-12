require(cjoint)
require(tidyverse)

data <- read.qualtrics("20180603c.csv", 
                       responses=c("Q2","Q3","Q4","Q5","Q6"), 
                       respondentID="ResponseId",
                       new.format = TRUE)

results <- amce(profile ~  Bilateral.trade.relations + Domestic.political.institution,
                data=data,
                cluster=TRUE, respondent.id="Response.ID", design=ritualdesign)



summary(results)
plot(results)
print(results, digits=5)




#########################################

registerOptions(api_token="DiXgVG0vy6wxreHn3xZPnGxCt65kADuGDzBg55B5", root_url="virginia.az1.qualtrics.com")
survey <- getSurvey("SV_8Ia3v91TzehKqd7")
write_csv(survey, "onlinesurvey.csv")



conjoint_data2 <- read.qualtrics("onlinesurvey.csv",
                                 responses=c("Task 1","Task 2","Task 3","Task 4","Task 5"), respondentID = "ResponseID")






