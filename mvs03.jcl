//MVS03    JOB (1),'SETUP TSO APPS',CLASS=S,MSGLEVEL=(1,1),
//             MSGCLASS=X
//*
//* ----------------------------------------------------------------- *
//* This job sets up TSO application programs: QUEUE, RPF (v197),     *
//* REVIEW (v51), DATE.                                               *
//* ----------------------------------------------------------------- *
//*
//STEP1    EXEC PGM=PDSLOAD
//* ----------------------------------------------------------------- *
//* Restore QUEUE.ASM source from tape.                               *
//* ----------------------------------------------------------------- *
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DISP=(,CATLG),DSN=PUB001.QUEUE.ASM,                      
//             UNIT=SYSDA,VOL=SER=PUB001,SPACE=(CYL,(10,5,20),RLSE),    
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=27920)                    
//OBJECT   DD  DISP=(,CATLG),DSN=PUB001.QUEUE.OBJ,
//             VOL=SER=PUB001,
//             UNIT=3390,SPACE=(CYL,(1,1,20)),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3120)                     
//SYSUT1   DD  UNIT=TAPE,DISP=(OLD,KEEP),DSN=QUEUE,
//             VOL=(PRIVATE,RETAIN,SER=TSOAPS),LABEL=(1,SL)
//*
//STEP2    EXEC PGM=IEBGENER
//* ----------------------------------------------------------------- *
//* Submit job from QUEUE.ASM(C) to assemble/link QUEUE.              *
//* ----------------------------------------------------------------- *
//SYSIN    DD  DUMMY
//SYSPRINT DD  DUMMY
//SYSUT1   DD  DISP=SHR,DSN=PUB001.QUEUE.ASM(C)
//SYSUT2   DD  SYSOUT=(A,INTRDR)
//*
//STEP3    EXEC RECV370
//* ----------------------------------------------------------------- *
//* Restore RPF v197 LOADLIB from tape.                               *
//* ----------------------------------------------------------------- *
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//XMITIN   DD  UNIT=TAPE,DISP=(OLD,KEEP),DSN=RPFLD,
//             VOL=(PRIVATE,RETAIN,SER=TSOAPS),LABEL=(2,SL)
//SYSUT2   DD  DSN=&&RPFLD,
//             VOL=SER=PUB000,UNIT=SYSDA,
//             SPACE=(TRK,(15,15,10),RLSE),
//             DISP=(,PASS)
//*
//STEP4    EXEC RECV370
//* ----------------------------------------------------------------- *
//* Restore RPF v197 HELP from tape.                                  *
//* ----------------------------------------------------------------- *
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//XMITIN   DD  UNIT=TAPE,DISP=(OLD,KEEP),DSN=RPFHE,
//             VOL=(PRIVATE,RETAIN,SER=TSOAPS),LABEL=(3,SL)
//SYSUT2   DD  DSN=&&RPFHE,           
//             VOL=SER=PUB000,UNIT=SYSDA,
//             SPACE=(TRK,(15,15,5),RLSE),
//             DISP=(,PASS)
//*
//STEP5    EXEC RECV370
//* ----------------------------------------------------------------- *
//* Restore RPF v197 JCL from tape.                                   *
//* ----------------------------------------------------------------- *
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//XMITIN   DD  UNIT=TAPE,DISP=(OLD,KEEP),DSN=RPFJC,
//             VOL=(PRIVATE,RETAIN,SER=TSOAPS),LABEL=(4,SL)
//SYSUT2   DD  DSN=&&RPFJC,         
//             VOL=SER=PUB000,UNIT=SYSDA,
//             SPACE=(TRK,(15,15,5),RLSE),
//             DISP=(,PASS)
//*
//STEP6    EXEC PGM=IDCAMS
//* ----------------------------------------------------------------- *
//* Set up RPF v197 control dataset.                                  *
//* ----------------------------------------------------------------- *
//REPROIN  DD  *
99999999    SEED RECORD FOR THE RPF Profile cluster
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  PARM GRAPHICS(CHAIN(SN))
  DEFINE ALIAS(NAME(RPF) RELATE(UCPUB000))
  SET LASTCC = 0
  SET MAXCC = 0
  DELETE RPF.PROFILE CLUSTER
  SET LASTCC = 0
  SET MAXCC = 0
  DEFINE CLUSTER ( NAME(RPF.PROFILE) -
                   VOL(PUB000) -
                   FREESPACE(20 10) -
                   RECORDSIZE(1750 1750) -
                   INDEXED -
                   IMBED -
                   UNIQUE  -
                   KEYS(8 0) -
                   CYLINDERS(1 1) -
                 ) -
            DATA ( NAME(RPF.PROFILE.DATA) -
                   SHR(3 3) -
                 ) -
           INDEX ( NAME(RPF.PROFILE.INDEX) -
                   SHR(3 3) -
                 )
  IF LASTCC = 0 THEN -
     REPRO INFILE(REPROIN) -
           OUTDATASET(RPF.PROFILE)
