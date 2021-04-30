-- Create all the tables.

\c mars_remote_sensing markwatney;


-- Mars 2000 (Geographic)
INSERT INTO postgis.spatial_ref_sys (srid, auth_name, auth_srid, proj4text, srtext)
VALUES (949900, 'IAU2000', 49900,
        '+proj=longlat +a=3396190 +b=3376200 +no_defs ',
        'GEOGCS["Mars 2000",DATUM["D_Mars_2000",SPHEROID["Mars_2000_IAU_IAG",3396190.0,169.89444722361179]],' ||
        'PRIMEM["Greenwich",0],UNIT["Decimal_Degree",0.0174532925199433]]');

-- Mars Equidistant Cylindrical
INSERT INTO postgis.spatial_ref_sys (srid, auth_name, auth_srid, proj4text, srtext)
VALUES (949910, 'IAU2000', 49910,
        '',
        'PROJCS["Mars_Equidistant_Cylindrical",' ||
        'GEOGCS["Mars 2000",DATUM["D_Mars_2000",SPHEROID["Mars_2000_IAU_IAG",3396190.0,169.89444722361179]],' ||
        'PRIMEM["Greenwich",0],UNIT["Decimal_Degree",0.0174532925199433]],PROJECTION["Equidistant_Cylindrical"],' ||
        'PARAMETER["False_Easting",0],PARAMETER["False_Northing",0],PARAMETER["Central_Meridian",0],' ||
        'PARAMETER["Standard_Parallel_1",0],UNIT["Meter",1]]');

-- Mars Sinusoidal
INSERT INTO postgis.spatial_ref_sys (srid, auth_name, auth_srid, proj4text, srtext)
VALUES (949914, 'IAU2000', 49914,
        '+proj=sinu +lon_0=0 +x_0=0 +y_0=0 +a=3396190 +b=3376200 +units=m +no_defs ',
        'PROJCS["Mars_Sinusoidal",' ||
        'GEOGCS["Mars 2000",DATUM["D_Mars_2000",SPHEROID["Mars_2000_IAU_IAG",3396190.0,169.89444722361179]],' ||
        'PRIMEM["Greenwich",0],UNIT["Decimal_Degree",0.0174532925199433]],PROJECTION["Sinusoidal"],' ||
        'PARAMETER["False_Easting",0],PARAMETER["False_Northing",0],PARAMETER["Central_Meridian",0],UNIT["Meter",1]]');

-- Mars North Pole Stereographic
INSERT INTO postgis.spatial_ref_sys (srid, auth_name, auth_srid, proj4text, srtext)
VALUES (949918, 'IAU2000', 49918,
        '+proj=stere +lat_0=90 +lon_0=0 +k=1 +x_0=0 +y_0=0 +a=3396190 +b=3376200 +units=m +no_defs ',
        'PROJCS["Mars_North_Pole_Stereographic",' ||
        'GEOGCS["Mars 2000",DATUM["D_Mars_2000",SPHEROID["Mars_2000_IAU_IAG",3396190.0,169.89444722361179]],' ||
        'PRIMEM["Greenwich",0],UNIT["Decimal_Degree",0.0174532925199433]],PROJECTION["Stereographic"],' ||
        'PARAMETER["False_Easting",0],PARAMETER["False_Northing",0],PARAMETER["Central_Meridian",0],' ||
        'PARAMETER["Scale_Factor",1],PARAMETER["Latitude_Of_Origin",90],UNIT["Meter",1]]');

-- Mars South Pole Stereographic
INSERT INTO spatial_ref_sys (srid, auth_name, auth_srid, proj4text, srtext)
VALUES (949920, 'IAU2000', 49920,
        '+proj=stere +lat_0=-90 +lon_0=0 +k=1 +x_0=0 +y_0=0 +a=3396190 +b=3376200 +units=m +no_defs ',
        'PROJCS["Mars_South_Pole_Stereographic",' ||
        'GEOGCS["Mars 2000",DATUM["D_Mars_2000",SPHEROID["Mars_2000_IAU_IAG",3396190.0,169.89444722361179]],' ||
        'PRIMEM["Greenwich",0],UNIT["Decimal_Degree",0.0174532925199433]],PROJECTION["Stereographic"],' ||
        'PARAMETER["False_Easting",0],PARAMETER["False_Northing",0],PARAMETER["Central_Meridian",0],' ||
        'PARAMETER["Scale_Factor",1],PARAMETER["Latitude_Of_Origin",-90],UNIT["Meter",1]]');

