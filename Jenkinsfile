pipeline {
    agent any

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

        stage('Create Virtual Environment') {
            steps {
                sh 'python3 -m venv .venv'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '. .venv/bin/activate && python3 -m pip install --upgrade pip'
                sh '. .venv/bin/activate && python3 -m pip install -r requirements.txt'
            }
        }

        stage('Python Syntax Check') {
            steps {
                sh '. .venv/bin/activate && python3 -m py_compile app.py'
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