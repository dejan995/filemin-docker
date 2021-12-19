pipeline {

  agent any

  stages {
    stage('Get Code and Login to Docker') {
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
        sh '''docker buildx build --platform linux/amd64,linux/arm64 \\
                -t $DOCKER_IMAGE:$BUILD_VERSION \\
                -t $DOCKER_IMAGE:latest \\
              --push \\
              .'''
      }
    }

    stage('Clean up system') {
      steps {
        sh 'docker buildx prune -a'
      }
    }
  }
  environment {
    DOCKER_IMAGE = 'dejan995/filemin-docker'
    BUILD_VERSION = VersionNumber(
        versionNumberString: '${BUILD_DATE_FORMATTED, "yyyyMMdd"}.${BUILDS_TODAY, XX}',
        projectStartDate:    '1970-01-01',
        skipFailedBuilds:    true)
  }
}