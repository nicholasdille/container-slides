#!/bin/bash

git clone "https://gitlab.inmylab.de/${GIT_USER}/demo" /home/seat/demo
git -C /home/seat/demo remote add upstream https://github.com/nicholasdille/container-slides
