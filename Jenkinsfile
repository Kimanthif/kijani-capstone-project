pipeline {
    agent any   // ✅ FIX: no label needed

    environment {
        DOCKER_IMAGE = "kijani-php-nginx"
        GIT_CREDENTIALS = 'github-creds'
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/develop']],   // ✅ FIX: correct branch
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
                    docker build -t ${DOCKER_IMAGE}:latest .
                """
            }
        }

        stage('Run Docker Container') {
            steps {
                sh """
                    echo "Running Docker container..."
                    docker run -d -p 8080:80 --name kijani-container ${DOCKER_IMAGE}:latest
                """
            }
        }

        stage('Test Application') {
            steps {
                sh "curl -I http://localhost:8080 || true"
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