-- Mars Stereographic
INSERT INTO spatial_ref_sys (srid, auth_name, auth_srid, proj4text, srtext)
VALUES (949962, 'IAU2000', 49962,
        '+proj=stere +lat_0=0 +lon_0=0 +k=1 +x_0=0 +y_0=0 +a=3396190 +b=3376200 +units=m +no_defs ',
        'PROJCS["Mars_Stereographic",' ||
        'GEOGCS["Mars 2000",DATUM["D_Mars_2000",SPHEROID["Mars_2000_IAU_IAG",3396190.0,169.89444722361179]],' ||
        'PRIMEM["Greenwich",0],UNIT["Decimal_Degree",0.0174532925199433]],PROJECTION["Stereographic"],' ||
        'PARAMETER["False_Easting",0],PARAMETER["False_Northing",0],PARAMETER["Central_Meridian",0],' ||
        'PARAMETER["Scale_Factor",1],PARAMETER["Latitude_Of_Origin",0],UNIT["Meter",1]]');

--- Mars Transverse Mercator
INSERT INTO spatial_ref_sys (srid, auth_name, auth_srid, proj4text, srtext)
VALUES (949964, 'IAU2000', 49964,
        '+proj=tmerc +lat_0=0 +lon_0=0 +k=0.9996 +x_0=0 +y_0=0 +a=3396190 +b=3376200 +units=m +no_defs ',
        'PROJCS["Mars_Transverse_Mercator",' ||
        'GEOGCS["Mars 2000",DATUM["D_Mars_2000",SPHEROID["Mars_2000_IAU_IAG",3396190.0,169.89444722361179]],' ||
        'PRIMEM["Greenwich",0],UNIT["Decimal_Degree",0.0174532925199433]],PROJECTION["Transverse_Mercator"],' ||
        'PARAMETER["False_Easting",0],PARAMETER["False_Northing",0],PARAMETER["Central_Meridian",0],' ||
        'PARAMETER["Scale_Factor",0.9996],PARAMETER["Latitude_Of_Origin",0],UNIT["Meter",1]]');

-- Mars Mercator
INSERT INTO spatial_ref_sys (srid, auth_name, auth_srid, proj4text, srtext)
VALUES (949974, 'IAU2000', 49974,
        '',
        'PROJCS["Mars_Mercator",' ||
        'GEOGCS["Mars 2000",DATUM["D_Mars_2000",SPHEROID["Mars_2000_IAU_IAG",3396190.0,169.89444722361179]],' ||
        'PRIMEM["Greenwich",0],UNIT["Decimal_Degree",0.0174532925199433]],PROJECTION["Mercator"],' ||
        'PARAMETER["False_Easting",0],PARAMETER["False_Northing",0],PARAMETER["Central_Meridian",0],' ||
        'PARAMETER["Standard_Parallel_1",0],UNIT["Meter",1]]');

-- Mars Orthographic
INSERT INTO spatial_ref_sys (srid, auth_name, auth_srid, proj4text, srtext)
VALUES (949966, 'IAU2000', 49966,
        '+proj=ortho +lat_0=90 +lon_0=0 +x_0=0 +y_0=0 +a=3396190 +b=3376200 +units=m +no_defs ',
        'PROJCS["Mars_Orthographic",' ||
        'GEOGCS["Mars 2000",DATUM["D_Mars_2000",SPHEROID["Mars_2000_IAU_IAG",3396190.0,169.89444722361179]],' ||
        'PRIMEM["Greenwich",0],UNIT["Decimal_Degree",0.0174532925199433]],PROJECTION["Orthographic"],' ||
        'PARAMETER["False_Easting",0],PARAMETER["False_Northing",0],PARAMETER["Longitude_Of_Center",0.0],' ||
        'PARAMETER["Latitude_Of_Center",90.0],UNIT["Meter",1]]');

