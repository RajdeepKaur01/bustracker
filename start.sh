#!/bin/bash

export PORT=5302

cd ~/www/bustracker
./bin/bustracker stop || true
./bin/bustracker start
