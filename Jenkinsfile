pipeline {
    agent any

    environment {
        IMAGE_NAME = 'devopstask-flask'
        TEST_TAG = 'jenkins-test'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }

        stage('Check Python Version') {
            steps {
                sh 'python3 --version'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'python3 -m pip install --upgrade pip'
                sh 'python3 -m pip install -r requirements.txt'
            }
        }

        stage('Python Syntax Check') {
            steps {
                sh 'python3 -m py_compile app.py'
            }
        }

        stage('Docker Build Test') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$TEST_TAG .'
            }
        }
    }

    post {
        success {
            echo 'Jenkins validation passed successfully.'
        }

        failure {
            echo 'Jenkins validation failed. Please check the logs.'
        }
    }
}