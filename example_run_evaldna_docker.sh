#!/bin/bash

cd EvalDNA_v1.1

docker build -t evaldna_test . 

docker run -t -u $(id -u):$(id -g) -v ./EvalDNA/EvalDNAv1.1/results:/usr/src/app/results -v ./EvalDNA/EvalDNA_v1.1/code:/usr/src/app/code -v ./EvalDNA/EvalDNA_v1.1/data:/usr/src/app/data --name edtest -t --cpus="16" evaldna_test

docker container rm --force edtest

cd ..

