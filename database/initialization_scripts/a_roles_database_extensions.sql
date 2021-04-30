-- Create a role for read-only access to the database: explorer
CREATE ROLE explorer;

-- Get the passwords from the environment
\set markwatney_pass `echo $MARKWATNEY_PASSWORD`
\set markwatney_pass :'markwatney_pass' -- for some reason, PyCharm is bitching about using :'var' in CREATE USER

\set tester_pass `echo $TESTER_PASSWORD`
\set tester_pass :'tester_pass' -- for some reason, PyCharm is bitching about using :'var' in CREATE USER

-- Create an admin user and a tester user
CREATE USER markwatney WITH PASSWORD :markwatney_pass SUPERUSER CREATEDB CREATEROLE;
CREATE USER tester WITH PASSWORD :tester_pass IN ROLE explorer;

CREATE DATABASE mars_remote_sensing WITH OWNER markwatney;

-- Disable the public schema
REVOKE ALL ON SCHEMA public FROM public;
REVOKE ALL ON SCHEMA public FROM explorer;

\c mars_remote_sensing markwatney;

-- Create an extension to store PostGIS
CREATE SCHEMA postgis;
CREATE EXTENSION postgis SCHEMA postgis;
CREATE EXTENSION postgis_raster SCHEMA postgis;

-- Create a schema for vector data
CREATE SCHEMA vectors;

GRANT USAGE ON SCHEMA postgis TO explorer;
GRANT USAGE ON SCHEMA vectors TO explorer;

ALTER DATABASE mars_remote_sensing SET search_path = vectors,postgis;
