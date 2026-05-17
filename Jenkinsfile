pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                cd kijani-php-nginx
                docker build -t kijani-php-nginx .
                '''
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                docker stop kijani || true
                docker rm kijani || true
                docker run -d -p 8081:80 --name kijani kijani-php-nginx
                '''
            }
        }
    }
}