#!/bin/bash

#TODO: change these lightspeed-stacks to be run.yaml and have either the auth enabled or not
# if [ "$DEPLOY_TYPE" = "rhdh-pod" ]; then
#     echo "Running in rhdh-pod mode"
#     exec python -m llama_stack.core.server.server --config ./rhdh-pod/lightspeed-stack.yaml
# else
#     echo "Running in separate-deployment mode"
#     exec python -m llama_stack.core.server.server --config ./separate-deployment/lightspeed-stack.yaml
# fi
exec llama stack run run.yaml
