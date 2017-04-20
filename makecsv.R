# threejs to R

library(plyr)

file <- "ness.js"


loch <- readLines(file)

bath <- loch[which(grepl("Layer 1", loch)):which(grepl("Layer 2", loch))]

bath <- bath[grepl("lyr.f", bath)]

strp2lines <- function(x){
  n <- as.numeric(sub("lyr.f\\[(\\d+)\\].*", "\\1", x))+1

  rows <- sub("^.+lines:(.+),m:.+};$", "\\1", x)
  rows <- gsub("\\[", "", rows)
  rows <- gsub("\\]", "", rows)
  rows <- as.numeric(unlist(strsplit(rows, ",")))

  # we know there are always 3 values, x,y,z so don't faff
  # parsing that
  rows <- as.data.frame(matrix(rows, ncol=3, byrow=TRUE))
  names(rows) <- c("x", "y", "z")
  rows$group <- n

  return(rows)
}

loch_lines <- ldply(bath, strp2lines)


# did that work?
library(ggplot2)
ggplot() + geom_path(aes(x=x, y=y, colour=z, group=group), data=loch_lines)

# save that
save(loch_lines, file="ness.RData")

