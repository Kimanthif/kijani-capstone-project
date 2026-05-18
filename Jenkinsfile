pipeline {
    agent any   

    environment {
        DOCKER_IMAGE = "kijani-php-nginx"
        GIT_CREDENTIALS = 'github-creds'
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/develop']],  
                    userRemoteConfigs: [[
                        url: 'https://github.com/Kimanthif/kijani-capstone-project.git',
                        credentialsId: env.GIT_CREDENTIALS
                    ]]
                ])
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                    echo "Building Docker image..."
                    docker build -t ${DOCKER_IMAGE}:latest -f docker/Dockerfile .
                """
            }
        }

        stage('Run Docker Container') {
            steps {
                sh """
                    docker rm -f kijani-container || true
                    docker run -d -p 8081:80 --name kijani-container kijani-php-nginx:latest
                """
            }
        }

        stage('Test Application') {
            steps {
                sh "curl -I http://localhost:8081 || true"
            }
        }

        stage('Cleanup Old Containers') {
            steps {
                sh """
                    echo "Cleaning up..."
                    docker stop kijani-container || true
                    docker rm kijani-container || true
                """
            }
        }
    }

    post {
        always {
            echo "Pipeline execution finished."
        }
        success {
            echo "Pipeline succeeded!"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}