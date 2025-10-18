# buildme.R

# A script to build your package

# set working directory to package root
setwd("/Users/louise/Documents/Cornell/Six Sigma/group18minussivahackathon/package")

# Unload your package and uninstall it first.
unloadNamespace("monitorsolarpanels"); remove.packages("monitorsolarpanels")
# Auto-document your package, turning roxygen comments into manuals in the `/man` folder
devtools::document(".")
# Load your package temporarily!
devtools::load_all(".")

# Test out our functions
demotool::plus_one(x = 1)

# When finished, remember to unload the package
unloadNamespace("monitorsolarpanels")

# Then, when ready, document, unload, build, and install the package!
# For speedy build, use binary = FALSE and vignettes = FALSE
devtools::document("."); # document the package
unloadNamespace("monitorsolarpanels"); # unload the package
# Build the package
devtools::build(pkg = ".", path = getwd(), binary = FALSE, vignettes = FALSE)


# Restart R
rstudioapi::restartSession()

# Install your package from a local build file
# such as 
# install.packages("nameofyourpackagefile.tar.gz", type = "source")
# or in our case:
install.packages("monitorsolarpanels_1.0.tar.gz", type = "source")


# Load your package!
library("monitorsolarpanels")


# When finished, remember to unload the package
unloadNamespace("monitorsolarpanels"); remove.packages("monitorsolarpanels")

# Always a good idea to clear your environment and cache
rm(list = ls()); gc()
