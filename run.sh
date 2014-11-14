#!/bin/bash

docker run -v /data/wiki_backup:/data --name mediawiki -p 89:80 -d mediawiki
