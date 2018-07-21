pipeline {
  agent {
    docker {
      image 'ruby:2.4'
    }

  }
  stages {
    stage('Build') {
      steps {
        sh 'apt-get install curl bzip2 build-essential libssl-dev libreadline-dev zlib1g-dev'
        sh 'bundle install'
      }
    }
    stage('Test') {
      steps {
        sh 'rspec'
      }
    }
  }
}