

J = NULL
attribute.levels = NULL
constraints = NULL
level.probs = NULL
tol = 1e-14


design.obj <- NULL
connection <- file("180602_r2.dat", open = "r")
file_lines <- readLines(connection)
close(connection)
attr_index <- which(file_lines == "Attributes")
weight_index <- which(file_lines == "Weights")
restriction_index <- which(file_lines == "Restrictions")
attributes <- file_lines[(attr_index + 1):(weight_index - 1)]
weight <- file_lines[(weight_index + 1):(restriction_index - 1)]
if (restriction_index + 1 != length(file_lines)) {
      constr <- file_lines[(restriction_index + 1):length(file_lines)]
}else {
  constr <- NULL
  }

attribute.levels <- list()
for (attrstr in attributes) {
  attributename <- strsplit(attrstr, ":")[[1]][1]
  levels <- strsplit(strsplit(attrstr, ":")[[1]][2], ",")[[1]]
      attribute.levels[[attributename]] <- levels
}
level.probs <- list()
for (probstr in weight) {
      attributename <- strsplit(probstr, ":")[[1]][1]
      weights <- strsplit(strsplit(probstr, ":")[[1]][2], 
                          ",")[[1]]
      level.probs[[attributename]] <- as.numeric(weights)
}

####
if (is.null(constr) != TRUE) {
  constraints <- list()
  for (i in 1:length(constr)) {
        allconstraints <- strsplit(constr[i], ";")[[1]]
        constraints[[i]] <- list()
        for (m in allconstraints) {
          attributename <- strsplit(m, ":")[[1]][1]
          constrained_levels <- strsplit(strsplit(m, 
                                                  ":")[[1]][2], ",")[[1]]
          constraints[[i]][[attributename]] <- constrained_levels
        }
      }
    }
  class(design.obj) <- "conjointDesign"
  return(design.obj)
