pipeline {
    agent any

    environment {
        SONAR_HOST_URL = 'http://192.168.149.132:9000'
        DOCKER_REGISTRY = 'student-management'
        DOCKER_IMAGE = 'student-management:latest'
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Checking out source code..."
                checkout scm
            }
        }

        stage('Build + Tests') {
            steps {
                echo "Building and running tests..."
                sh 'chmod +x mvnw || true'
                sh './mvnw -B clean test'
            }
        }

        stage('Package') {
            steps {
                echo "Packaging application..."
                sh './mvnw -B package -DskipTests'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                echo "Running SonarQube analysis..."
                withSonarQubeEnv('SonarQube') {
                    sh "./mvnw -B sonar:sonar -Dsonar.host.url=${SONAR_HOST_URL}"
                }
            }
        }

        // stage('Docker Build') {
        //     steps {
        //         echo "Building Docker image..."
        //         sh 'docker build -t ${DOCKER_IMAGE} .'
        //         sh 'minikube image load ${DOCKER_IMAGE}'
        //     }
        // }

        stage('Kubernetes Deploy') {
                steps {
            sh '''
            echo "Applying Kubernetes manifests..."

            kubectl apply -f k8s/mysql.yaml
            kubectl apply -f k8s/app.yaml

            echo "Waiting for deployments to become ready..."
            kubectl rollout status deployment/mysql
            kubectl rollout status deployment/student-management

            echo "Current services:"
            kubectl get svc
            '''
        }
        }
    }

    post {
        success {
            echo "Pipeline executed successfully!"
            archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
        }
        always {
            echo "Publishing test results..."
            junit allowEmptyResults: true, testResults: 'target/surefire-reports/*.xml'
        }
        failure {
            echo "Pipeline failed. Check logs above for details."
        }
    }
}