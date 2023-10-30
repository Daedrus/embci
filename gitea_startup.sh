#!/bin/bash

set -m

# Start gitea and wait for it to start up
/usr/bin/entrypoint &
while true
do
  gitea_status_code=$(curl --write-out %{http_code} --silent --output /dev/null localhost:3000/ )
  if [ "$gitea_status_code" -eq 200 ]; then
    echo "Gitea ready. Continue with setup..."
    break
  fi
  echo "Gitea is not ready. Waiting 5 seconds..."
  sleep 5
done

# Add embci as admin user
su git -c '/usr/local/bin/gitea --config /data/gitea/conf/app.ini admin user create --username embci --password embci --email embci@embci --admin'

fg
