#!/bin/zsh

docker build -t mars_remote_sensing_db .
docker volume rm mars-db
