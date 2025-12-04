pipeline {
    agent {
        docker {
            image 'maven:3.9.2-eclipse-temurin-17'
            // host network so container can hit Sonar at localhost:9000
            args '-u root -v /var/lib/jenkins/.m2:/root/.m2 --network host'
        }
    }

    environment {
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
                sh './mvnw -B -DskipTests package'
            }
        }

        stage('SonarQube Analysis') {
            steps {
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
