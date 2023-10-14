#!groovy
pipeline {
    // 'agent' here tells the program where to execute. 
    // 'any' in this case means it should execute on any available 
    // jenkins agent
    agent any

    stages{
        
        stage("Preliminary") {
            steps {
                // Here, we prepare the environment
                sh './prelim.sh'
            }
        }

/*
        stage("build") {
            steps {
                // Call shell script to build
                //sh './build.sh'
                // build image
                dockerImage = docker.build("onyeani/apache2:1.0")
                // push image to dockerhub
                withDockerRegistry([ credentialsId: "dockerhub", url: "" ]) {
        dockerImage.push()
            }
            }
        }
  */
  
/*
        stage("build") {
            steps {
                script {
                    // Call shell script to build
                //sh './build.sh'
                // build image
                dockerImage = docker.build("onyeani/apache2:1.0")
                // push image to dockerhub
                withDockerRegistry([ credentialsId: "bfeafbc4-020a-4a68-9d75-304a3172b446", url: "" ]) {
        dockerImage.push()
            }
                }
                
            }
        }

        stage("test") {
            steps {
                // Call shell script to test
                sh './test.sh'
            }
        }
        */

        stage("deploy") {
            steps {
                script {
                    withKubeConfig([credentialsId: 'kubernetes', serverUrl: '192.168.49.2:8443']) {
                    sh './deploy.sh'

                }
                }
                
                // Call shell script to deploy
                //sh './deploy.sh'
            }
        }
        
    }
/*
    post {
        always {
            // This executes at all times. Regardless of the status of the build
        }
        success {
            // exeecutes a script here that runs upon successful completion of jenkinsfile
            echo 'build successful'
        }
        failure {
            // executes if build fails
            echo 'build failed'
        }
    }
    */

}
