#!/bin/bash
echo "Terminated :........" 
cd ./terraform/environments/preproduction/instances/runner/spot
terragrunt run-all destroy -lock=false --terragrunt-parallelism 1 --terragrunt-non-interactive