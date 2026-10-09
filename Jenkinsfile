
pipeline {
    agent any

    environment {
        IMAGE_NAME = 'neelu196/jenkins-cicd'
        TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/neeluu21/jenkins_CICD.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    set -e
                    docker build -t "${IMAGE_NAME}:${TAG}" .
                    docker tag "${IMAGE_NAME}:${TAG}" "${IMAGE_NAME}:latest"
                '''
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh '''
                        set -e
                        set +x

                        echo "$DOCKER_PASS" | docker login \
                            --username "$DOCKER_USER" \
                            --password-stdin

                        docker push "${IMAGE_NAME}:${TAG}"
                        docker push "${IMAGE_NAME}:latest"

                        docker logout
                    '''
                }
            }
        }

        stage('Deploy to Jenkins EC2 Host') {
            steps {
                sh '''
                    set -e

                    docker stop student-app || true
                    docker rm student-app || true

                    docker pull "${IMAGE_NAME}:latest"

                    docker run -d \
                        --name student-app \
                        -p 80:80 \
                        --restart unless-stopped \
                        "${IMAGE_NAME}:latest"
                '''
            }
        }
    }

    post {
        success {
            echo 'CI/CD pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check Console Output for the error.'
        }
    }
}
