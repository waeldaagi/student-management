pipeline {
    agent any

    environment {
        // Your host IP where SonarQube is running
        SONAR_HOST_URL = 'http://192.168.149.132:9000'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build (Maven)') {
            steps {
                sh 'echo "premier projet maven"'
                sh 'chmod +x mvnw || true'
                sh './mvnw -B -DskipTests package'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                // "SonarQube" must match the name of the server in Jenkins config
                withSonarQubeEnv('SonarQube') {
                    sh "./mvnw -B sonar:sonar -Dsonar.host.url=${SONAR_HOST_URL}"
                }
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
