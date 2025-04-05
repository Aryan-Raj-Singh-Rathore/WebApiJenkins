pipeline {
    agent any

    environment {
        AZURE_CREDENTIALS_ID = 'jenkins-pipeline-sp'
        RESOURCE_GROUP       = 'WebServiceRG'
        APP_SERVICE_NAME     = 'RathoreeeWebApp03'
        TF_WORKING_DIR       = '.'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'master', url: 'https://github.com/Aryan-Raj-Singh-Rathore/WebApiJenkins.git'
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
                    bat """
                    echo "Initializing Terraform..."
                    cd %TF_WORKING_DIR%
                    terraform init
                    """
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
                    bat """
                    cd %TF_WORKING_DIR%
                    terraform plan -out=tfplan ^
                      -var client_id=%AZURE_CLIENT_ID% ^
                      -var client_secret=%AZURE_CLIENT_SECRET% ^
                      -var tenant_id=%AZURE_TENANT_ID% ^
                      -var subscription_id=%AZURE_SUBSCRIPTION_ID%
                    """
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
                    bat """
                    cd %TF_WORKING_DIR%
                    terraform apply -auto-approve tfplan
                    """
                }
            }
        }

        stage('Build') {
            steps {
                bat 'dotnet restore'
                bat 'dotnet build --configuration Release'
                bat 'dotnet publish -c Release -o ./publish'
            }
        }

        stage('Deploy') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
                    bat """
                    powershell Compress-Archive -Path ./publish/* -DestinationPath ./publish.zip -Force
                    az webapp deployment source config-zip ^
                        --resource-group %RESOURCE_GROUP% ^
                        --name %APP_SERVICE_NAME% ^
                        --src ./publish.zip
                    """
                }
            }
        }
    }

    post {
        success {
            echo '✅ Deployment Successful!'
        }
        failure {
            echo '❌ Deployment Failed!'
        }
    }
}
