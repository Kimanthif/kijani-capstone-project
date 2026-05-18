# Kijani Capstone Project – CI/CD Pipeline

A full DevOps CI/CD pipeline for a PHP-based backend application using Docker, Jenkins, GitHub Webhooks, and Terraform-based infrastructure.

## Architecture Overview

GitHub (develop branch)
        │
        ▼
GitHub Webhook (ngrok)
        │
        ▼
Jenkins Pipeline
        │
 ┌──────┼────────┬───────────┐
 ▼      ▼        ▼           ▼
Build  Smoke   DockerHub   Cleanup
Docker Test     Push
        │
        ▼
Docker Container (8081)

## Tech Stack

- Backend: PHP (Nginx + PHP-FPM)
- CI/CD: Jenkins
- Containerization: Docker
- Registry: DockerHub
- Source Control: GitHub
- Infrastructure: Terraform + AWS-ready setup
- Webhook Tunneling: ngrok

## Project Structure

.
├── ansible/
│   ├── ansible.cfg
│   ├── deploy.sh
│   ├── group_vars/
│   │   ├── all.yml
│   │   ├── dev.yml
│   │   ├── staging.yml
│   │   └── prod.yml
│   ├── inventory/
│   │   ├── dev
│   │   ├── staging
│   │   └── prod
│   ├── playbooks/
│   │   ├── deploy.yml
│   │   ├── full_pipeline.yml
│   │   ├── setup.yml
│   │   ├── site.yml
│   │   └── webserver.yml
│   └── roles/
│       ├── app_deploy/
│       │   └── tasks/main.yml
│       ├── common/
│       │   ├── handlers/main.yml
│       │   └── tasks/main.yml
│       ├── configmaps/
│       │   └── tasks/main.yml
│       ├── eks_access/
│       │   └── tasks/main.yml
│       ├── kubernetes/
│       │   └── tasks/main.yml
│       └── webserver/
│           ├── defaults/main.yml
│           ├── files/index.php
│           ├── handlers/main.yml
│           ├── tasks/main.yml
│           └── templates/
│               ├── index.html.j2
│               └── php.conf.j2
│
├── app/
│   └── src/
│       └── index.php
│
├── docker/
│   ├── Dockerfile
│   ├── nginx/
│   │   └── default.conf
│   ├── nginx.conf
│   ├── php/
│   └── start.sh
│
├── docker-compose.yml
│
├── docs/
│   ├── capstone_architecture.png
│   ├── CAPSTONE_SCOPE-1.pdf
│   └── runbook.md
│
├── Jenkinsfile
│
├── monitoring/
│   ├── alerts.yml
│   └── prometheus.yml
│
├── scripts/
│   └── smoke-test.sh
│
├── terraform/
│   ├── envs/
│   │   ├── dev.tfbackend
│   │   ├── staging.tfbackend
│   │   └── prod.tfbackend
│   ├── main.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── staging-namespace.tf
│   ├── userdata.sh
│   ├── variables.tf
│   └── kijani-key.pem
│
├── README.md

## CI/CD Pipeline Stages
1. Checkout

Pulls source code from GitHub (develop branch)

2. Build Docker Image

docker build -t kijani-php-nginx -f docker/Dockerfile .

3. Run Container (Test)

docker run -d -p 8081:80 kijani-php-nginx

4. Smoke Test

curl -f http://localhost:8081

5. Push to DockerHub

docker login
docker push felistus/kijani-php-nginx:latest

6. Cleanup

Stops and removes test containers

Webhook Trigger (GitHub → Jenkins)

Webhook URL:

https://promotive-german-semirural.ngrok-free.dev/github-webhook/

Event:

Push to develop branch

## How to Run Locally

1. Build Image

docker build -t kijani-php-nginx -f docker/Dockerfile .

2. Run Container

docker run -d -p 8081:80 kijani-php-nginx

3. Access App

http://localhost:8081

## Jenkins Requirements

### Required Credentials

- DockerHub credentials ID: dockerhub-credentials

### Jenkins Plugins

- Git plugin
- Docker Pipeline
- Pipeline: GitHub Groovy Libraries


## Known Issues / Fixes

1. Container name conflict

docker rm -f kijani-test

2. DockerHub authentication failure

Ensure:

- Correct username
- Valid Personal Access Token (Read + Write permissions)

3. Webhook not triggering

Check:

- Jenkins URL configured correctly
- GitHub webhook delivery status
- “GitHub hook trigger for GITScm polling” enabled

## Current Status

✔ CI/CD pipeline working
✔ Docker build successful
✔ Smoke test passing
✔ DockerHub push successful
✔ Webhook integration being finalized

## Future Improvements
- Kubernetes deployment automation
- Blue/Green deployment strategy
- Prometheus + Grafana monitoring dashboards
- GitHub Actions backup pipeline
- Centralized logging (ELK stack)


## Author

Felistus Kimanthi | DevOps Capstone Project – 2026