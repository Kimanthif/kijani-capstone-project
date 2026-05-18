pipeline {
    agent any

    environment {
        DOCKERHUB_USER = credentials('dockerhub-username')
        DOCKERHUB_PASS = credentials('dockerhub-password')
        IMAGE_NAME = "felistus/kijani-php-nginx"
        DOCKERFILE_DIR = "docker"  
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Checking out source code..."
                checkout scm
                sh "ls -R ."
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image from docker/Dockerfile..."
                sh """
                    cd ${DOCKERFILE_DIR}
                    docker build -t ${IMAGE_NAME}:latest .
                """
            }
        }

        stage('Test Run') {
            steps {
                echo "Running container test on port 9090..."
                sh "docker rm -f kijani-test || true"
                sh "docker run -d --name kijani-test -p 9090:80 ${IMAGE_NAME}:latest"
                sh "sleep 5"
            }
        }

        stage('Push to DockerHub') {
            steps {
                echo "Pushing image to DockerHub..."
                sh """
                    echo ${DOCKERHUB_PASS} | docker login -u ${DOCKERHUB_USER} --password-stdin
                    docker push ${IMAGE_NAME}:latest
                """
            }
        }
    }

    post {
        always {
            echo "Cleaning up test container..."
            sh "docker rm -f kijani-test || true"
        }
    }
}