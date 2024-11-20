#!/bin/bash

uniget update
uniget install glab

docker pull gitlab/gitlab-ee:17.5.1-ee.0
docker pull gitlab/gitlab-ee:17.5.2-ee.0