pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
        IMAGE_NAME = "kimanthif/kijani-php-nginx"
        APP_DIR = "kijani-php-nginx"   
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
                    cd ${APP_DIR}
                    docker build -t ${IMAGE_NAME}:latest .
                """
            }
        }

        stage('Run Container (Test)') {
            steps {
                echo "Running test container..."
                sh """
                    docker run -d --name test-kijani -p 8081:80 ${IMAGE_NAME}:latest
                    sleep 5
                    docker ps
                """
            }
        }

        stage('Push to DockerHub') {
            steps {
                echo "Pushing image to DockerHub..."
                sh """
                    echo "${DOCKERHUB_CREDENTIALS_PSW}" | docker login -u "${DOCKERHUB_CREDENTIALS_USR}" --password-stdin
                    docker push ${IMAGE_NAME}:latest
                """
            }
        }
    }

    post {
        always {
            echo "Cleaning up..."
            sh "docker rm -f test-kijani || true"
        }
    }
}