FROM postgres:13

RUN apt update && \
    apt install -y postgresql-13-postgis-3 postgresql-13-postgis-3-scripts && \
    apt autoremove && apt clean

COPY initialization/*.sql /docker-entrypoint-initdb.d/
