#!/bin/bash

set -e

docker-compose run --rm terraform bash -c "cd ./domains && terragrunt run-all plan"

docker-compose run --rm terraform bash -c "cd ./domains && terragrunt run-all apply"
