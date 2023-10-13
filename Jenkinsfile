pipeline {
    agent any

    stages {
        stage('Clone repository') {
            steps {
                sh '''
                    cd ~
                    git clone https://github.com/t-Shatterhand/Store-WebApp_Softserve_Academy.git
                '''
            }
        }
        stage('Create EC Registry') {
            steps {
                sh '''
                    cd ~/Store-WebApp_Softserve_Academy/terraform/
                    terraform init
                    terraform apply -auto-approve -target=module.ecr
                    terraform output -raw ecr_url > ecr_url
                    cat ecr_url | rev | cut -d'/' -f2- | rev > ecr_registry
                    cat ecr_url
                    cat ecr_registry
                '''
            }
        }
        stage('Push to Registry') {
            steps {
                sh '''
                    aws --version
                    cd ~/Store-WebApp_Softserve_Academy/
                    sudo docker build . -t softserve-demo/syt:latest -t softserve-demo/syt:build$BUILD_NUMBER
                    sudo docker login -u AWS -p `aws ecr-public get-login-password --region us-east-1` `cat ~/Store-WebApp_Softserve_Academy/terraform/ecr_registry`
                    sudo docker tag softserve-demo/syt:build$BUILD_NUMBER `cat ~/Store-WebApp_Softserve_Academy/terraform/ecr_url`:build$BUILD_NUMBER
                    sudo docker tag softserve-demo/syt:latest `cat ~/Store-WebApp_Softserve_Academy/terraform/ecr_url`
                    sudo docker push `cat ~/Store-WebApp_Softserve_Academy/terraform/ecr_url`
                    sudo docker push `cat ~/Store-WebApp_Softserve_Academy/terraform/ecr_url`:build$BUILD_NUMBER
                '''
            }
        }
        stage('Provision infrastructure') {
            steps {
                sh '''
                    aws ecs update-service --cluster apple-store-demo-3-cluster --service apple-store-demo-3-service --region us-east-1 --force-new-deployment
                '''
            }
        }
        stage("Cleaning build environment"){
            steps{
                sh '''
                    docker system prune -a --volumes -f
                '''
            }
        }
        stage('Destroy') {
            steps {
                sh '''
                    rm -rf ~/Store-WebApp_Softserve_Academy/
                '''
            }
        }
        
    }
}