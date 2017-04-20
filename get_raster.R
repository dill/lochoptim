# threejs to R

library(plyr)
library(sp)
library(raster)

load("ness.RData")


proj4 <- "+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=airy +datum=OSGB36 +units=m +no_defs"

sp <- dlply(loch_lines, .(group), function(x){
  Lines(list(Line(as.matrix(x[,c("x","y")]))), ID=as.character(x$group[1]))
})

spl <- SpatialLines(sp)
df <- unique(loch_lines[,c("group","z")])
rownames(df) <- df$group
spldf <- SpatialLinesDataFrame(spl, df)
proj4string(spldf) <- proj4

# recipe taken from https://chitchatr.wordpress.com/2014/03/15/creating-dems-from-contour-lines-using-r/
contourBBox <- bbox(spldf)
contourRaster <- raster(xmn=contourBBox[1,1],
                        xmx=ceiling(contourBBox[1,2]),
                        ymn=contourBBox[2,1],
                        ymx=ceiling(contourBBox[2,2]),
                        crs=proj4,
                        resolution = c(0.05,0.05))

p <- as(spldf, 'SpatialPointsDataFrame')
library(gstat)
g <- gstat(id="depth", formula = z~1, data=p,
           nmax=7, set=list(idp = .5))
interpDEM <- interpolate(contourRaster, g)

writeRaster(interpDEM, file="ness.grd")

