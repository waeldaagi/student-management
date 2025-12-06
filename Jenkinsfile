pipeline {
    agent any

    environment {
        // Adapt to your SonarQube server URL
        SONAR_HOST_URL = 'http://192.168.149.132:9000'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build + Tests (JUnit)') {
            steps {
                sh 'echo "premier projet maven"'
                sh 'chmod +x mvnw || true'
                sh './mvnw -B clean test'
            }
        }

        stage('Package') {
            steps {
                sh './mvnw -B package'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh "./mvnw -B sonar:sonar -Dsonar.host.url=${SONAR_HOST_URL}"
                }
            }
        }

        stage('Docker Build') {
            steps {
                // Build Docker image for the project
                // You can push later to Docker Hub if you want
                sh 'docker build -t student-management:latest .'
            }
        }
    }

    post {
        success {
            archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
        }
        always {
            junit allowEmptyResults: true, testResults: 'target/surefire-reports/*.xml'
        }
    }
}