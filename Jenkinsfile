pipeline {
    agent { label "slave" }
    environment{
        branchName = sh(
            script: "echo ${env.GIT_BRANCH} | sed -e 's|/|-|g'",
            returnStdout: true
        ).trim()
        dockerTag="${env.branchName}-${env.BUILD_NUMBER}"
        dockerImage="${env.CONTAINER_IMAGE}:${env.dockerTag}"
        appName="warp-api-proxy"
        githubUsername="evrynet-official"

        CONTAINER_IMAGE="registry.gitlab.com/evry/${appName}"
        status_failure="{\"state\": \"failure\",\"context\": \"continuous-integration/jenkins\", \"description\": \"Jenkins\", \"target_url\": \"${BUILD_URL}\"}"
        status_success="{\"state\": \"success\",\"context\": \"continuous-integration/jenkins\", \"description\": \"Jenkins\", \"target_url\": \"${BUILD_URL}\"}"
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
                        docker build --pull -t ${dockerImage} -f docker/Dockerfile .
                    '''
                }
            }
        }

        stage('Unit Test') {
            steps {
                sh '''
                    echo "Run unit test -> ${dockerImage}"
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
                        docker push ${dockerImage}
                        docker tag ${dockerImage} ${CONTAINER_IMAGE}:${branchName}
                        docker push ${CONTAINER_IMAGE}:${branchName}
                    '''
                }
            }
        }
    }
    post {
        failure {
            withCredentials([string(credentialsId: 'evry-github-token-pipeline-status', variable: 'githubToken')]) {
                sh '''
                    curl \"https://api.github.com/repos/${githubUsername}/${appName}/statuses/${GIT_COMMIT}?access_token=${githubToken}\" \
                    -H \"Content-Type: application/json\" \
                    -X POST \
                    -d "${status_failure}"
                '''
                }
        }
        success {
            withCredentials([string(credentialsId: 'evry-github-token-pipeline-status', variable: 'githubToken')]) {
                sh '''
                    curl \"https://api.github.com/repos/${githubUsername}/${appName}/statuses/${GIT_COMMIT}?access_token=${githubToken}\" \
                    -H \"Content-Type: application/json\" \
                    -X POST \
                    -d "${status_success}"
                '''
                }
        }
        always {
            sh '''
               docker image rm -f ${CONTAINER_IMAGE}:${branchName}
               docker image rm -f ${dockerImage}
            '''
            deleteDir()
        }
    }
}
