#!/bin/bash
echo "Started :........."
cd ./terraform/environments/preproduction/instances/runner/spot
terragrunt run-all apply -lock=false --terragrunt-parallelism 1 --terragrunt-non-interactive