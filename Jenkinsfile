pipeline {
    agent any

    tools {
        // Replace 'Maven3' and 'JDK17' with the exact names you set in Global Tool Configuration
        maven 'Maven3'
        jdk 'JDK17'
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
                sh 'mvn -B -DskipTests package'
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
