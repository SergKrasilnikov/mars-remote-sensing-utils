#!/bin/zsh

docker run -d -p 5432:5432 \
  -e POSTGRES_PASSWORD="secret :) no one knows :)" \
  -e MARKWATNEY_PASSWORD="secret :) no one knows :)" \
  -e TESTER_PASSWORD="secret :) no one knows :)" \
  -v mars-db:/var/lib/postgresql/data \
  mars_remote_sensing_db
