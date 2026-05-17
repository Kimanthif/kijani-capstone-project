pipeline {
    agent any

    environment {
        IMAGE_NAME = "kijani-php-nginx"
        IMAGE_TAG  = "latest"
        DOCKERHUB_USER = "felistus"
        DOCKER_DIR = "backend-platform"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Pulling source code..."
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh """
                    cd ${DOCKER_DIR}
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                """
            }
        }

        stage('Run Container (Test)') {
            steps {
                echo "Running test container..."
                sh """
                    docker rm -f test-${IMAGE_NAME} 2>/dev/null || true
                    docker run -d --name test-${IMAGE_NAME} -p 8081:80 ${IMAGE_NAME}:${IMAGE_TAG}
                    sleep 5
                    docker ps
                """
            }
        }

        stage('Push to DockerHub') {
            steps {
                echo "Pushing Docker image to DockerHub..."
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh """
                        echo "$PASS" | docker login -u "$USER" --password-stdin
                        docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${USER}/${IMAGE_NAME}:${IMAGE_TAG}
                        docker push ${USER}/${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up..."
            sh "docker rm -f test-${IMAGE_NAME} 2>/dev/null || true"
        }
        success { echo "DockerHub pipeline success!" }
        failure { echo "Pipeline failed — check logs." }
    }
}