#!/bin/bash

DIR = "" #Set DIR variable to the directory where you cloned the EvalDNA repository
cd EvalDNA_v1.1

docker build -t evaldna . 

docker run -t -u $(id -u):$(id -g) -v $DIR/EvalDNA/EvalDNAv1.1/results:/usr/src/app/results -v $DIR/EvalDNA/EvalDNA_v1.1/code:/usr/src/app/code -v $DIR/EvalDNA/EvalDNA_v1.1/data:/usr/src/app/data --name edtest -t --cpus="16" evaldna

docker container rm --force edtest

cd ..

