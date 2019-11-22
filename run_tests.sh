#!/bin/bash

RANDOM_NAME=$RANDOM

# docker network create -d bridge testbridge-$RANDOM_NAME-id

IMAGE="gcr.io/cloud-marketplace-containers/google/sonarqube7"

for i in `ls tests/functional_tests`;do
docker run --rm -it --privileged \
    -v $PWD/tests/functional_tests:/functional_tests:ro \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --net test-bridge-net \
    gcr.io/cloud-marketplace-ops-test/functional_test \
    --verbose \
    --vars IMAGE=$IMAGE \
    --vars UNIQUE=$RANDOM_NAME \
    --test_spec /functional_tests/$i
done