//*
//STEP7   EXEC PGM=IEBCOPY
//* ----------------------------------------------------------------- *
//* Copy RPF v197 load modules to SYS2.CMDLIB.                        *
//* ----------------------------------------------------------------- *
//LOAD     DD  DISP=(OLD,PASS),DSN=&&RPFLD
//CMDLIB   DD  DISP=SHR,DSN=SYS2.CMDLIB
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  COPY INDD=CMDLIB,OUTDD=CMDLIB
  COPY INDD=((LOAD,R)),OUTDD=CMDLIB
  COPY INDD=CMDLIB,OUTDD=CMDLIB
//*
//STEP8   EXEC PGM=IEBCOPY
//* ----------------------------------------------------------------- *
//* Copy RPF v197 help modules to SYS2.HELP.                          *
//* ----------------------------------------------------------------- *
//HELPIN   DD  DISP=(OLD,PASS),DSN=&&RPFHE
//HELPOUT  DD  DISP=SHR,DSN=SYS2.HELP
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  COPY INDD=((HELPIN,R)),OUTDD=HELPOUT
  S M=(RPF,RPFV,RPFED,RPFHELP1,RPFHELP2,RPFHELP3,RPFHELP4,RPFHELP5)
//*
//STEP9    EXEC RECV370
//* ----------------------------------------------------------------- *
//* Restore Review v51 load modules from tape.                        *
//* ----------------------------------------------------------------- *
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//XMITIN   DD  UNIT=TAPE,DISP=(OLD,KEEP),DSN=REVLD,
//             VOL=(PRIVATE,RETAIN,SER=TSOAPS),LABEL=(5,SL)
//SYSUT2   DD  DSN=&&REVLD,DISP=(,PASS),
//             UNIT=SYSDA,SPACE=(TRK,(60,15))
//*
//STEP10   EXEC PGM=IEBCOPY,REGION=1024K
//* ----------------------------------------------------------------- *
//* Copy Review v51 load modules to SYS2.CMDLIB                       *
//* ----------------------------------------------------------------- *
//SYSPRINT  DD SYSOUT=*
//LIBIN     DD DSN=&&REVLD,DISP=(OLD,PASS)
//LIBOUT    DD DSN=SYS2.CMDLIB,DISP=SHR
//SYSUT3    DD UNIT=SYSDA,SPACE=(80,(60,45)),DISP=(,DELETE)
//SYSIN     DD *
  COPY INDD=((LIBIN,R)),OUTDD=LIBOUT
