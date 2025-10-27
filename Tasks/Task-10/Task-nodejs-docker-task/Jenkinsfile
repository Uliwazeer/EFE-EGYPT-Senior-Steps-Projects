pipeline {
    agent any

    environment {
        IMAGE_NAME = "my-nodejs-app"
        CONTAINER_NAME = "my-nodejs-container"
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Cloning repository..."
                checkout([$class: 'GitSCM', 
                    branches: [[name: '*/nodejs-docker-task']], 
                    userRemoteConfigs: [[url: 'https://github.com/Uliwazeer/Task.git']]])
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                script {
                    try {
                        sh "docker build -t ${IMAGE_NAME} ."
                        env.BUILD_STATUS = "SUCCESS"
                    } catch (Exception e) {
                        env.BUILD_STATUS = "FAILED"
                        error "Docker build failed!"
                    }
                }
            }
        }

        stage('Run Container') {
            steps {
                echo "Running Docker container on port 3000..."
                script {
                    try {
                        // Stop & remove existing container if it exists
                        sh "docker rm -f ${CONTAINER_NAME} || true"
                        // Run the container
                        sh "docker run -d -p 3000:3000 --name ${CONTAINER_NAME} ${IMAGE_NAME}"
                        env.RUN_STATUS = "SUCCESS"
                    } catch (Exception e) {
                        env.RUN_STATUS = "FAILED"
                        error "Docker container failed to start!"
                    }
                }
            }
        }

        stage('Verify') {
            steps {
                echo "Verifying if container is running on port 3000..."
                script {
                    def result = sh(script: "docker ps | grep ${CONTAINER_NAME}", returnStatus: true)
                    if (result == 0) {
                        echo "✅ Container is running successfully on port 3000"
                        env.VERIFICATION = "SUCCESS"
                    } else {
                        echo "❌ Container is NOT running!"
                        env.VERIFICATION = "FAILED"
                        error "Verification failed!"
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Build Status: ${env.BUILD_STATUS ?: 'N/A'}"
            echo "Run Container Status: ${env.RUN_STATUS ?: 'N/A'}"
            echo "Verification Status: ${env.VERIFICATION ?: 'N/A'}"
            echo "Completed at: ${new Date()}"
        }
    }
}
