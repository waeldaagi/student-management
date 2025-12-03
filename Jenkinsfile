pipeline {
    agent {
        docker {
            image 'eclipse-temurin:17-jdk'
            args '-u root -v /var/lib/jenkins/.m2:/root/.m2'
        }
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                sh 'chmod +x mvnw'
                sh './mvnw clean package'
            }
        }
    }
    
    post {
        success {
            archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
        }
    }
}
