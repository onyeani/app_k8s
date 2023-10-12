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

        stage("build") {
            steps {
                // Call shell script to build
                sh './build.sh'
            }
        }
        
        stage("test") {
            steps {
                // Call shell script to test
                sh './test.sh'
            }
        }

        stage("deploy") {
            steps {
                // Call shell script to deploy
                sh './deploy.sh'
                // I tried to execute the following command from deploy.sh
                // but for some reason it wouldn't work.
                // Kept saying ERROR 2002 (HY000): Can't connect to local server through socket '/run/mysqld/mysqld.sock' (2)
                // I really don't know the cause. Will find out.
                //sh 'docker exec reviewapp_db_1 ./db_script.sh'
                //echo 'db done'
            }
        }
        
    }

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

}