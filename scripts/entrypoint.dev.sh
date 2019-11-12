#!/bin/sh

echo 'install dependencies...'
mix deps.get
echo 'start server...'
mix phx.server
