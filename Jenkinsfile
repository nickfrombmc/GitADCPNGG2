#!/usr/bin/env groovy
import hudson.model.*
import hudson.EnvVars
import groovy.json.JsonSlurper
import groovy.json.JsonBuilder
import groovy.json.JsonOutput
import java.net.URL

String ISPW_Application     = "NGG2"        // Change to your assigned application
String HCI_Token            = "IMINGG0"     // Change to your assigned ID
String Host_Connection      = "de2ad7c3-e924-4dc2-84d5-d0c3afd3e756"
String Jenkins_CES_Credentials = "IMINGG0_CES"
String ISPW_Runtime_Config  = "ICCGA"
String ISPW_Assignment = ""

println "branch: " + env.BRANCH_NAME
    
if (env.BRANCH_NAME == "main")
{
    currentBuild.result = 'SUCCESS'
    return
}

node {
  stage ('Checkout')
  {
    // Get the code from the Git repository
    checkout scm 
  }

  stage('Mainframe Load')
  {
    gitToIspwIntegration app: "${ISPW_Application}",
    subAppl: "${ISPW_Application}",
    ispwConfigPath: './ispwconfig-nosb.yml',
    branchMapping: '''*release* => STG, per-branch'
    bug* => EMR, per-branch
    *feature1* => QA1, per-branch
    *feature2* => QA2, per-branch
    *feature3* => QA3, per-branch''',
    connectionId: 'de2ad7c3-e924-4dc2-84d5-d0c3afd3e756', // CWCC
    credentialsId: "${HCI_Token}",
    gitCredentialsId: 'IMINGG0-Git', // GHE testdrive
    gitRepoUrl: 'https://github.com/nickfrombmc/GitADCPNGG2.git',
    runtimeConfig: 'ICCGA', // CWCC
    stream: 'FTSDEMO'
  }

  stage('Mainframe Build')
  {
    ispwOperation connectionId: 'de2ad7c3-e924-4dc2-84d5-d0c3afd3e756', // CWCC
    consoleLogResponseBody: false,
    credentialsId: 'IMINGG0_CES', // CWCC
    ispwAction: 'BuildTask',
    ispwRequestBody: '''buildautomatically = true'''
  }

 stage('Run Tests')
  {
    sleep(10)
    println "TTT Tests successfull!"
  }
  
  stage('Retrieve Code Coverage')
  {
    sleep(5)
    println "Retrieve code successfull!"
  }

  stage('Run Sonar Analysis')
  {
    sleep(12)
    println "Sonar analysis successfull!"
  }
  
  stage('Deploy to Runtime')
  {
    sleep(7)
    println "Deploy successfull!"
  }
  
      if (env.BRANCH_NAME.startsWith("release"))
      {
            def continueRelease         = false
    
            echo "Paramters"
            echo 'ISPW_Application          : ' + ISPW_Application        
            echo 'ISPW_Assignment           : ' + ISPW_Assignment         
            echo 'ISPW_Owner_Id             : ' + HCI_Token            
            echo 'Host_Connection           : ' + Host_Connection          
            echo 'Jenkins_CES_Credentials   : ' + Jenkins_CES_Credentials  
            echo 'ISPW_Runtime_Config       : ' + ISPW_Runtime_Config     
               
        
            stage("Manual Intervention"){
    
           //input 'Manual Intervention Point for Demo Purposes'
           // Define a String parameter for user input
                    ISPW_Assignment = input(
                        id: 'userInputName',
                        message: 'Please enter Container name:',
                        parameters: [
                            [$class: 'StringParameterDefinition', defaultValue: 'MKS2000020', description: 'Container Name', name: 'nameInput']
                        ]
                    )
    
        }
    
        dir('./') {
            deleteDir()
        }
    
        //def releaseNumber = env.BRANCH_NAME.substring(1, 5)
        //def releaseNumberParts = releaseNumber.split("[.]")
    
        ISPW_Release = ISPW_Application + "REL" + env.BRANCH_NAME.substring(7, 9)
    
        echo "ISPW_Release              : " + ISPW_Release
    
        currentBuild.displayName = ISPW_Application + "/" + HCI_Token + ", Release: " + ISPW_Release
            
            stage("Create ISPW Release"){
        
                ispwOperation (
                    connectionId:           Host_Connection, 
                    credentialsId:          Jenkins_CES_Credentials, 
                    consoleLogResponseBody: true,             
                    ispwAction:             'CreateRelease', 
                    ispwRequestBody: """
                        runtimeConfiguration=${ISPW_Runtime_Config}
                        stream=FTSDEMO
                        application=${ISPW_Application}
                        subAppl=${ISPW_Application}
                        releaseId=${ISPW_Release}
                        description=RELEASE ${ISPW_Release} FOR GITFLOW APP ${ISPW_Application}
                    """
                )
            }
            
            stage("Transfer Tasks"){
                
                ispwOperation(
                    connectionId:           Host_Connection, 
                    credentialsId:          Jenkins_CES_Credentials, 
                    consoleLogResponseBody: true,             
                    ispwAction:             'TransferTask', 
                    ispwRequestBody:        """
                        runtimeConfiguration=${ISPW_Runtime_Config}
                        assignmentId=${ISPW_Assignment}
                        level=STG
                        containerId=${ISPW_Release}
                        containerType=R
                    """
                )        
            }
            
               stage("User Acceptance Test"){
                sleep 10
            }
        
        
            stage("Manual Intervention"){
        
                input 'Manual Intervention Point for Demo Purposes'
        
            }
        
            stage("Promote Release to PROD"){
                
                ispwOperation(
                    connectionId:           Host_Connection, 
                    credentialsId:          Jenkins_CES_Credentials, 
                    consoleLogResponseBody: true,             
                    ispwAction:             'PromoteRelease', 
                    ispwRequestBody:        """
                        runtimeConfiguration=${ISPW_Runtime_Config}
                        releaseId=${ISPW_Release}
                        level=STG                
                    """
                )        
            }
        
            stage("Decision"){
        
                def releaseStatus
        
                releaseStatus = input(
                    message: 'Select the status for the release from the options below and click "Proceed"', 
                    parameters: [
                        choice(choices: ['Successful Release', 'Abort Release'], description: 'Options', name: 'releaseOption')]        
                )
        
                if(releaseStatus == 'Successful Release'){
                    continueRelease = true
                }
                else{
                    continueRelease = false
                }
            }
        
            if(continueRelease){
        
                stage("Close Release"){
        
                    ispwOperation(
                        connectionId:           Host_Connection, 
                        credentialsId:          Jenkins_CES_Credentials, 
                        consoleLogResponseBody: true,             
                        ispwAction:             'CloseRelease', 
                        ispwRequestBody:        """
                            runtimeConfiguration=${ISPW_Runtime_Config}
                            releaseId=${ISPW_Release}
                        """
                    )
                }
            }
            else
            {
            }
      }
}