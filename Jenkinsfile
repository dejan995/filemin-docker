pipeline {
  agent any
  stages {
    stage('Cloning Git') {
      parallel {
        stage('Cloning Git') {
          steps {
            checkout scm
          }
        }

        stage('Docker Login') {
          steps {
            withCredentials(bindings: [usernamePassword(credentialsId: 'docker_id', passwordVariable: 'pass', usernameVariable: 'user')]) {
              sh 'docker login -u $user -p $pass'
            }

          }
        }

      }
    }

    stage('Build & Deploy Image') {
      steps {
        sh '''docker run --privileged --rm tonistiigi/binfmt --install amd64
              docker run --privileged --rm tonistiigi/binfmt
              docker buildx rm docker
              docker buildx create --name docker --use docker
              docker buildx build --platform linux/amd64,linux/arm64 \\
                -t dejan995/filemin-docker:$BUILD_NUMBER \\
                -t dejan995/filemin-docker:latest \\
              --push \\
              .'''
      }
    }

  }
  environment {
    registry = 'dejan995/filemin-docker'
    registryCredential = 'docker_id'
    dockerImage = 'dejan995/filemin-docker'
  }
}