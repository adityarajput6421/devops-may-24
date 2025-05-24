pipeline{
  agent any

  environment {
    AWS_ACCESS_KEY_ID = credentials('cctech acces key id')
    AWS_SECRET_ACCESS_KEY = credentials('cctech-aws-secret-access-key')
    AWS_DEFAULT_REGION = 'ap-south-1' 
    ECR_REPOSITORY = 'cctechlab/assignment'
    GITHUB_REPO = 'cctechlab/assignment' 
    GITHUB_CREDENTIALS_ID = 'github-credentials-id'
  }   
  stages {
    stage('login to ecr') {
      steps {
        echo 'Logging in to ECR...'   
        script {
          def loginCommand = sh(script: "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${ECR_REPOSITORY}", returnStdout: true).trim()
          sh loginCommand
        }
      }
    }
    stage('build and push image to ecr') {
      steps {
          sh "docker build -t ${GITHUB_REPO}:${imageTag} ."
          sh "docker push ${ECR_REPOSITORY}:${imageTag}"
        }       
      }
    }
  }

  post {
    success {
      echo 'Pipeline completed successfully!'
    }
    failure {
      echo 'Pipeline failed.'
    }
  }
