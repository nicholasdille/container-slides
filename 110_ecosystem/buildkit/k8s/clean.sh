#!/bin/bash

docker rm -f registry
kind delete cluster
