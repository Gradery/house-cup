pipeline {
  agent {
    docker {
      image 'ruby:2.4'
    }

  }
  stages {
    stage('Build') {
      steps {
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