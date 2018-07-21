pipeline {
  agent {
    docker {
      image 'ruby:2.4'
    }

  }
  stages {
    stage('Build') {
      steps {
        sh 'apt-get install build-essential'
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