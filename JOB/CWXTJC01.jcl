//PFHMKS0A JOB ('#SALESSUP'),'CWXTJC01', TYPRUN=SCAN,
//             CLASS=A,MSGCLASS=R,NOTIFY=&SYSUID
/*JOBPARM S=*
//*
//*********************************************************************
//*                                                                   *
//*  MEMBER = CWXTJC01                                               *
//*                                                                   *
//*  THIS IS SAMPLE JCL TO EXECUTE COBOL PROGRAM CWXTCOB              *
//*                                                                   *
//*********************************************************************
//*
//*   EXECUTE CWXTCOB IN BATCH
//*
//CWXTCOB  EXEC PGM=CWXTCOB,PARM=00001
//*
//STEPLIB  DD  DISP=SHR,DSN=SALESSUP.MKS1.DEV1.LOAD
//         DD  DISP=SHR,DSN=SALESSUP.MKS1.QA1.LOAD
//         DD  DISP=SHR,DSN=SALESSUP.MKS1.STG.LOAD
//         DD  DISP=SHR,DSN=SALESSUP.MKS1.PRD.LOAD
//*
//EMPFILE  DD  DISP=SHR,DSN=SALESSUP.MKS1.PRD.CWXTDATA
//RPTFILE  DD  SYSOUT=*
//SYSOUT   DD  SYSOUT=*