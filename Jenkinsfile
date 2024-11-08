pipeline{
  environment {
  registry = "paulmercer/vatcal"
  registryCredentials = "dockerhub_id"
  dockerImage = ""
  gitTag = ""
  }
  
  agent any
  stages {
    stage('Env vars'){
      steps {
        script {
          gitTag = sh(returnStdout:  true, script: "git tag --sort=-creatordate | head -n 1").trim()
          env.gitTag = gitTag
          echo "env.gitTag is ${env.gitTag} and gitTag is ${gitTag}"
        }
      }
    }
    stage ('Build Docker Image'){
      steps{
        script {
          dockerImage = docker.build(registry)
        }
      }
    }

    stage ("Push to Docker Hub"){
      steps {
        script {
          docker.withRegistry('', registryCredentials) {
            dockerImage.push("${env.BUILD_NUMBER}")
            dockerImage.push("latest")
          }
        }
      }
    }

    stage("Push tagged version"){
      when {
        expression { return env.gitTag != null }
      }
      steps {
        script {
          docker.withRegistry('', registryCredentials) {
            dockerImage.push("${gitTag}")
          }
        }
      }
    }
    stage ("Clean up"){
      steps {
        script {
          sh 'docker image prune --all --force --filter "until=48h"'
        }
      }
    }
  }
}
