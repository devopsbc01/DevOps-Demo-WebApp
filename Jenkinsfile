pipeline {
  agent any
  stages {
    stage('Sonar Qube Analysis') {
      steps {
        withSonarQubeEnv('sonarqube-server') {
          sh '''
            echo "PATH = ${PATH}"
            echo "M2_HOME = ${M2_HOME}"
            mvn "-Dsonar.test.exclusions=**/test/java/servlet/createpage_junit.java " -Dsonar.login=sonar -Dsonar.password=${SONAR_AUTH} -Dsonar.tests=. -Dsonar.inclusions=**/test/java/servlet/createpage_junit.java -Dsonar.sources=. sonar:sonar -Dsonar.host.url=${SONAR_HOST_URL}
          '''
        }

      }
    }

    stage('Build the project') {
      steps {
        script {
          sh '''
              mvn -B -f pom.xml compile
            '''
        }

      }
    }

    stage('Configure Test Server') {
      steps {
        script {
          sh '''
              gcloud auth activate-service-account --key-file=/var/lib/jenkins/workspace/gcloud_auth
              gcloud config set compute/zone us-central1-a
              testserver=`gcloud compute instances describe test-server --format='get(networkInterfaces[0].accessConfigs[0].natIP)'`
              sed -i "s/squadtestserver/$testserver/g" $(find . -type f)
              ansible-playbook -e "myhostserver=test-server" TestServerCreation.yml
          '''
        }

      }
    }

    // stage('Run the Unit Testing ') {
    //   steps {
    //     script {
    //       sh '''
    //         mvn -B -f pom.xml package
    //       '''
    //     }

    //     // sh 'docker build -t devops-docker-squad5-1 .'
    //   }
    // }

  }
  tools {
    maven 'Maven3.6.3'
    jdk 'JDK'
  }
  environment {
    SONAR_AUTH = credentials('sonar-login')
  }
}
