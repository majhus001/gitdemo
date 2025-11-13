pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Build') {
      steps {
        echo 'Running mvn clean package (skipping tests to save time)'
        sh 'mvn -B -DskipTests clean package'
      }
    }

    stage('Unit Tests (optional)') {
      steps {
        echo 'Running mvn test (you can skip in exam if slow)'
        sh 'mvn -B test'
      }
      post {
        always { junit '**/target/surefire-reports/*.xml' }
      }
    }

    stage('Archive') {
      steps {
        archiveArtifacts artifacts: 'target/*.jar', onlyIfSuccessful: true
      }
    }
  }

  post {
    success { echo 'Build succeeded ✅' }
    failure { echo 'Build failed 🔥' }
  }
}
