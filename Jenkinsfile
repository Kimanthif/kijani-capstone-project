pipeline {
    agent any

    environment {
        DOCKERHUB_USER = credentials('dockerhub-username')
        DOCKERHUB_PASS = credentials('dockerhub-password')
        IMAGE_NAME     = "felistus/kijani-php-nginx"
        DOCKERFILE_DIR = "docker"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Checking out repo..."
                checkout scm
            }
        }

        stage('Build Image') {
            steps {
                sh """
                    cd ${DOCKERFILE_DIR}
                    docker build -t ${IMAGE_NAME}:latest .
                """
            }
        }

        stage('Test Run Container') {
            steps {
                sh "docker rm -f kijani-test || true"
                sh "docker run -d --name kijani-test -p 9090:80 ${IMAGE_NAME}:latest"
                sh "sleep 5"
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh """
                    echo ${DOCKERHUB_PASS} | docker login -u ${DOCKERHUB_USER} --password-stdin
                    docker push ${IMAGE_NAME}:latest
                """
            }
        }
    }

    post {
        cleanup {
            echo "Cleaning up test container..."
            sh "docker rm -f kijani-test || true"
        }
    }
}