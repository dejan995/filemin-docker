#!/bin/bash

REGISTRY_NAME="docker.io"
REPOSITORY=dejan995/filemin-docker
TAG_OLD=$TAG_NEW
TAG_NEW=$TAG_OLD
CONTENT_TYPE="application/vnd.docker.distribution.manifest.v2+json"

MANIFEST=$(curl -H "Accept: ${CONTENT_TYPE}" "${REGISTRY_NAME}/v2/${REPOSITORY}/manifests/${TAG_OLD}")
curl -X PUT -H "Content-Type: ${CONTENT_TYPE}" -d "${MANIFEST}" "${REGISTRY_NAME}/v2/${REPOSITORY}/manifests/${TAG_NEW}"