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
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker tag $IMAGE_NAME $DOCKERHUB_REPO:latest
                        docker push $DOCKERHUB_REPO:latest
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