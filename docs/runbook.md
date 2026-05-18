#  Kijani Capstone Project – Runbook

This runbook provides operational procedures for deploying, troubleshooting, and maintaining the Kijani CI/CD pipeline system.

---

##  System Overview

The system consists of:

- GitHub repository (source control)
- Jenkins CI/CD pipeline
- Docker containerized PHP application
- DockerHub image registry
- ngrok webhook tunnel (GitHub → Jenkins triggers)
- Terraform infrastructure (AWS-ready)
- Ansible automation layer

---

##  CI/CD Workflow

1. Developer pushes code to `develop` branch
2. GitHub triggers webhook
3. Jenkins pipeline runs:
   - Checkout code
   - Build Docker image
   - Run container (test)
   - Execute smoke test
   - Push image to DockerHub
   - Cleanup container

---

##  Jenkins Pipeline Stages

 1. Checkout

Pulls latest code from GitHub repository.

2. Build Docker Image

docker build -t kijani-php-nginx -f docker/Dockerfile .

3. Smoke test failure

Error:
curl: (56) Connection refused

Fix:

- Check container is running:

docker ps

Verify port mapping 8081:80

4. Webhook not triggering Jenkins

Checklist:

- Jenkins URL set correctly
- ngrok tunnel active
- GitHub webhook delivery = 200 OK
- Jenkins job has:
    - “GitHub hook trigger for GITScm polling” enabled

5. Jenkins build fails at Docker login

Fix:

- Re-add credentials in Jenkins:

Manage Jenkins → Credentials → dockerhub-credentials

- Ensure correct ID is referenced in Jenkinsfile

## Health Checks

Application health

curl http://localhost:8081

Expected response:

Kijani Backend is Running!
Environment: development/staging/production

## System Cleanup

Full cleanup

docker system prune -a

- Warning: removes unused images and containers

## Recovery Procedure (Full Restart)

If system breaks:

docker build -t kijani-php-nginx -f docker/Dockerfile .
docker run -d -p 8081:80 kijani-php-nginx
curl http://localhost:8081

## Maintainer

Felistus Kimanthi | DevOps Capstone Project – 2026