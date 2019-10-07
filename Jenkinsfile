pipeline {
    agent { label "slave" }
    environment{
        branchName = sh(
            script: "echo ${env.GIT_BRANCH} | sed -e 's|/|-|g'",
            returnStdout: true
        )
        dockerTag="${env.branchName}"
        dockerImage="${env.CONTAINER_IMAGE}:${env.dockerTag}"
        appName="warp-api-proxy"

        CONTAINER_IMAGE="registry.gitlab.com/evry/${appName}"
    }
    stages {
        stage ('Cleanup') {
            steps {
                dir('directoryToDelete') {
                    deleteDir()
                }
            }
        }

        stage('Build Image Test') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'devopsautomate', passwordVariable: 'gitlabPassword', usernameVariable: 'gitlabUsername')]) {
                    sh '''
                        echo "Build Image"
                        docker login -u ${gitlabUsername} -p ${gitlabPassword} registry.gitlab.com
                        docker build --pull -t ${CONTAINER_IMAGE}:${dockerTag} -f docker/Dockerfile .
                    '''
                }
            }
        }

        stage('Unit Test') {
            steps {
                sh '''
                    echo "Run unit test -> ${CONTAINER_IMAGE}:${dockerTag}"
                '''
            }
        }

        stage('SonarQube Code Analysis') {
            steps {
                sh '''
                    echo "SonarQube Code Analysis"              
                '''
            }
        }

        stage('SonarQube Quality Gate') {
            steps {
                sh '''
                    echo "SonarQube Quality Gate"    
                '''
            }
        }

        stage('Build and Push to Registry') {
            when {
                anyOf {
                    branch 'feat/docker';
                    branch 'feature/pipeline';
                    branch 'develop';
                    branch 'release/*';
                    branch 'master'
                }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'devopsautomate', passwordVariable: 'gitlabPassword', usernameVariable: 'gitlabUsername')]) {
                    sh '''
                        echo "Push to Registry"
                        docker login -u ${gitlabUsername} -p ${gitlabPassword} registry.gitlab.com
                        docker push ${CONTAINER_IMAGE}:${dockerTag}
                        docker tag ${CONTAINER_IMAGE}:${dockerTag} ${CONTAINER_IMAGE}:${branchName}
                        docker push ${CONTAINER_IMAGE}:${branchName}
                    '''
                }
            }
        }
    }
    post {
            always {
                deleteDir()
            }
    }
}
