pipeline {
    agent any
    environment{
        docker=credentials('gitlab-token')
        IMAGE_NAME='registry.gitlab.com/kumail.r7/slack-docker'
    }
    
    stages {
        stage ("Checkout from git") {
            agent {
                label "agent1" 
            }
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'gitlab-token', url: 'https://gitlab.com/kumail.r7/slack-docker.git']])
            }
        }
        
        stage ("Build the image") {
            agent {
                label "agent1" 
            }
            steps{
                sh "docker build -t ${IMAGE_NAME}:$BUILD_NUMBER ."
            }
        }
        
        stage ("Container Resgistry login") {
            agent {
                label "agent1" 
            }
            steps{
                sh "echo $docker_PSW | docker login registry.gitlab.com -u $docker_USR --password-stdin"
            }
        }
        
        stage ("Scan the image") {
            agent {
                label "agent1" 
            }
            steps {
                sh "trivy image ${IMAGE_NAME}:$BUILD_NUMBER > scanning.txt "
            }
        }
        
        stage ("push the image") {
            agent {
                label "agent1" 
            }
            steps {
                sh "docker push ${IMAGE_NAME}:$BUILD_NUMBER"
            }
        }
        
        stage ("Delete the image") {
            agent {
                label "agent1" 
            }
            steps {
                sh "docker rmi -f ${IMAGE_NAME}:$BUILD_NUMBER"
            }
        }
        
        stage("Checkout only docker-compose file"){
            agent {
                label "deploy-server" 
            }
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'gitlab-token', url: 'https://gitlab.com/kumail.r7/slack-docker.git']])
            }
        }
        
        stage ("Container Resgistry login on deploy-server") {
            agent {
                label "deploy-server" 
            }
            steps{
                sh "echo $docker_PSW | docker login registry.gitlab.com -u $docker_USR --password-stdin"
            }
        }
        
        stage ("pulling the image on deploy-server") {
            agent {
                label "deploy-server" 
            }
            steps {
                sh "docker pull registry.gitlab.com/kumail.r7/slack-docker:$BUILD_NUMBER"
            }
        }
        
        stage ("Deploying of the image") {
            agent {
                label "deploy-server" 
            }
            steps {
                sh "docker compose up -d "
            }
        }
    }
}