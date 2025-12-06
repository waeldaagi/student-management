pipeline {
    agent any

    environment {
        // adapte cette URL si besoin (on avait mis ton IP pour SonarQube)
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
                // ICI : on fait tourner les tests (JUNIT via Maven Surefire)
                sh './mvnw -B clean test'
            }
        }

        stage('Package') {
            steps {
                // build du jar après les tests
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
    }

    post {
        success {
            // archive le jar
            archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
        }
        always {
            // PUBLIE LES RAPPORTS JUNIT
            // par défaut Maven Surefire met les rapports ici
            junit allowEmptyResults: true, testResults: 'target/surefire-reports/*.xml'
        }
    }
}
