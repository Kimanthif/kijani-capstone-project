pipeline {
    agent any

    environment {
        IMAGE_NAME = "kijani-php-nginx"
        IMAGE_TAG  = "latest"
        DOCKERHUB_USER = "your-dockerhub-username"
        AWS_REGION = "eu-north-1"
        AWS_ACCOUNT_ID = "your-aws-account-id"
        ECR_REPO = "kijani-php-nginx"
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
                sh '''
                    cd kijani-php-nginx
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                '''
            }
        }

        stage('Run Container (Test)') {
            steps {
                echo "Running container for verification..."
                sh '''
                    docker rm -f test-${IMAGE_NAME} 2>/dev/null || true
                    docker run -d --name test-${IMAGE_NAME} -p 8081:80 ${IMAGE_NAME}:${IMAGE_TAG}
                    sleep 5
                    docker ps
                '''
            }
        }

        stage('Push to DockerHub') {
            when {
                expression { return env.DOCKERHUB_USER != "" }
            }
            steps {
                echo "Pushing image to DockerHub..."
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                        echo "$PASS" | docker login -u "$USER" --password-stdin
                        docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${USER}/${IMAGE_NAME}:${IMAGE_TAG}
                        docker push ${USER}/${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Push to AWS ECR') {
            when {
                expression { return env.AWS_ACCOUNT_ID != "" }
            }
            steps {
                echo "Pushing image to AWS ECR..."
                withCredentials([aws(credentialsId: 'aws-creds', region: "${AWS_REGION}")]) {
                    sh '''
                        aws ecr get-login-password --region ${AWS_REGION} \
                        | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

                        docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}

                        docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}
                    '''
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up..."
            sh '''
                docker rm -f test-${IMAGE_NAME} 2>/dev/null || true
            '''
        }
        success {
            echo "Build and push completed successfully!"
        }
        failure {
            echo "Pipeline failed — check logs."
        }
    }
}