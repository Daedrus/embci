#!/bin/sh

/usr/bin/docker-entrypoint.sh "$@" &

sleep 3

mc alias set embci http://localhost:9000 minioadmin minioadmin
mc mb embci/embci-artifacts

sleep infinity
