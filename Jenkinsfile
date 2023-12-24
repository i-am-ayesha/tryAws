pipeline{

	agent {label 'linux'}

	environment {
		DOCKERHUB_CREDENTIALS=credentials('dockerHub')
	}

	stages {
	    
	    stage('gitclone') {

			steps {
				git 'https://github.com/i-am-ayesha/tryAws.git'
			}
		}

		stage('Build') {

			steps {
				sh 'docker build -t ayesha65/app_test:latest .'
			}
		}

		stage('Login') {

			steps {
				sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
			}
		}

		stage('Push') {

			steps {
				sh 'docker push ayesha65/app_test:latest'
			}
		}
	}

	post {
		always {
			sh 'docker logout'
		}
	}

}
