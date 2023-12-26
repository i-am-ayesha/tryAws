pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                script {
                    dockerImage = docker.build("ayesha65/personal-portfolio:${env.BUILD_ID}")
                }
            }
        }
        stage('Push') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        dockerImage.push()
                    }
                }
            }
        }
        stage('Test') {
            steps {
                sh 'ls -l index.html'
            }
        }
        stage('Deploy') {
            steps {
                script {
                    sshPublisher(
                        publishers: [
                            sshPublisherDesc(
                                configName: "tocs-assignment",
                                transfers: [sshTransfer(
                                    execCommand: """
                                        docker pull ayesha65/personal-portfolio:${env.BUILD_ID}
                                        docker stop personal-portfolio-container || true
                                        docker rm personal-portfolio-container || true
                                        docker run -d --name personal-portfolio-container -p 80:80 ayesha65/personal-portfolio:${env.BUILD_ID}
                                    """
                                )]
                            )
                        ]
                    )

                    boolean isDeploymentSuccessful = sh(script: 'curl -s -o /dev/null -w "%{http_code}" http://13.55.189.21', returnStdout: true).trim() == '200'

                    if (!isDeploymentSuccessful) {
                        def previousSuccessfulTag = readFile('previous_successful_tag.txt').trim()
                        sshPublisher(
                            publishers: [
                                sshPublisherDesc(
                                    configName: "tocs-assignment",
                                    transfers: [sshTransfer(
                                        execCommand: """
                                            docker pull ayesha65/distance-converter:${previousSuccessfulTag}
                                            docker stop distance-converter-container || true
                                            docker rm distance-converter-container || true
                                            docker run -d --name distance-converter-container -p 80:80 ayesha65/distance-converter:${previousSuccessfulTag}
                                        """
                                    )]
                                )
                            ]
                        )
                    } else {
                        writeFile file: 'previous_successful_tag.txt', text: "${env.BUILD_ID}"
                    }
                }
            }
        }
    }
    post {
        failure {
            mail(
                to: 'ayeshanazakat65@gmail.com',
                subject: "Failed Pipeline: ${env.JOB_NAME} [${env.BUILD_NUMBER}]",
                body: "Something is wrong with the build ${env.BUILD_URL}"
            )
        }
    }
}
