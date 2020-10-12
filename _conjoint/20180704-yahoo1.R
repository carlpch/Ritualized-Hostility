require(cjoint)
require(tidyverse)
require(stargazer)
options("scipen"=100, "digits"=3)



data <- read.qualtrics("20180704-yahoo1.csv", 
                       responses=c("Q12","Q13","Q14","Q15","Q16"), 
                       covariates = c("Q2","Q3","Q4","Q5","Q6","Q7","Q8", "Q9_1", "Q9_2", "Q9_3", "Q9_4", "Q9_5", "Q9_6", "Q9_7"),
                       respondentID="ResponseId",
                       new.format = TRUE)

View(data)

warpbreaks$tension <- relevel(warpbreaks$tension, ref = "M")
data$`歴史` <- relevel(data$`歴史`, ref = "このような挑発は今までなかった")

results <- amce(selected ~  `安全保障` + `挑発行為` + `政体` + `文化` + `歴史` + `貿易関係`, 
                data=data,
                cluster=TRUE, respondent.id="Response.ID")


estimation <- summary(results)
coefficients <- estimation$amce[,2:4] %>% as_tibble() %>% rename(std.err = `Std. Err`)
coefficients$Level <- c("Security: not a regional security partner", 
                        "Provocation: presidential visit", 
                        "Regime Type: autocracy", 
                        "Culture: highly different", 
                        "History: multiple times on same day of the year", 
                        "History: multiple times irregularly" , 
                        "Trade: not a major trade partner")

coefficients$Level <- c("安全：安全保障上連携がない", 
                        "挑発：大統領が上陸", 
                        "政体：独裁国家", 
                        "文化：日本に近い", 
                        "歴史：この数年間不定期", 
                        "歴史：この数年間同じ日に定期的" , 
                        "貿易：貿易相手国ではない")

font_A <- "IPAMincho"

coefficients %>% ggplot(aes(x=Estimate, y= Level)) + 
  geom_point() + 
  geom_errorbarh(aes(xmin = Estimate+(std.err*qnorm(0.025)), xmax =Estimate+(std.err*qnorm(0.975))),
                 size = 0.2, height=0.1)+
  geom_vline(xintercept = 0)+
  scale_x_continuous(limits = c(-0.4, 0.4))+ 
  theme(text = element_text(family = font_A))

coefficients[5:6,] %>% ggplot(aes(x=Level, y= Estimate)) + 
  geom_point() + 
  geom_errorbar(aes(ymin = Estimate+(std.err*qnorm(0.025)), ymax =Estimate+(std.err*qnorm(0.975))),
                 size = 0.2, width=0.1, color="blue")+
  geom_hline(yintercept = 0)+
  scale_y_continuous(limits = c(-0.2, 0.2)) + 
  theme_bw() +  theme(text = element_text(family = font_A))

############################################################

descriptive <- read_csv("20180704-yahoo1.csv")[-c(1:2),18:32] %>% as_tibble()
names(descriptive) = c("Gender", "Age", "Residence", "Education", "Employment", "Household_Income", "FP_interests", 
                       "Veiw_USA", "Veiw_PRC", "Veiw_ROK", "Veiw_DPRK", "Veiw_TW", "Veiw_SWS", "Veiw_RUS", "Ideology")

descriptive <- descriptive %>% mutate(
  Gender = ifelse(Gender ==1, "Male", "Female")
)

