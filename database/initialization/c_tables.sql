-- Create all the tables.

\c mars_remote_sensing markwatney;

-- Create the table for MARSIS orbit footprints
CREATE TABLE marsis_footprints
(
    orbit integer                                    NOT NULL PRIMARY KEY,
    epoch character varying(23)                      NOT NULL,
    sza   double precision                           NOT NULL,
    qi    character varying(2)                       NOT NULL,
    geog  postgis.geography(MULTILINESTRING, 949900) NOT NULL,
    url   text                                       NOT NULL
);

-- Create the table for SHARAD orbit footprints
CREATE TABLE sharad_footprints
(
    orbit       integer                                    NOT NULL,
    observation integer                                    NOT NULL,
    epoch       character varying(23)                      NOT NULL,
    sza         double precision                           NOT NULL,
    geog        postgis.geography(MULTILINESTRING, 949900) NOT NULL,
    url         text                                       NOT NULL
);

-- Create table for quadrants
CREATE TABLE quadrants
(
    quad_code character varying(5),
    quad_name text,
    geog      postgis.geography(POLYGON, 949900) NOT NULL,
    map_url   text
);

-- Create table for nomenclature from planetarynames.wr.usgs.gov
CREATE TABLE nomenclature
(
    name       text,
    clean_name text,
    approvaldt character varying(10),
    origin     text,
    diameter   float,
    geog       postgis.geography(POINT, 949900) NOT NULL,
    center_lon double precision,
    center_lat double precision,
    type       text,
    code       character varying(2),
    min_lon    double precision,
    max_lon    double precision,
    min_lat    double precision,
    max_lat    double precision,
    ethnicity  text,
    continent  character varying(25),
    quad_name  text,
    quad_code  character varying(5),
    url        text
);

GRANT SELECT ON marsis_footprints TO explorer;
GRANT SELECT ON sharad_footprints TO explorer;
GRANT SELECT ON quadrants TO explorer;
GRANT SELECT ON nomenclature TO explorer;
