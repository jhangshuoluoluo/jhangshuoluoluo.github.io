#!/bin/bash

push_date=`date +"%Y-%m-%d-%H"`

echo "publish an article"

git add .
git commit -m "Publish an article at $push_date"
git push

echo "Done"
