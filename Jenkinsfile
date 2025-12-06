pipeline {
    agent any

    environment {
        // SonarQube URL (adapt if needed)
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
                // run tests
                sh './mvnw -B clean test'
            }
        }

        stage('Package') {
            steps {
                // build jar: target/student-management-0.0.1-SNAPSHOT.jar
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
                // Build Docker image using Dockerfile in repo root
                // Requires Docker CLI available to Jenkins
                sh 'sudo docker build -t student-management:latest .'
            }
        }
    }

    post {
        success {
            // archive built jar(s)
            archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
        }
        always {
            // publish JUnit test reports (if any)
            junit allowEmptyResults: true, testResults: 'target/surefire-reports/*.xml'
        }
    }
}