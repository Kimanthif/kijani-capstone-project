#!/bin/bash

ENV=$1

if [ -z "$ENV" ]; then
  echo "❌ Please provide environment: dev | staging | prod"
  exit 1
fi

echo "Deploying to $ENV environment..."

ansible-playbook \
  -i inventory/$ENV \
  playbooks/site.yml

echo "Deployment to $ENV completed"