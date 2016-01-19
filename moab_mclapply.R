### Goal
# Demonstrate the basic functionality of parallelization on the
# bwUniCluster using the R function 'parallel{mclapply}' exemplified with a
# bootstrap.

### Notes on mclapply
# Please note that 'parallel{mclapply}' works in almost exactly the same way as
# 'base{lapply}'. The only difference is that it can be distributed across
# multiple cores, where each list element is processed independently from the
# other list elements. Hence, 'mclapply' can only be applied to serial
# problems, which do not need communication between other processes. For
# 'mclapply' there are two major options regarding the allocation of jobs to
# the requested cores. If the argument 'mc.preschedule' is set to 'TRUE', all
# jobs will be preallocated to the requested cores, whereas
# 'mc.preschedule=FALSE' means that each job starts only after another job has
# ended and its core has become available for a new process. See '?mclapply'
# for further instructions.


# The script --------------------------------------------------------------
# Load the 'parallel' package.
suppressPackageStartupMessages(library("parallel"))

# Load the dataset used herein.
data(iris)

# Collect command line arguments. These are either the defaults specified in
# the corresponding job scheduler shell script or parameters provided at the
# command line.
cli_args <- commandArgs(TRUE)
species <- as.character(cli_args[1])
# Check whether the user-defined parameters make sense with respect to the
# dataset.
if (!species %in% levels(iris$Species)) {
  stop("Provided 'SPECIES' level is not part of the data!")
}
# Specify the number of bootstrap rounds.
trials <- as.integer(cli_args[2])

# Set the number of cores to the amount that was requested from MOAB via 
# '#MOAB -l nodes=<integer>:ppn=<integer>', where '<integer>' is typically
# within the range from 1 to 16.
use_cores <- as.integer(Sys.getenv("MOAB_PROCCOUNT"))

# Reduce the data according to the user-defined species selection.
x <- droplevels(iris[iris$Species == species, c("Sepal.Length", "Species")])
# Extract the model intercept and the coefficient for 'Sepal.Length' for the 
# subset from the iris data using a binomial model with a logit link.
mod_parms <- glm(Species ~ Sepal.Length, data = x, family = binomial(logit))

# Estimate the standard errors of the 'Sepal.Length' coefficient from a
# generalized linear model fit via a bootstrap with 'trials' rounds.
glm_coef_lst <- mclapply(seq_len(trials), FUN = function(i) {
    # Sample at random from the full space of the iris data subset, i.e. run a
    # bootstrap on the data.
    ind <- sample(nrow(x), size = nrow(x), replace = TRUE)
    # Fit a generalized linear model on the random sample from the iris data
    # subset using a binomial model with a logit link. Store the coefficients
    # from each run.
    coefficients(glm(x[ind, "Species"] ~ x[ind, "Sepal.Length"],
                     family = binomial(logit)))
  }, mc.cores = use_cores, mc.preschedule = TRUE)
glm_coef_df <- do.call("rbind", glm_coef_lst)
boot_coef <- glm_coef_df[, 2]
# Compute an approximated standard error of the 'Sepal.Length' coefficient.
coef_se <- sd(boot_coef)

# Write the output to a file in the directory of your choice. Here, we will
# simply write the output to the current working directory from which the job
# scheduler was evoked.
saveRDS(coef_se, file = "./coef_se.RDS")
