#!/bin/zsh

export PGUSER="markwatney"
export PGPASSWORD="a secret :) no one knows :)"

DATA="/Users/ivan/Projects/Data/Mars/Rasters/MGS MOLA DEM 463m v2/By quadrant"

psql -h localhost -p 5432 -d mars_remote_sensing \
  -c "CREATE SCHEMA IF NOT EXISTS mgs_mola_dem; GRANT USAGE ON SCHEMA mgs_mola_dem TO explorer;"

# iterate over rasters in DATA
for geotiff in "$DATA"/mgs_mola_dem_463m_mc*.tif; do
  # grab the quadrant code from the file name
  quad=$(echo "$geotiff" | sed -r -e 's/.*(mc[0-9]+).tif/\1/')
  # insert the raster into the database
  raster2pgsql -s 949910 -c -e -C -r -t 100x100 "$geotiff" "mgs_mola_dem.$quad" |
    psql -h localhost -p 5432 -U markwatney -d mars_remote_sensing
done

psql -h localhost -p 5432 -U markwatney -d mars_remote_sensing \
  -c "GRANT SELECT ON ALL TABLES IN SCHEMA mgs_mola_dem TO explorer;"
