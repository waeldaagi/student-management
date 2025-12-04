pipeline {
    agent any

    environment {
        // Put the exact URL where Jenkins can reach your SonarQube server.
        // If Jenkins and SonarQube run on the SAME machine, and Jenkins is NOT in Docker:
        //   use 'http://localhost:9000'
        // If Jenkins runs in Docker and Sonar is on the host, use the host IP, e.g.:
        //   'http://192.168.1.50:9000'
        SONAR_HOST_URL = 'http://localhost:9000'
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
                // Build the project, skip tests to speed up if you want
                sh './mvnw -B -DskipTests package'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                // "SonarQube" must match the name configured in
                // Manage Jenkins -> Configure System -> SonarQube servers
                withSonarQubeEnv('SonarQube') {
                    sh "./mvnw -B sonar:sonar -Dsonar.host.url=${SONAR_HOST_URL}"
                }
            }
        }
    }

    post {
        success {
            // Archive built JAR(s)
            archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
        }
        always {
            // Publish test reports if present (ignore if none)
            junit allowEmptyResults: true, testResults: 'target/surefire-reports/*.xml'
        }
    }
}
