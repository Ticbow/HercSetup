//USERMODS JOB (SYSGEN),'USERMODS',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             REGION=4096K
/*JOBPARM LINES=100
//JOBCAT   DD  DSN=SYS1.VSAM.MASTER.CATALOG,DISP=SHR
//*
//MODIFY   PROC MOD=
//IEBGENER EXEC PGM=IEBGENER
//SYSPRINT DD  DUMMY
//SYSIN    DD  DUMMY
//SYSUT1   DD  DSN=&&OBJMOD,DISP=(OLD,DELETE)
//         DD  DDNAME=SYSUT1A
//SYSUT2   DD  DISP=MOD,DSN=SYS1.UMODOBJ(&MOD.)
//         PEND
//*
//*********************************************************************
//* LOAD TO PDS ASM SOURCE COMPONENTS REQUIRED FOR USERMODS           *
//*********************************************************************
//PDSLOAD EXEC PGM=PDSLOAD,PARM='NEW,UPDTE(><)'
//SYSPRINT DD  SYSOUT=A
//SYSIN    DD  UNIT=TAPE,DISP=OLD,DSN=SMP.SOURCE,
//             VOL=(PRIVATE,RETAIN,SER=SMPPTF),LABEL=(1,SL)
//SYSUT2   DD  DISP=SHR,DSN=SYS1.UMODSRC
//*
//*********************************************************************
//* LOAD TO PDS SMPPTFIN TO INSTALL USERMODS                          *
//*********************************************************************
//PDSLOAD EXEC PGM=PDSLOAD,PARM='NEW,UPDTE(><)'
//SYSPRINT DD  SYSOUT=A
//SYSIN    DD  UNIT=TAPE,DISP=OLD,DSN=SMP.SMPPTFIN,
//             VOL=(PRIVATE,,SER=SMPPTF),LABEL=(2,SL)
//SYSUT2   DD  DISP=(,CATLG),DSN=SYS1.USERMODS,
//             UNIT=3350,VOL=SER=WORK01,
//             SPACE=(TRK,(240,,25),RLSE),
//             DCB=(DSORG=PO,RECFM=FB,LRECL=80,BLKSIZE=9440)
//*
//*********************************************************************
//* INSTALL USERMODS #DYP001, #DYP002, #DYP003, #DYP004, #DYP005,     *
//* AND #DYPDMY DYNAMIC PROCLIB                                       *
//********************************************************************1
//*
//UMOD001  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(#DYPDMY)
//         DD  DISP=SHR,DSN=SYS1.USERMODS(#DYP001)
//         DD  DISP=SHR,DSN=SYS1.USERMODS(#DYP002)
//         DD  DISP=SHR,DSN=SYS1.USERMODS(#DYP003)
//         DD  DISP=SHR,DSN=SYS1.USERMODS(#DYP004)
//         DD  DISP=SHR,DSN=SYS1.USERMODS(#DYP005)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(#DYP001 #DYP002 #DYP003 #DYP004 #DYP005 #DYPDMY)
         .
  APPLY
        SELECT(#DYP001,#DYP002,UZ45794)
        DIS(WRITE)
        .
  APPLY
        SELECT(#DYPDMY)
        DIS(WRITE)
        .
  RESTORE
        SELECT(#DYPDMY)
        DIS(WRITE)
        .
  APPLY
        SELECT(#DYP003 #DYP004 #DYP005)
        DIS(WRITE)
        .
  ACCEPT
         SELECT(#DYP001 #DYP002 #DYP003 #DYP004 #DYP005 UZ45794)
         USERMODS
         DIS(WRITE)
         .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD AY12275 - TCTRSZ INCORRECTLY REFLECTS SIZE OF     *
//* PRIVATE AREA, RATHER THAN REGION SIZE REQUESTED                   *
//********************************************************************2
//*
//UMOD002  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(AY12275)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(AY12275)
         .
  APPLY
        SELECT(AY12275)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD JLM0001 - IEFACTRT EXIT TO PROVIDE JOB/STEP       *
//* ACCOUNTING INFORMATION                                            *
//********************************************************************3
//*
//SMPAS003 EXEC SMPASM,M=IEFACTRT
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF003 EXEC MODIFY,MOD=IEFACTRT
//SYSUT1A  DD  *
    IDENTIFY IEFACTRT('JLM0001')
//UMOD003  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(JLM0001)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(JLM0001)
         .
  APPLY
        SELECT(JLM0001)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD JLM0002 - IEFU29 EXIT TO PROVIDE JOB/STEP         *
//* SMF DATASETS WHEN ACTIVE ONE FILLS /AND/                          *
//* INSTALL PROCEDURE, CONTROL CARDS, AND DEFINE GENERATION DATA      *
//* GROUP USED TO MANAGE SMF DATASETS.                                *
//********************************************************************4
//*
//SMPAS004 EXEC SMPASM,M=IEFU29
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF004 EXEC MODIFY,MOD=IEFU29
//SYSUT1A  DD  *
    IDENTIFY IEFU29('JLM0002')
//UMOD004  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(JLM0002)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(JLM0002)
         .
  APPLY
        SELECT(JLM0002)
        DIS(WRITE)
        .
/*
//UPDTE004 EXEC PGM=IEBUPDTE,PARM=NEW
//*
//* ***************************************************************** *
//* CREATE SMF DUMP/CLEAR PROCEDURE IN SYS1.PROCLIB                   *
//* NOTE: MODEL DSCB AND GDG DEFINITION WILL BE SET UP IN JOB MVS01   *
//* ***************************************************************** *
//*
//SYSUT2   DD  DSN=SYS1.PROCLIB,DISP=MOD
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  DATA,DLM='><'
./ ADD LIST=ALL,NAME=SMFDUMP
./ NUMBER NEW1=10,INCR=10
//*-------------------------------------------------------------------*
//*                 SMF DATASET DUMP/CLEAR PROCEDURE                  *
//*-------------------------------------------------------------------*
//SMFDUMP   PROC CLASS=X,ID=
//DUMP      EXEC PGM=IFASMFDP,REGION=4096K
//SYSPRINT  DD  SYSOUT=&CLASS
//DUMPIN    DD  DSN=SYS1.MAN&ID,DISP=SHR
//DUMPOUT   DD  DSN=SYSO.SMF.DATA(+1),DISP=(NEW,CATLG),
//             UNIT=SYSDA,VOL=SER=MVS000,SPACE=(CYL,(5,1),RLSE)
//SYSIN     DD  DSN=SYS2.CONTROL(SMFDUMP),DISP=SHR
//*  INDD(DUMPIN,OPTIONS(DUMP))
//*-------------------------------------------------------------------*
//CLEAR     EXEC PGM=IFASMFDP,REGION=4096K,COND=(0,NE,DUMP)
//SYSPRINT  DD  SYSOUT=&CLASS
//DUMPIN    DD  DSN=SYS1.MAN&ID,DISP=SHR
//DUMPOUT   DD  DUMMY
//SYSIN     DD  DSN=SYS2.CONTROL(SMFCLEAR),DISP=SHR
//*  INDD(DUMPIN,OPTIONS(CLEAR))
//*-------------------------------------------------------------------*
./ ENDUP
><
//UPDTE004 EXEC PGM=IEBUPDTE,PARM=NEW
//*
//* ***************************************************************** *
//* CREATE SMF DUMP AND CLEAR CONTROL CARDS IN SYS2.CONTROL           *
//* ***************************************************************** *
//*
//SYSUT2   DD  DSN=SYS2.CONTROL,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
./ ADD    LIST=ALL,NAME=SMFDUMP
./ NUMBER NEW1=10,INCR=10
     INDD(DUMPIN,OPTIONS(DUMP))
./ ADD    LIST=ALL,NAME=SMFCLEAR
./ NUMBER NEW1=10,INCR=10
     INDD(DUMPIN,OPTIONS(CLEAR))
./ ENDUP
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD JLM0003 - REPLACE TSO COMMAND AUTHORIZATION TABLE *
//* (IKJEFTE2)                                                        *
//********************************************************************5
//*
//SMPAS005 EXEC SMPASML,M=IKJEFTE2
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF005 EXEC MODIFY,MOD=IKJEFTE2
//SYSUT1A  DD  *
    IDENTIFY IKJEFTE2('JLM0003')
//UMOD005  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(JLM0003)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(JLM0003)
         .
  APPLY
        SELECT(JLM0003)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD JLM0004 - REPLACE TSO COMMAND AUTHORIZATION TABLE *
//* (IKJEFTE8)                                                        *
//********************************************************************6
//*
//SMPAS006 EXEC SMPASML,M=IKJEFTE8
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF006 EXEC MODIFY,MOD=IKJEFTE8
//SYSUT1A  DD  *
    IDENTIFY IKJEFTE8('JLM0004')
//UMOD006  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(JLM0004)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(JLM0004)
         .
  APPLY
        SELECT(JLM0004)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD JLM0005 - REPLACE TSO DATE-TIME SUBROUTINE TO USE *
//* CENTURY FLAG FOR CORRECT YEAR RETURN (IKJEFLPA/IKJEFLPB)          *
//********************************************************************7
//*
//SMPAS007 EXEC SMPASML,M=IKJEFLPA
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF007 EXEC MODIFY,MOD=IKJEFLPA
//SYSUT1A  DD  *
    IDENTIFY IKJEFLPA('JLM0005')
//UMOD007  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(JLM0005)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(JLM0005)
         .
  APPLY
        SELECT(JLM0005)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD TNIP800 ADD SUPPORT FOR USER-DEFINED SYSTEM       *
//* PARAMETER PRISUB=.                                                *
//********************************************************************8
//*
//UMOD008  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(TNIP800)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(TNIP800)
         .
  APPLY
        SELECT(TNIP800)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD MS00100 ALLOW LIBRARIES NOT CATALOGUED IN MASTER  *
//* CATALOG IN LNKLST                                                 *
//********************************************************************9
//*
//UMOD009  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(MS00100)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(MS00100)
         .
  APPLY
        SELECT(MS00100)
        DIS(WRITE)
        COMPRESS(ALL)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//USERMODS JOB (SYSGEN),'USERMODS',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             REGION=4096K
/*JOBPARM LINES=100
//JOBCAT   DD  DSN=SYS1.VSAM.MASTER.CATALOG,DISP=SHR
//*
//MODIFY   PROC MOD=
//IEBGENER EXEC PGM=IEBGENER
//SYSPRINT DD  DUMMY
//SYSIN    DD  DUMMY
//SYSUT1   DD  DSN=&&OBJMOD,DISP=(OLD,DELETE)
//         DD  DDNAME=SYSUT1A
//SYSUT2   DD  DISP=MOD,DSN=SYS1.UMODOBJ(&MOD.)
//         PEND
//*
//*********************************************************************
//* INSTALL USERMOD M096220 - FIX HARD WAIT DURING IPL IF MASTER      *
//* CATALOG IS LOCATED ON 3375/3380/3390                              *
//********************************************************************1
//*
//UMOD010  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(M096220)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(M096220)
         .
  APPLY
        SELECT(M096220 UZ72608)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD RP00001/RP00002  ADD 3375/3380/3390 DASD          *
//* SUPPORT INTO AMDPRDMP (DUMP DATASET CREATION)                     *
//********************************************************************2
//*
//SMPAS011 EXEC SMPASM,M=IEAVTSDH
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF011 EXEC MODIFY,MOD=IEAVTSDH
//SYSUT1A  DD  *
    IDENTIFY IEAVTSDH('RP00002')
//UMOD011  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(RP00001)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(RP00001 RP00002)
         .
  APPLY
        SELECT(RP00001 RP00002)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD RP00003  ADD DEVTYPE SVC TO RETURN THE ACTUAL     *
//* NUMBER OF CYLINDERS ON DASD DEVICE (3375/3380/3390 SUPPORT)       *
//********************************************************************3
//*
//SMPAS12A EXEC SMPASM,M=IGC0002D
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF12A EXEC MODIFY,MOD=IGC0002D
//SYSUT1A  DD  *
    IDENTIFY IGC0002D('RP00003')
/*
//SMPAS12B EXEC SMPASM,M=IGCT002D
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF12B EXEC MODIFY,MOD=IGCT002D
//SYSUT1A  DD  *
    IDENTIFY IGCT002D('RP00003')
//UMOD012  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(RP00003)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(RP00003)
         .
  APPLY
        SELECT(RP00003,UZ73568)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD SLB0001 (SOURCE: SHELBY BEACH) VALIDATES JOBNAME  *
//* FOR TSO STATUS, OUTPUT, AND CANCEL COMMANDS                       *
//********************************************************************4
//*
//SMPAS013 EXEC SMPASM,M=IKJEFF53
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF013 EXEC MODIFY,MOD=IKJEFF53
//SYSUT1A  DD  *
    IDENTIFY IKJEFF53('SLB0001')
//UMOD013  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(SLB0001)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(SLB0001)
         .
  APPLY
        SELECT(SLB0001)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD SLB0002 (SOURCE: SHELBY BEACH) ALLOWS USE OF      *
//* 'M' AS THE MEGABYTE INDICATOR FOR REGION IN JCL                   *
//********************************************************************5
//*
//UMOD014  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(SLB0002)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(SLB0002)
         .
  APPLY
        SELECT(SLB0002)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD SYZM001 (SOURCE: BRIAN WESTERMAN) SUPPRESS CN(00) *
//* BEING APPENDED TO SEND OPERATOR COMMAND                           *
//********************************************************************6
//*
//UMOD015  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(SYZM001)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(SYZM001)
         .
  APPLY
        SELECT(SYZM001)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD TIST801 BYPASS READING VTAMOBJ AND ALWAYS FETCH   *
//* RESOURCE DEFINITIONS FRO VTAMLST                                  *
//********************************************************************7
//*
//UMOD016  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(TIST801)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(TIST801)
         .
  APPLY
        SELECT(TIST801)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD TJES801 SET SSCTSSID AND SSIBSSID TO X'02' FOR    *
//* JES2                                                              *
//********************************************************************8
//*
//UMOD017  EXEC SMPAPP,WORK=SYSALLDA
//SYSUT1   DD  SPACE=(1700,(3000,100))
//SYSUT2   DD  SPACE=(1700,(3000,100))
//SYSUT3   DD  SPACE=(1700,(3000,100))
//SMPWRK3  DD  SPACE=(CYL,(30,10,84))
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(TJES801)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(TJES801)
         .
  APPLY
        SELECT(TJES801)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD TMVS804 DELETE AUTOSTART FOR PRIMARY SUBSYSTEM    *
//* SCHEDULER JCL                                                     *
//********************************************************************9
//*
//UMOD018  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(TMVS804)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(TMVS804)
         .
  APPLY
        SELECT(TMVS804)
        DIS(WRITE)
        COMPRESS(ALL)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMODS TMVS816/TMVS817 4-DIGIT YEAR SUPPORT FOR CONSOLE *
//********************************************************************1
//*
//UMOD019  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(TMVS816)
//IEE0603D DD  DISP=SHR,DSN=SYS1.UMODSRC(IEE0603D)
//IEAVRTOD DD  DISP=SHR,DSN=SYS1.UMODSRC(IEAVRTOD)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(TMVS816 TMVS817)
         .
  APPLY
        SELECT(TMVS816 TMVS817)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//USERMODS JOB (SYSGEN),'USERMODS',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             REGION=4096K
/*JOBPARM LINES=100
//JOBCAT   DD  DSN=SYS1.VSAM.MASTER.CATALOG,DISP=SHR
//*
//MODIFY   PROC MOD=
//IEBGENER EXEC PGM=IEBGENER
//SYSPRINT DD  DUMMY
//SYSIN    DD  DUMMY
//SYSUT1   DD  DSN=&&OBJMOD,DISP=(OLD,DELETE)
//         DD  DDNAME=SYSUT1A
//SYSUT2   DD  DISP=MOD,DSN=SYS1.UMODOBJ(&MOD.)
//         PEND
//*
//*********************************************************************
//* INSTALL USERMOD TTS0801 ELIMINATE MSG IKT012D AFTER P TSO         *
//********************************************************************2
//*
//UMOD020  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(TTSO801)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(TTSO801)
         .
  APPLY
        SELECT(TTSO801)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD VS49603 FIX EXCESSIVE DISABLED SPIN LOOP          *
//* CONDITIONS                                                        *
//********************************************************************3
//*
//UMOD021  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(VS49603)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(VS49603)
         .
  APPLY
        SELECT(VS49603)
        DIS(WRITE)
        .
/*
//*
//*********************************************************************
//* INSTALL USERMOD WM00017 ADDS 2 JES2 CONSOLE COMMANDS: $U $DP      *
//********************************************************************4
//*
//UMOD022  EXEC SMPAPP,WORK=SYSALLDA
//HMASMP.SYSUT1 DD UNIT=&WORK,SPACE=(1700,(1000,200))
//HMASMP.SYSUT2 DD UNIT=&WORK,SPACE=(1700,(1000,200))
//HMASMP.SYSUT3 DD UNIT=&WORK,SPACE=(1700,(1000,200))
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(WM00017)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(WM00017)
         .
  APPLY
        SELECT(WM00017)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60001 WTO EXIT TO AUTOMATICALLY START TSO       *
//* AFTER VTAM INITIALIZATION                                         *
//********************************************************************5
//*
//UMOD023  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60001)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60001)
         .
  APPLY
        SELECT(ZP60001)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60002 ALLOW TSO TEST TO CONTINUE PAST INVALID   *
//* OPCODE IS ENCOUNTERED                                             *
//********************************************************************6
//*
//UMOD024  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60002)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60002)
         .
  APPLY
        SELECT(ZP60002)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60003 ALLOW XF ASSEMBLER TO ACCEPT BLANK LINES  *
//********************************************************************7
//*
//UMOD025  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60003)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60003)
         .
  APPLY
        SELECT(ZP60003)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60004 HIGHLIGHT ACTION MESSAGES ON CONSOLE      *
//********************************************************************8
//*
//UMOD026  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60004)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60004)
         .
  APPLY
        SELECT(ZP60004)
        DIS(WRITE)
        COMPRESS(ALL)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60005 ALWAYS MAINTAIN CHANNEL/DEVICE SIO COUNTS *
//********************************************************************1
//*
//UMOD027  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60005)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60005)
         .
  APPLY
        SELECT(ZP60005)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//USERMODS JOB (SYSGEN),'USERMODS',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             REGION=4096K
/*JOBPARM LINES=100
//JOBCAT   DD  DSN=SYS1.VSAM.MASTER.CATALOG,DISP=SHR
//*
//MODIFY   PROC MOD=
//IEBGENER EXEC PGM=IEBGENER
//SYSPRINT DD  DUMMY
//SYSIN    DD  DUMMY
//SYSUT1   DD  DSN=&&OBJMOD,DISP=(OLD,DELETE)
//         DD  DDNAME=SYSUT1A
//SYSUT2   DD  DISP=MOD,DSN=SYS1.UMODOBJ(&MOD.)
//         PEND
//*
//*********************************************************************
//* INSTALL USERMOD ZP60006 SHOW EXCP COUNT ON DATA SET DISPOSITION   *
//* MESSAGES                                                          *
//********************************************************************2
//*
//UMOD028  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60006)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60006)
         .
  APPLY
        SELECT(ZP60006)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60007 ALLOW GTF TRACING OF 3270 DATA STREAMS    *
//********************************************************************3
//*
//SMPAS029 EXEC SMPASM,M=IKTCAS54
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF029 EXEC MODIFY,MOD=IKTCAS54
//SYSUT1A  DD  *
    IDENTIFY IKTCAS54('ZP60007')
//UMOD029  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60007)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60007)
         .
  APPLY
        SELECT(ZP60007)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60008 ADD EWA AND WSF SUPPORT FOR LOCAL NON-SNA *
//* 3270 TO VTAM                                                      *
//********************************************************************4
//*
//SMPAS030 EXEC SMPASM,M=ISTZBFBA
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF030 EXEC MODIFY,MOD=ISTZBFBA
//SYSUT1A  DD  *
    IDENTIFY ISTZBFBA('ZP60008')
//UMOD030  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60008)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60008)
         .
  APPLY
        SELECT(ZP60008)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60009 ADD NOEDIT SUPPORT FOR TPUT AND TPG TO    *
//* TSO/VTAM                                                          *
//********************************************************************5
//*
//SMPAS31A EXEC SMPASM,M=IKTVTGET
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF31A EXEC MODIFY,MOD=IKTVTGET
//SYSUT1A  DD  *
    IDENTIFY IKTVTGET('ZP60009')
//SMPAS31B EXEC SMPASM,M=IKTXLOG
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF31B EXEC MODIFY,MOD=IKTXLOG
//SYSUT1A  DD  *
    IDENTIFY IKTXLOG('ZP60009')
//SMPAS31C EXEC SMPASM,M=IKT0009D
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF31C EXEC MODIFY,MOD=IKT0009D
//SYSUT1A  DD  *
    IDENTIFY IKT0009D('ZP60009')
//SMPAS31D EXEC SMPASM,M=IKT0940A
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF31D EXEC MODIFY,MOD=IKT0940A
//SYSUT1A  DD  *
    IDENTIFY IKT0940A('ZP60009')
//SMPAS31E EXEC SMPASM,M=IKT09412
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF31E EXEC MODIFY,MOD=IKT09412
//SYSUT1A  DD  *
    IDENTIFY IKT09412('ZP60009')
//SMPAS31F EXEC SMPASM,M=IKT09413
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF31F EXEC MODIFY,MOD=IKT09413
//SYSUT1A  DD  *
    IDENTIFY IKT09413('ZP60009')
//SMPAS31G EXEC SMPASM,M=IKT3270I
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF31G EXEC MODIFY,MOD=IKT3270I
//SYSUT1A  DD  *
    IDENTIFY IKT3270I('ZP60009')
//SMPAS31H EXEC SMPASM,M=IKT3270O
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF31H EXEC MODIFY,MOD=IKT3270O
//SYSUT1A  DD  *
    IDENTIFY IKT3270O('ZP60009')
//UMOD031  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60009)
//IKTVTGET DD  DISP=SHR,DSN=SYS1.UMODOBJ(IKTVTGET)
//IKTXLOG  DD  DISP=SHR,DSN=SYS1.UMODOBJ(IKTXLOG)
//IKT0009D DD  DISP=SHR,DSN=SYS1.UMODOBJ(IKT0009D)
//IKT0940A DD  DISP=SHR,DSN=SYS1.UMODOBJ(IKT0940A)
//IKT09412 DD  DISP=SHR,DSN=SYS1.UMODOBJ(IKT09412)
//IKT09413 DD  DISP=SHR,DSN=SYS1.UMODOBJ(IKT09413)
//IKT3270I DD  DISP=SHR,DSN=SYS1.UMODOBJ(IKT3270I)
//IKT3270O DD  DISP=SHR,DSN=SYS1.UMODOBJ(IKT3270O)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60009)
         .
  APPLY
        SELECT(ZP60009)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60011 CAPTURE CHANNEL PROGRAM CCWS IN GTF SIO   *
//* TRACE RECORD                                                      *
//********************************************************************6
//*
//SMPAS32A EXEC SMPASM,M=AHLTSIO
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF32A EXEC MODIFY,MOD=AHLTSIO
//SYSUT1A  DD  *
    IDENTIFY AHLTSIO('ZP60011')
//SMPAS32B EXEC SMPASM,M=AMDSYS00
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF32B EXEC MODIFY,MOD=AMDSYS00
//SYSUT1A  DD  *
    IDENTIFY AMDSYS00('ZP60011')
//UMOD032  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60011)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60011)
         .
  APPLY
        SELECT(ZP60011)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60012 REPORT INTERRUPT CODE OF ABEND IN A TSO   *
//* SESSION                                                           *
//********************************************************************7
//*
//UMOD033  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60012)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60012)
         .
  APPLY
        SELECT(ZP60012)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60013 MAINTAIN AN SVC EVENT COUNT FOR EACH SVC  *
//* NUMBER                                                            *
//********************************************************************8
//*
//SMPAS034 EXEC SMPASM,M=IEAVESVC
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF034 EXEC MODIFY,MOD=IEAVESVC
//SYSUT1A  DD  *
    IDENTIFY IEAVESVC('ZP60013')
//UMOD032  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60013)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60013)
         .
  APPLY
        SELECT(ZP60013)
        DIS(WRITE)
        COMPRESS(ALL)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60014 ADD CLIST CONTROL VARIABLE AND BUILT-IN   *
//* FUNCTION EXTENSIONS                                               *
//********************************************************************1
//*
//SMPAS35A EXEC SMPASM,M=IKJCT431
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF35A EXEC MODIFY,MOD=IKJCT431
//SYSUT1A  DD  *
    IDENTIFY IKJCT431('ZP60014')
//SMPAS35B EXEC SMPASM,M=IKJCT433
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF35B EXEC MODIFY,MOD=IKJCT433
//SYSUT1A  DD  *
    IDENTIFY IKJCT433('ZP60014')
//SMPAS35C EXEC SMPASM,M=IKJEFT56
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF35C EXEC MODIFY,MOD=IKJEFT56
//SYSUT1A  DD  *
    IDENTIFY IKJEFT56('ZP60014')
//UMOD035  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60014)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60014)
         .
  APPLY
        SELECT(ZP60014)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//USERMODS JOB (SYSGEN),'USERMODS',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             REGION=4096K
/*JOBPARM LINES=100
//JOBCAT   DD  DSN=SYS1.VSAM.MASTER.CATALOG,DISP=SHR
//*
//MODIFY   PROC MOD=
//IEBGENER EXEC PGM=IEBGENER
//SYSPRINT DD  DUMMY
//SYSIN    DD  DUMMY
//SYSUT1   DD  DSN=&&OBJMOD,DISP=(OLD,DELETE)
//         DD  DDNAME=SYSUT1A
//SYSUT2   DD  DISP=MOD,DSN=SYS1.UMODOBJ(&MOD.)
//         PEND
//*
//*********************************************************************
//* INSTALL USERMOD ZP60015 EXTEND THE JOB SEARCH BY JES2 FOR TSO     *
//* STATUS WITHOUT OPERANDS                                           *
//********************************************************************2
//*
//UMOD036  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60015)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60015)
         .
  APPLY
        SELECT(ZP60015)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60016 REPORT EXTENDED RESULTS FROM JES2 TSO     *
//* STATUS DEFAULT SEARCH                                             *
//********************************************************************3
//*
//UMOD037  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60016)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60016)
         .
  APPLY
        SELECT(ZP60016)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60017 MOVE THE MASTER TRACE TABLE TO CSA        *
//********************************************************************4
//*
//UMOD038  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60017)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60017)
         .
  APPLY
        SELECT(ZP60017)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60018 REPORT MODULE NAME/ENTRY POINT IF PSW     *
//* ADDRESS IN PLPA                                                   *
//********************************************************************5
//*
//SMPAS039 EXEC SMPASM,M=IEAVAD0C
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF039 EXEC MODIFY,MOD=IEAVAD0C
//SYSUT1A  DD  *
    IDENTIFY IEAVAD0C('ZP60018')
//UMOD039  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60018)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60018)
         .
  APPLY
        SELECT(ZP60018)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60019 RECORD CPU TIME USED BY JOBS WITH         *
//* TIME=1440 IN JCL                                                  *
//********************************************************************6
//*
//UMOD040  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60019)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60019)
         .
  APPLY
        SELECT(ZP60019)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60020 REMOVE BLKSIZE LIMIT OF 3200 FROM LINKAGE *
//* EDITOR                                                            *
//********************************************************************7
//*
//UMOD041  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60020)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60020)
         .
  APPLY
        SELECT(ZP60020)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60021 DISPLAY KEYBOARD CHARACTERS IN A PRINTED  *
//* DUMP                                                              *
//********************************************************************8
//*
//UMOD042  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60021)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60021)
         .
  APPLY
        SELECT(ZP60021)
        DIS(WRITE)
        COMPRESS(ALL)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60022 ALLOW FORMAT 1 STAX PARAMETER LIST TO     *
//* FUNCTION CORRECTLY                                                *
//********************************************************************1
//*
//UMOD043  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60022)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60022)
         .
  APPLY
        SELECT(ZP60022)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//USERMODS JOB (SYSGEN),'USERMODS',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             REGION=4096K
/*JOBPARM LINES=100
//JOBCAT   DD  DSN=SYS1.VSAM.MASTER.CATALOG,DISP=SHR
//*
//MODIFY   PROC MOD=
//IEBGENER EXEC PGM=IEBGENER
//SYSPRINT DD  DUMMY
//SYSIN    DD  DUMMY
//SYSUT1   DD  DSN=&&OBJMOD,DISP=(OLD,DELETE)
//         DD  DDNAME=SYSUT1A
//SYSUT2   DD  DISP=MOD,DSN=SYS1.UMODOBJ(&MOD.)
//         PEND
//*
//*********************************************************************
//* INSTALL USERMOD ZP60024 EXPAND THE NUMBER OF ESD ENTRIES ALLOWED  *
//* IN XF ASSEMBLER                                                   *
//********************************************************************2
//*
//UMOD044  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60024)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60024)
         .
  APPLY
        SELECT(ZP60024)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60025 ALLOWS XF ASSEMBLER TO PROCESS BAS AND    *
//* BASR INSTRUCTIONS                                                 *
//********************************************************************3
//*
//UMOD045  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60025)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60025)
         .
  APPLY
        SELECT(ZP60025)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60026 ADD REUSE OPERAND TO TSO ALLOCATE COMMAND *
//********************************************************************4
//*
//SMPAS46A EXEC SMPASM,M=IKJEFD30
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF46A EXEC MODIFY,MOD=IKJEFD30
//SYSUT1A  DD  *
    IDENTIFY IKJEFD30('ZP60026')
//SMPAS46B EXEC SMPASM,M=IKJEFD31
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF46B EXEC MODIFY,MOD=IKJEFD31
//SYSUT1A  DD  *
    IDENTIFY IKJEFD31('ZP60026')
//SMPAS46C EXEC SMPASM,M=IKJEFD32
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF46C EXEC MODIFY,MOD=IKJEFD32
//SYSUT1A  DD  *
    IDENTIFY IKJEFD32('ZP60026')
//SMPAS46D EXEC SMPASM,M=IKJEFD33
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF46D EXEC MODIFY,MOD=IKJEFD33
//SYSUT1A  DD  *
    IDENTIFY IKJEFD33('ZP60026')
//SMPAS46E EXEC SMPASM,M=IKJEFD34
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF46E EXEC MODIFY,MOD=IKJEFD34
//SYSUT1A  DD  *
    IDENTIFY IKJEFD34('ZP60026')
//SMPAS46F EXEC SMPASM,M=IKJEFD35
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF46F EXEC MODIFY,MOD=IKJEFD35
//SYSUT1A  DD  *
    IDENTIFY IKJEFD35('ZP60026')
//SMPAS46G EXEC SMPASM,M=IKJEFD36
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF46G EXEC MODIFY,MOD=IKJEFD36
//SYSUT1A  DD  *
    IDENTIFY IKJEFD36('ZP60026')
//SMPAS46H EXEC SMPASM,M=IKJEFD37
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF46H EXEC MODIFY,MOD=IKJEFD37
//SYSUT1A  DD  *
    IDENTIFY IKJEFD37('ZP60026')
//UMOD046  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60026)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60026)
         .
  APPLY
        SELECT(ZP60026)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60027 ADD TIMESTAMP TO LINKAGE EDITOR           *
//* IDENTIFICATION RECORD                                             *
//********************************************************************5
//*
//UMOD047  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60027)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60027)
         .
  APPLY
        SELECT(ZP60027)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60028 HANDLES UNPRINTABLE CHARACTERS IN DUMP    *
//********************************************************************6
//*
//SMPAS048 EXEC SMPASM,M=IEAVAD07
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF048 EXEC MODIFY,MOD=IEAVAD07
//SYSUT1A  DD  *
    IDENTIFY IEAVAD07('ZP60028')
//UMOD048  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60028)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60028)
         .
  APPLY
        SELECT(ZP60028)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60029 CHANGE EBCDIC <=> ASCII TRANSLATE TABLES  *
//********************************************************************7
//*
//UMOD049  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60029)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60029)
         .
  APPLY
        SELECT(ZP60029)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60030 FIX MF/1 CHANNEL MEASUREMENT              *
//********************************************************************8
//*
//SMPAS50A EXEC SMPASM,M=IRBMFECH
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF50A EXEC MODIFY,MOD=IRBMFECH
//SYSUT1A  DD  *
    IDENTIFY IRBMFECH('ZP60030')
//SMPAS50B EXEC SMPASM,M=IRBMFIHA
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF50B EXEC MODIFY,MOD=IRBMFIHA
//SYSUT1A  DD  *
    IDENTIFY IRBMFIHA('ZP60030')
//UMOD050  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60030)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60030)
         .
  APPLY
        SELECT(ZP60030)
        DIS(WRITE)
        COMPRESS(ALL)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60031 ALLOW TYPE 6 AND TYPE 26 SMF RECORDS      *
//********************************************************************1
//*
//UMOD0451  EXEC SMPAPP,WORK=SYSALLDA
//SYSUT1   DD  SPACE=(CYL,(10,5))
//SYSUT2   DD  SPACE=(CYL,(10,5))
//SYSUT3   DD  SPACE=(CYL,(10,5))
//SMPWRK1  DD  SPACE=(CYL,(15,10,84))
//SMPWRK2  DD  SPACE=(CYL,(15,10,84))
//SMPWRK3  DD  SPACE=(CYL,(15,10,84))
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60031)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60031)
         .
  APPLY
        SELECT(ZP60031)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//USERMODS JOB (SYSGEN),'USERMODS',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             REGION=4096K
/*JOBPARM LINES=100
//JOBCAT   DD  DSN=SYS1.VSAM.MASTER.CATALOG,DISP=SHR
//*
//MODIFY   PROC MOD=
//IEBGENER EXEC PGM=IEBGENER
//SYSPRINT DD  DUMMY
//SYSIN    DD  DUMMY
//SYSUT1   DD  DSN=&&OBJMOD,DISP=(OLD,DELETE)
//         DD  DDNAME=SYSUT1A
//SYSUT2   DD  DISP=MOD,DSN=SYS1.UMODOBJ(&MOD.)
//         PEND
//*
//*********************************************************************
//* INSTALL USERMOD ZP60032 ALLOW THE GTTERM MACRO TO REPORT THE      *
//* TSO TERMINAL NAME                                                 *
//********************************************************************2
//*
//UMOD052  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60032)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60032)
         .
  APPLY
        SELECT(ZP60032)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60033 ADD SUPPORT FOR THE LOC= PARAMETER ON THE *
//* GETMAIN MACRO                                                     *
//********************************************************************3
//*
//UMOD053  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60033)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60033)
         .
  APPLY
        SELECT(ZP60033)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60034 RESOLVE &SYSUID, AND SUPPLY USER= AND     *
//* PASSWORD= ON JOB STATEMENT                                        *
//********************************************************************4
//*
//SMPAS054 EXEC SMPASM,M=IKJEFF10
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF054 EXEC MODIFY,MOD=IKJEFF10
//SYSUT1A  DD  *
    IDENTIFY IKJEFF10('ZP60034')
//UMOD054  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60034)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60034)
         .
  APPLY
        SELECT(ZP60034)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60035 SUPPORT FOR ANY MVS SUPPORTED DASD TYPE   *
//* FOR SYS1.LOGREC                                                   *
//********************************************************************5
//*
//SMPAS055 EXEC SMPASM,M=IFBSVC76
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF055 EXEC MODIFY,MOD=IFBSVC76
//SYSUT1A  DD  *
    IDENTIFY IGC0007F('ZP60035')
//UMOD055  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60035)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60035)
         .
  APPLY
        SELECT(ZP60035)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60036 SUPPORT FOR ANY MVS SUPPORTED DASD TYPE   *
//* FOR SYS1.LOGREC                                                   *
//********************************************************************6
//*
//SMPAS056 EXEC SMPASM,M=IFCDIP00
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF056 EXEC MODIFY,MOD=IFCDIP00
//SYSUT1A  DD  *
    IDENTIFY IFCDIP00('ZP60036')
//UMOD056  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60036)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60036)
         .
  APPLY
        SELECT(ZP60036)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60037 SUPPORT FOR ANY MVS SUPPORTED DASD TYPE   *
//* FOR SYS1.LOGREC                                                   *
//********************************************************************7
//*
//SMPAS057 EXEC SMPASM,M=IFCIOHND
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF057 EXEC MODIFY,MOD=IFCIOHND
//SYSUT1A  DD  *
    IDENTIFY IFCIOHND('ZP60037')
//UMOD057  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60037)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60037)
         .
  APPLY
        SELECT(ZP60037)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZP60038 ADDS CLIST VARIABLE PROCESSING            *
//* APPLICATION PROGRAM INTERFACE                                     *
//********************************************************************8
//*
//SMPAS058 EXEC SMPASM,M=IKJCT441
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF058 EXEC MODIFY,MOD=IKJCT441
//SYSUT1A  DD  *
    IDENTIFY IKJCT441('ZP60038')
//UMOD058  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60038)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60038)
         .
  APPLY
        SELECT(ZP60038)
        DIS(WRITE)
        COMPRESS(ALL)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMODS ZP60039/ZP60040 ADD TEXT= OPERAND SUPPORT TO     *
//* WTO AND WTOR MACROS                                               *
//********************************************************************1
//*
//IEBCO059 EXEC PGM=IEBCOPY,REGION=1024K
//SYSPRINT DD   SYSOUT=A
//LIBIN    DD  DISP=SHR,DSN=SYS1.UMODSRC
//LIBOUT   DD  DISP=SHR,DSN=SYS1.UMODMAC
//SYSUT3   DD  UNIT=SYSDA,SPACE=(80,(60,28)),DISP=(,DELETE)
//SYSIN    DD  *
  COPY INDD=((LIBIN,R)),OUTDD=LIBOUT
  SELECT MEMBER=(IEZWPL,WTO,WTOR)
/*
//SMPAS59A EXEC SMPASM,M=IEAVMWTO
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF59A EXEC MODIFY,MOD=IEAVMWTO
//SYSUT1A  DD  *
    IDENTIFY IEAVMWTO('ZP60039')
//SMPAS59B EXEC PGM=IFOX00,
//             REGION=4096K,
//             PARM='LIST,XREF(SHORT),DECK,NOOBJECT'
//STEPLIB  DD  DISP=SHR,DSN=SYS1.LINKLIB,UNIT=SYSDA,VOL=SER=MVSRES
//SYSPRINT DD  SYSOUT=*
//SYSTERM  DD  SYSOUT=*
//SYSPUNCH DD  UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//SYSLIB   DD  DISP=SHR,DSN=SYS1.MACLIB,DCB=BLKSIZE=32720
//         DD  DISP=SHR,DSN=SYS1.UMODMAC
//         DD  DISP=SHR,DSN=SYS1.AMODGEN
//         DD  DISP=SHR,DSN=SYS1.UMODSRC
//         DD  DISP=SHR,DSN=SYS1.HASPSRC
//         DD  DISP=SHR,DSN=SYS1.APVTMACS
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(2,1))
//SYSUT2   DD  UNIT=SYSDA,SPACE=(CYL,(2,1))
//SYSUT3   DD  UNIT=SYSDA,SPACE=(CYL,(2,1))
//SYSIN    DD  DISP=SHR,DSN=SYS1.UMODSRC(IEAVVWTO)
//MODIF59B EXEC MODIFY,MOD=IEAVVWTO
//SYSUT1A  DD  *
    IDENTIFY IEAVVWTO('ZP60039')
//SMPAS59C EXEC SMPASM,M=IGC0203E
//ASM.SYSPUNCH DD UNIT=SYSDA,DSN=&&OBJMOD,DISP=(,PASS),SPACE=(TRK,(60))
//MODIF59C EXEC MODIFY,MOD=IGC0203E
//SYSUT1A  DD  *
    IDENTIFY IGC0203E('ZP60040')
//UMOD059  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZP60039)
//WTO      DD  DSN=SYS1.UMODSRC(WTO),DISP=SHR
//WTOR     DD  DSN=SYS1.UMODSRC(WTOR),DISP=SHR
//IEZWPL   DD  DSN=SYS1.UMODSRC(IEZWPL),DISP=SHR
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZP60039 ZP60040)
         .
  APPLY
        SELECT(ZP60039 ZP60040)
        DIS(WRITE)
        .
/*
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* INSTALL USERMOD ZUM0015 PLACE CONSOLE IN ROLL DELETE MODE         *
//********************************************************************2
//*
//UMOD060  EXEC SMPAPP,WORK=SYSALLDA
//SMPPTFIN DD  DISP=SHR,DSN=SYS1.USERMODS(ZUM0015)
//SMPCNTL  DD  *
  RECEIVE
         SELECT(ZUM0015)
         .
  APPLY
        SELECT(ZUM0015)
        DIS(WRITE)
        .
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//*
//*********************************************************************
//* REMOVE PDS USED TO INSTALL USERMODS                               *
//********************************************************************4
//*
//IEFBR14  EXEC PGM=IEFBR14
//USERMODS DD  DISP=(OLD,DELETE),DSN=SYS1.USERMODS
//

