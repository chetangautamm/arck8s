  node {
    
    def registry = "chetangautamm/repo"
    def registryCredential = '58881f31-29bb-48a8-9da9-fc254654146d'
    def dockerImage = ""

    stage('Checkout Source Code') {
        checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: '0280c339-f1a8-48bc-b303-3ec7a661b546', url: 'https://github.com/chetangautamm/arck8s.git']]])
    }

// TO demonstrate real edge scenario credentials needs to be added before the execution.
   stage("Azure Cli:${USERNAME}"){
       sshagent(['${USERNAME}']){
         script{
           try{
             sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${IP} curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash"
           }catch(error){
             sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${IP} curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash"
           }
         }
      }
   }


   stage("Connectedk8s Extension:${USERNAME}"){
       sshagent(['${USERNAME}']){
         script{
           try{
             sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${IP} az extension add --name connectedk8s"
           }catch(error){
             sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${IP} az extension add --name connectedk8s"
           }
         }
       }
     }


   stage("Register Arc Providers:${USERNAME}"){
       sshagent(['${USERNAME}']){
         script{
           try{
             sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${IP} az provider register --namespace Microsoft.Kubernetes"
             sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${IP} az provider register --namespace Microsoft.KubernetesConfiguration"
             sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${IP} az provider register --namespace Microsoft.ExtendedLocation"
           }catch(error){
             sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${IP} az provider register --namespace Microsoft.Kubernetes"
             sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${IP} az provider register --namespace Microsoft.KubernetesConfiguration"
             sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${IP} az provider register --namespace Microsoft.ExtendedLocation"
           }
         }
       }
     }


   stage("Verify Arc Providers:${USERNAME}"){
       sshagent(['${USERNAME}']){
         script{
           try{
             sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${IP} az provider show -n Microsoft.Kubernetes -o table"
             sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${IP} az provider show -n Microsoft.KubernetesConfiguration -o table"
             sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${IP} az provider show -n Microsoft.ExtendedLocation -o table"
           }catch(error){
             sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${IP} az provider show -n Microsoft.Kubernetes -o table"
             sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${IP} az provider show -n Microsoft.KubernetesConfiguration -o table"
             sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${IP} az provider show -n Microsoft.ExtendedLocation -o table"
           }
         }
       }
     }

   
   stage("Create Resource Group"){
       sshagent(['${USERNAME}']){
         script{
           try{
             sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${IP} az group create --name ${USERNAME}_azure --location EastUS --output table"
           }catch(error){
             sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${IP} az group create --name ${USERNAME}_azure --location EastUS --output table"
           }
         }
       }
     }

   
   stage("Connect Existing K8s:${USERNAME}"){
       sshagent(['${USERNAME}']){
         script{
           try{
             sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${IP} az connectedk8s connect --name Edge_Site-1 --resource-group ${USERNAME}_azure"
           }catch(error){
             sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${IP} az connectedk8s connect --name Edge_Site-1 --resource-group ${USERNAME}_azure"
           }
         }
       }
     }

   

   stage("Service Account Token Authentication:${USERNAME}"){
       sh "chmod +x token.sh"
       sshagent(['${USERNAME}']){
         sh "scp -o StrictHostKeyChecking=no -q token.sh ${USERNAME}@${IP}:/home/${USERNAME}/"
         script{
           try{
             sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no kubeadm@${IP} ./token.sh"
           }catch(error){
             sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${IP} ./token.sh"
           }
         }
       }
     }

   

   stage('Deploy Opensips:${USERNAME}') {
        sshagent(['${USERNAME}']) {
          script {
            try {
              sh "sshpass -p ${PASSWORD} scp -o StrictHostKeyChecking=no -q opensips.yaml ${USERNAME}@${IP}:/home/${USERNAME}/"
              sh "sleep 2"
              sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${IP} kubectl apply -f opensips.yaml"
            }catch(error){
              sh "sshpass -p ${PASSWORD} scp -o StrictHostKeyChecking=no -q opensips.yaml ${USERNAME}@${IP}:/home/${USERNAME}/"
              sh "sleep 2"
              sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${IP} kubectl apply -f opensips.yaml"
            }
          }
        }
      }
    stage('Validate Opensips:${USERNAME}') {
        sh "chmod +x configure.sh"
        sshagent(['${USERNAME}']) {
          sh "sshpass -p ${PASSWORD} scp -o StrictHostKeyChecking=no -q configure.sh ${USERNAME}@${IP}:/home/${USERNAME}"
          script {
            sh "sleep 20"
            sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${IP} ./configure.sh"
          }
        }
      } 
 }
