#!/bin/sh
cd /home/app/beforethebanners.com
rake assets:precompile
export BUNDLE_PATH=/home/app/tmp