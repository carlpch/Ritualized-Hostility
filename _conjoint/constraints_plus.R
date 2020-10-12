## End(Not run)
## Or you can construct the conjoint design manually in in R
attribute_list <- list()
attribute_list[["Provocative behavior of country B"]] <-
  c("The ruling party in country B sent high level governmental official to attend the National Territorial Day and claim their territorial rights. Protesters from your country on the scene were arrested by country B",
    "The government of country B announced that the disputed territory will be included in its annual defense white paper in the following year",
    "The president of country B made an official visit to the disputed territory",
    "The military of country B just conducted a shooting exercise on the disputed territory")
attribute_list[["Which side is in control of the disputed territory"]] <- 
  c("your country has effective control",
    "country B has effective control")
attribute_list[["Previous provocations 1"]] <-  
  c(1,3,5,7,9,11)

attribute_list[["Previous provocations 2"]] <- 
  c("&nbsp;", "Previous provocations have always occurred annually and on the same day in previous years",
    "Previous provocations have been sporadic in the last few years")

attribute_list[["Domestic political institution"]] <- 
  c("country B is a democratic state",
    "country B is a non-democracy")

attribute_list[["Bilateral trade relations"]] <- 
  c("country B is a key trade partner of country A",
    "country B is not a key trade partner with country A")

attribute_list[["Cultural and religious difference"]] <- 
  c("country B shares common language and major religion with country A",
    "country B has no common language nor religion with country A")

attribute_list[["Regional security relations"]] <- 
  c("country A and country B are regional security partners",
    "country A and country B have no regional security ties")


# Randomization constraints in the conjoint design
constraint_list <- list()
# Constraints on Possible Provocation Type
# Constrain 1
constraint_list[[1]] <- list()
constraint_list[[1]][["Which side is in control of the disputed territory"]] <- 
  c("your country has effective control")
constraint_list[[1]][["Provocative behavior of country B"]] <- 
  c("The president of country B made an official visit to the disputed territory",
    "The military of country B just conducted a shooting exercise on the disputed territory")

# Constrain 2
constraint_list[[2]] <- list()
constraint_list[[2]][["Which side is in control of the disputed territory"]] <- 
  c("country B has effective control")
constraint_list[[2]][["Provocative behavior of country B"]] <- 
  c("The ruling party in country B sent high level governmental official to attend the National Territorial Day and claim their territorial rights. Protesters from your country on the scene were arrested by country B",
    "The government of country B announced that the disputed territory will be included in its annual defense white paper in the following year")


# Constraints on Previous Provocation and following descriptions

#1
constraint_list[[3]] <- list()
constraint_list[[3]][["Previous provocations 1"]] <- 1
constraint_list[[3]][["Previous provocations 2"]] <- c("Previous provocations have always occurred annually and on the same day in previous years",
                                                 "Previous provocations have been sporadic in the last few years")

#3
constraint_list[[4]] <- list()
constraint_list[[4]][["Previous provocations 1"]] <- 3
constraint_list[[4]][["Previous provocations 2"]] <- c("&nbsp;")
#5
constraint_list[[5]] <- list()
constraint_list[[5]][["Previous provocations 1"]] <- 5
constraint_list[[5]][["Previous provocations 2"]] <- c("&nbsp;")
#7
constraint_list[[6]] <- list()
constraint_list[[6]][["Previous provocations 1"]] <- 7
constraint_list[[6]][["Previous provocations 2"]] <- c("&nbsp;")
#9
constraint_list[[7]] <- list()
constraint_list[[7]][["Previous provocations 1"]] <- 9
constraint_list[[7]][["Previous provocations 2"]] <- c("&nbsp;")
#11
constraint_list[[8]] <- list()
constraint_list[[8]][["Previous provocations 1"]] <- 11
constraint_list[[8]][["Previous provocations 2"]] <- c("&nbsp;")


continu_design <- makeDesign(type='constraints', attribute.levels=attribute_list,
                                constraints=constraint_list)