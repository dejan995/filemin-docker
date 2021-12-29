#!/bin/bash
set -eu

docker kill filemin 2>&1 >/dev/null || true
docker rm filemin 2>&1 >/dev/null || true

## testing filemin default authentication
echo "Running filemin in the background"
docker run -d --name filemin -p 3333:10000 dejan995/filemin-docker:latest >/dev/null
sleep 5

rm -rf 'xmlrpc.cgi'
echo "Downloading xmlrpc.cgi using default authentication"
wget --no-check-certificate https://admin:admin@localhost:3333/xmlrpc.cgi >/dev/null
sleep 5
ls -lh 'xmlrpc.cgi'
file 'xmlrpc.cgi'
rm 'xmlrpc.cgi'

# cleanup default authentication test
echo "Cleaning up"
docker kill filemin >/dev/null
docker rm filemin >/dev/null

# testing filemin custom authentication
echo "Running filemin in the background"
docker run -d --name filemin -p 3333:10000 -e WEBMIN_LOGIN=dinosaurs -e WEBMIN_PASSWORD=are-awesome dejan995/filemin-docker:latest >/dev/null
sleep 5

rm -rf 'xmlrpc.cgi'
echo "Downloading xmlrpc.cgi using custom authentication"
wget --no-check-certificate https://dinosaurs:are-awesome@localhost:3333/xmlrpc.cgi >/dev/null
sleep 5
ls -lh 'xmlrpc.cgi'
file 'xmlrpc.cgi'
rm 'xmlrpc.cgi'

# cleanup custom authentication test
echo "Cleaning up"
docker kill filemin >/dev/null
docker rm filemin >/dev/null

echo "Tests succeeded."