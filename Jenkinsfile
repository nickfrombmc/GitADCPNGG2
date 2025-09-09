#!/usr/bin/env groovy
import hudson.model.*
import hudson.EnvVars
import groovy.json.JsonSlurper
import groovy.json.JsonBuilder
import groovy.json.JsonOutput
import java.net.URL

String ISPW_Application     = "MKS2"        // Change to your assigned application
String HCI_Token            = "PFHMKS0"     // Change to your assigned ID

node {
  stage ('Checkout')
  {
    // Get the code from the Git repository
    checkout scm
   
    echo "Current branch: ${env.BRANCH_NAME}"
    
    if (${env.BRANCH_NAME} == "main")
    {
        return
    }
    
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
    gitCredentialsId: 'a7500faf-0dd3-42b5-8b00-0553524a79d2', // GHE testdrive
    gitRepoUrl: 'https://github.com/msingh9999/GitADCPMKS2.git',
    runtimeConfig: 'ICCGA', // CWCC
    stream: 'FTSDEMO'
  }

  stage('Mainframe Build')
  {
    ispwOperation connectionId: 'de2ad7c3-e924-4dc2-84d5-d0c3afd3e756', // CWCC
    consoleLogResponseBody: false,
    credentialsId: 'PFHMKS0-CES', // CWCC
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
}