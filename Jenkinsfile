pipeline {
  agent {
    docker {
      image 'ruby:2.4'
    }

  }
  stages {
    stage('Build') {
      agent {
        docker {
          image 'ruby:2.4'
        }

      }
      steps {
        sh 'echo "Worked"'
      }
    }
  }
}