//*
//STEP11   EXEC PGM=IKJEFT01,REGION=1024K,DYNAMNBR=50
//* ----------------------------------------------------------------- *
//* Add REVPROF DD to TSO Logon procedure                             *
//* ----------------------------------------------------------------- *
//SYSPRINT DD  SYSOUT=*
//SYSTSPRT DD  SYSOUT=*
//SYSTERM  DD  SYSOUT=*
//SYSTSIN  DD  *
EDIT 'SYS1.PROCLIB(IKJACCNT)' CNTL
LIST
TOP
F =//SYSPROC  DD =
INSERT //RPFPROF  DD  DISP=SHR,DSN=RPF.PROFILE
LIST
END SAVE
/*
//*
//STEP12   EXEC RECV370
//* ----------------------------------------------------------------- *
//* Restore Review v51 command lists from tape.                       *
//* ----------------------------------------------------------------- *
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//XMITIN   DD  UNIT=TAPE,DISP=(OLD,KEEP),DSN=REVCL,
//             VOL=(PRIVATE,RETAIN,SER=TSOAPS),LABEL=(6,SL)
//SYSUT2   DD  DSN=&&REVCL,DISP=(,PASS),
//             UNIT=SYSDA,SPACE=(TRK,(60,15))
//*
//STEP13   EXEC PGM=IEBCOPY,REGION=1024K
//* ----------------------------------------------------------------- *
//* Copy Review v51 command lists to SYS1.CMDPROC.                    *
//* ----------------------------------------------------------------- *
//SYSPRINT  DD SYSOUT=*
//LIBIN     DD DSN=&&REVCL,DISP=(OLD,PASS)
//LIBOUT    DD DSN=SYS1.CMDPROC,DISP=SHR
//SYSUT3    DD UNIT=SYSDA,SPACE=(80,(60,45)),DISP=(,DELETE)
//SYSIN     DD *
  COPY INDD=((LIBIN,R)),OUTDD=LIBOUT
//*
//STEP14   EXEC PGM=IKJEFT01,REGION=1024K,DYNAMNBR=50
//* ----------------------------------------------------------------- *
//* As installed, the REVINIT CLIST is lacking a VOLUME parameter     *
//* which, if present, will allocate the profile dataset on the same  *
//* DASD volume as the other user's datasets.  This step simply       *
//* modifies the REVINIT member of SYS1.CMDPROC to add a VOLUME       *
//* parameter when the profile dataset is initially created. This     *
//* change does not take affect until the TSO user logs on the first  *
//* time after this job is executed.                                  *
//* ----------------------------------------------------------------- *
//SYSPRINT DD  SYSOUT=*
//SYSTSPRT DD  SYSOUT=*
//SYSTERM  DD  SYSOUT=*
//SYSTSIN  DD  *
EDIT 'SYS1.CMDPROC(REVINIT)' CNTL NONUM
LIST
TOP
F =ALLOC F(ISPPROF) DA('&PROFDSN') NEW =
C * =CYL =+   =
INSERT       CYL VOLUME(PUB000)
LIST
END SAVE
/*
//*
//STEP15   EXEC RECV370
//* ----------------------------------------------------------------- *
//* Restore Review v51 help from tape.                                *
//* ----------------------------------------------------------------- *
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//XMITIN   DD  UNIT=TAPE,DISP=(OLD,KEEP),DSN=REVHE,
//             VOL=(PRIVATE,RETAIN,SER=TSOAPS),LABEL=(7,SL)
//SYSUT2   DD  DSN=&&REVHE,DISP=(,PASS),
//             UNIT=SYSDA,SPACE=(TRK,(60,15))
//*
//STEP16   EXEC PGM=IEBCOPY,REGION=1024K
//* ----------------------------------------------------------------- *
//* Copy Review v51 help to SYS2.HELP.                                *
//* ----------------------------------------------------------------- *
//SYSPRINT  DD SYSOUT=*
//LIBIN     DD DSN=&&REVHE,DISP=(OLD,PASS)
//LIBOUT    DD DSN=SYS2.HELP,DISP=SHR
//SYSUT3    DD UNIT=SYSDA,SPACE=(80,(60,45)),DISP=(,DELETE)
//SYSIN     DD *
  COPY INDD=((LIBIN,R)),OUTDD=LIBOUT
//*
//STEP17   EXEC ASMFCL,PARM.ASM='LIST,RENT,OBJ,NODECK',
//* ----------------------------------------------------------------- *
//* Assemble/link DATE command from source to SYS2.CMDLIB.            *
//* ----------------------------------------------------------------- *
//             PARM.LKED='LIST,RENT,XREF'
//ASM.SYSIN DD UNIT=TAPE,DISP=(OLD,KEEP),DSN=DATEAS,
//             VOL=(PRIVATE,RETAIN,SER=TSOAPS),LABEL=(8,SL)
//LKED.SYSLMOD DD DSN=SYS2.CMDLIB,DISP=SHR
//LKED.SYSLIB DD DSN=SYSC.LINKLIB,DISP=SHR
//LKED.SYSIN  DD *
  NAME DATE(R)
//*
//STEP18   EXEC PGM=IEBGENER,PARM=NEW
//* ----------------------------------------------------------------- *
//* Copy DATE help to SYS2.HELP.                                      *
//* ----------------------------------------------------------------- *
//SYSIN     DD DUMMY
//SYSPRINT  DD DUMMY
//SYSUT1    DD UNIT=TAPE,DISP=(OLD,KEEP),DSN=DATEHE,
//             VOL=(PRIVATE,RETAIN,SER=TSOAPS),LABEL=(9,SL)
//SYSUT2    DD DISP=SHR,DSN=SYS2.HELP(DATE)
//
