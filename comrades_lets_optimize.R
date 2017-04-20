library(optimx)
library(raster)


# load the raster
rr <- raster("ness.grd")

f <- function(par, raster){
  extract(raster, SpatialPoints(matrix(par, ncol=2)))
}
#c(-22.58393, -32.31538)
#oo <- optimx(c(22.28899, 25.5571), f, raster=rr, method=c("bobyqa", "nlminb"),
#             control=list(maximize=FALSE, all.methods=TRUE))
oo <- optimx(c(22.28899, 25.5571), f, raster=rr, method=c("nlminb"),
             control=list(maximize=FALSE, trace=1, reltol=1e-3))

plot(rr)
points(oo["nlminb",][1:2])
#points(oo["bobyqa",][1:2])

#o <- optim(c(22.28899, 25.5571), f, raster=rr, method="SANN",
#             control=list(fnscale=-1))
#points(o$par, pch=19)
