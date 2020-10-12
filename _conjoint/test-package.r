function (type = "file", J = NULL, filename = NULL, attribute.levels = NULL, 
    constraints = NULL, level.probs = NULL, tol = 1e-14) 
{
    design.obj <- NULL
    if (type == "file") {
        if (is.null(filename)) {
            cat("Error: Must provide a valid filename argument for type = 'file'\n")
            stop()
        }
        connection <- file(filename, open = "r")
        file_lines <- readLines(connection)
        close(connection)
        attr_index <- which(file_lines == "Attributes")
        weight_index <- which(file_lines == "Weights")
        restriction_index <- which(file_lines == "Restrictions")
        attributes <- file_lines[(attr_index + 1):(weight_index - 
            1)]
        weight <- file_lines[(weight_index + 1):(restriction_index - 
            1)]
        if (restriction_index + 1 != length(file_lines)) {
            constr <- file_lines[(restriction_index + 1):length(file_lines)]
        }
        else {
            constr <- NULL
        }
        attribute.levels <- list()
        for (attrstr in attributes) {
            attributename <- strsplit(attrstr, ":")[[1]][1]
            levels <- strsplit(strsplit(attrstr, ":")[[1]][2], 
                ",")[[1]]
            attribute.levels[[attributename]] <- levels
        }
        level.probs <- list()
        for (probstr in weight) {
            attributename <- strsplit(probstr, ":")[[1]][1]
            weights <- strsplit(strsplit(probstr, ":")[[1]][2], 
                ",")[[1]]
            level.probs[[attributename]] <- as.numeric(weights)
        }
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
        else {
            constraints <- NULL
        }
    }
    if (type == "array") {
        if (sum(J) != 1) {
            cat("Error: Profile assignment probability array invalid: Does not sum to 1\n")
        }
        else {
            design.obj$J <- J
            design.obj$dependence <- compute_dependencies(J)
        }
    }
    else if (type == "constraints" | type == "file") {
        if (is.null(attribute.levels) | is.list(attribute.levels) != 
            TRUE) {
            cat("Error: Must provide a valid list() object in attribute.levels argument for type = 'constraints'\n")
        }
        dimensions <- c()
        for (attr in names(attribute.levels)) {
            dimensions <- c(dimensions, length(attribute.levels[[attr]]))
        }
        J_mat <- array(NA, dim = dimensions, dimnames = attribute.levels)
        for (cstr in constraints) {
            constraint_names <- names(cstr)
            select_call <- Quote(J_mat[])
            select_call <- select_call[c(1, 2, rep(3, length(dim(J_mat))))]
            for (f in 1:length(constraint_names)) {
                name <- constraint_names[f]
                index <- which(names(dimnames(J_mat)) == name)
                select_call[index + 2] <- cstr[f]
            }
            eval(call("<-", select_call, 0))
        }
        if (is.null(level.probs)) {
            cell_prob <- 1/sum(is.na(J_mat))
            J_mat[is.na(J_mat)] <- cell_prob
        }
        else {
            for (attr in names(level.probs)) {
                level.probs[[attr]] <- level.probs[[attr]]/sum(level.probs[[attr]])
            }
            for (attr in names(level.probs)) {
                if (is.null(names(level.probs[[attr]]))) {
                  names(level.probs[[attr]]) <- attribute.levels[[attr]]
                }
            }
            unconstrained_probs <- J_mat
            unconstrained_probs[TRUE] <- 1
            for (attr in names(dimnames(J_mat))) {
                for (level in attribute.levels[[attr]]) {
                  marg_prob <- level.probs[[attr]][[level]]
                  select_call <- Quote(unconstrained_probs[])
                  select_call <- select_call[c(1, 2, rep(3, length(dim(J_mat))))]
                  index <- which(names(dimnames(J_mat)) == attr)
                  select_call[index + 2] <- level
                  eval(call("<-", select_call, eval(call("*", 
                    select_call, marg_prob))))
                }
            }
            missing_prob <- sum(unconstrained_probs[is.na(J_mat) == 
                FALSE])
            increase_prob <- unconstrained_probs * 1/(1 - missing_prob)
            J_mat[is.na(J_mat)] <- increase_prob[is.na(J_mat)]
        }
        design.obj$J <- J_mat
        design.obj$dependence <- compute_dependencies(J_mat, 
            tol)
    }
    else {
        cat("Invalid type argument: Must be either 'file', 'array', or 'constraints")
    }
    class(design.obj) <- "conjointDesign"
    return(design.obj)
}