-- Mars Lambert Conformal Conic
INSERT INTO spatial_ref_sys (srid, auth_name, auth_srid, proj4text, srtext)
VALUES (949970, 'IAU2000', 49970,
        '',
        'PROJCS["Mars_Lambert_Conformal_Conic",' ||
        'GEOGCS["Mars 2000",DATUM["D_Mars_2000",SPHEROID["Mars_2000_IAU_IAG",3396190.0,169.89444722361179]],' ||
        'PRIMEM["Greenwich",0],UNIT["Decimal_Degree",0.0174532925199433]],PROJECTION["Lambert_Conformal_Conic"],' ||
        'PARAMETER["False_Easting",0],PARAMETER["False_Northing",0],PARAMETER["Central_Meridian",0],' ||
        'PARAMETER["Standard_Parallel_1",-20],PARAMETER["Standard_Parallel_2",20],' ||
        'PARAMETER["Latitude_Of_Origin",0],UNIT["Meter",1]]');

-- Mars Lambert Azimuthal Equal Area
INSERT INTO spatial_ref_sys (srid, auth_name, auth_srid, proj4text, srtext)
VALUES (949972, 'IAU2000', 49972,
        '+proj=laea +lat_0=90 +lon_0=0 +x_0=0 +y_0=0 +a=3396190 +b=3376200 +units=m +no_defs ',
        'PROJCS["Mars_Lambert_Azimuthal_Equal_Area_AUTO",' ||
        'GEOGCS["Mars 2000",DATUM["D_Mars_2000",SPHEROID["Mars_2000_IAU_IAG",3396190.0,169.89444722361179]],' ||
        'PRIMEM["Greenwich",0],UNIT["Decimal_Degree",0.0174532925199433]],PROJECTION["Lambert_Azimuthal_Equal_Area"],' ||
        'PARAMETER["False_Easting",0],PARAMETER["False_Northing",0],PARAMETER["Central_Meridian",0],' ||
        'PARAMETER["Latitude_Of_Origin",90],UNIT["Meter",1]]');

-- Mars Albers
INSERT INTO spatial_ref_sys (srid, auth_name, auth_srid, proj4text, srtext)
VALUES (949976, 'IAU2000', 49976,
        '',
        'PROJCS["Mars_Albers",' ||
        'GEOGCS["Mars 2000",DATUM["D_Mars_2000",SPHEROID["Mars_2000_IAU_IAG",3396190.0,169.89444722361179]],' ||
        'PRIMEM["Greenwich",0],UNIT["Decimal_Degree",0.0174532925199433]],PROJECTION["Albers"],' ||
        'PARAMETER["False_Easting",0],PARAMETER["False_Northing",0],PARAMETER["Central_Meridian",0.0],' ||
        'PARAMETER["Standard_Parallel_1",20.0],PARAMETER["Standard_Parallel_2",-20.0],' ||
        'PARAMETER["Latitude_Of_Origin",0.0],UNIT["Meter",1]]');

-- Mars Oblique Cylindrical Equal Area
INSERT INTO spatial_ref_sys (srid, auth_name, auth_srid, proj4text, srtext)
VALUES (949978, 'IAU2000', 49978,
        '',
        'PROJCS["Mars_Oblique_Cylindrical_Equal_Area_AUTO",' ||
        'GEOGCS["Mars 2000",DATUM["D_Mars_2000",SPHEROID["Mars_2000_IAU_IAG",3396190.0,169.89444722361179]],' ||
        'PRIMEM["Greenwich",0],UNIT["Decimal_Degree",0.0174532925199433]],' ||
        'PROJECTION["Oblique_Cylindrical_Equal_Area"],PARAMETER["False_Easting",0],PARAMETER["False_Northing",0],' ||
        'PARAMETER["Central_Meridian",0.0],PARAMETER["Standard_Parallel_1",0.0],UNIT["Meter",1]]');
