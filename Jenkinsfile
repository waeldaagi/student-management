pipeline {
    agent any

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
                // Assumes you configured a SonarQube server named 'SonarQube' in Jenkins
                withSonarQubeEnv('SonarQube') {
                    sh './mvnw -B sonar:sonar'
                }
            }
        }
    }

    post {
        success {
            archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
        }
        always {
            // publish test reports if they exist
            junit allowEmptyResults: true, testResults: 'target/surefire-reports/*.xml'
        }
    }
}
