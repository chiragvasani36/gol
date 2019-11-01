pipeline {
	
	environment {
    registryCredential = 'dockerhub'
   
    }
	
    agent any
    stages {
        stage('remove and clone') {
            steps {
                sh 'rm -rf gol'
                sh 'git clone https://github.com/chiragvasani36/gol.git'
            }
        }
        
        stage('build and test') {
            steps {
                sh 'mvn clean -f gol'
                sh 'mvn test -f gol'
                
            }
        }
         
        stage('Sonar analysis'){
            steps {
                withSonarQubeEnv('sonarqube') {
                sh 'mvn sonar:sonar -f gol'
              }
            }
        }
        
		stage('install') {
            steps {
                sh 'mvn install -f gol'
            }
        }
        
        stage('remove old build') {
            steps {
                script {
                    result = sh(script: 'docker ps -a -q -f name=jenkins_test', returnStdout: true).trim()
                    if (!result.isEmpty()) {
                        sh 'docker container stop jenkins_test'
                        sh 'docker rm jenkins_test'
                        //sh 'docker rm jenkins_test
						//sh 'docker rmi chiragvasani36/gol_image:prevBuild'
                    }
                }	
            }
        }
        stage('docker build and push') {
            steps 
            {
                sh 'docker build -t chiragvasani36/gol_image:$BUILD_NUMBER ./gol/'
                //sh 'docker tag gol_image chiragvasani36/gol_image:$BUILD_NUMBER'
                script {
                    docker.withRegistry( '', registryCredential ) {
                    
                    sh 'docker push chiragvasani36/gol_image:$BUILD_NUMBER' 
                    }
                }
            }
	    }
		
		
			   
        stage('docker run') {
            steps {
                sh 'docker container run -d -it -p 8083:8080 --name jenkins_test -v /var/lib/tomcat8/conf/tomcat-users.xml:/usr/local/tomcat/conf/tomcat-users.xml chiragvasani36/gol_image:$BUILD_NUMBER'
            }
        }
    }
    
    post 
    { 
        always{
            echo 'Deployed on server with URL : http://gmrse17487dns.eastus2.cloudapp.azure.com:8083/gameoflife/'
            junit 'gol/gameoflife-web/target/surefire-reports/**/*.xml'
        }
    }
}
