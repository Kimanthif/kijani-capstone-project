pipeline {
    agent any

    environment {
        IMAGE_NAME = "kijani-php-nginx"
        DOCKERHUB_REPO = "felistus/kijani-php-nginx"
        CONTAINER_NAME = "kijani-test"
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Pulling source code...'
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh """
                    docker build -t $IMAGE_NAME -f docker/Dockerfile .
                """
            }
        }

        stage('Run Container (Test)') {
            steps {
                echo 'Running container...'
                sh """
                    echo "Cleaning old container if exists..."
                    docker rm -f kijani-test || true

                    echo "Running container..."
                    docker run -d --name kijani-test -p 8081:80 kijani-php-nginx                    
                """
            }
        }

        stage('Smoke Test') {
            steps {
                echo 'Running smoke test...'
                sh """
                    sleep 5
                    curl -f http://localhost:8081 || exit 1
                """
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKERHUB_USER',
                    passwordVariable: 'DOCKERHUB_PASS'
                )]) {
                    sh """
                        echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
                        docker tag kijani-php-nginx $DOCKERHUB_USER/kijani-php-nginx:latest
                        docker push $DOCKERHUB_USER/kijani-php-nginx:latest
                    """
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            sh """
                docker rm -f $CONTAINER_NAME || true
            """
        }
    }
}