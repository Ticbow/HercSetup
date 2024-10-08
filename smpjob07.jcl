//SMPJOB07 JOB (SYSGEN),'ADD UTILITIES',                                        
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),COND=(0,NE)                    
//*                                                                             
//*********************************************************************         
//*                                                                             
//*         MVS 3.8 SYSGEN                                                      
//*                                                                             
//* This jobstream adds 4 necessary utility programs to the Starter             
//* System's SYS1.LINKLIB.                                                      
//*                                                                             
//* 1) ICKDSF is not present in the Starter System, but is required             
//*    to place the IPL records onto the volume which will hold the             
//*    target MVS 3.8j system.                                                  
//* 2) The version of IEBGENER in the Starter System has been observed          
//*    to ABEND with S0C4 for no determined reason.                             
//* 3) The version of XF assembler in the Starter System has been               
//*    observed to ABEND with S0C4 for no determined reason.                    
//* 4) The PDSLOAD utility, obtained from the CBT Tape, is necessary            
//*    to reload datasets from tape necessary to install User                   
//*    Modifications to the target MVS 3.8j system.                             
//*                                                                             
//* The jobstream utilizes SYSGEN macros installed during the building          
//* of the distribution libraries to build a jobstream to link edit             
//* the 3 system utilities into SYS1.LINKLIB on the Starter System              
//* (volume START1), which is then submitted through the Internal               
//* Reader.                                                                     
//*                                                                             
//* The source for PDSLOAD is included instream to assemble the                 
//* PDSLOAD utility into SYS1.LINKLIB on the Starter System.                    
//*                                                                             
//*   !!!  AN IPL IS REQUIRED AFTER THIS JOB COMPLETES  !!!                     
//*                                                                             
//*********************************************************************         
//*                                                                             
/*MESSAGE  ************************************************************         
/*MESSAGE  * AN IPL IS REQUIRED AFTER THIS JOB HAS COMPLETED!!!       *         
/*MESSAGE  ************************************************************         
//*                                                                             
//*********************************************************************         
//* Use SGIFO401 to generate link edit statements for XF assembler              
//* Use SGIEH402 to generate link edit statements for IEBGENER                  
//* Use SGIEH404 to generate link edit statements for ICKDSF                    
//*********************************************************************         
//*                                                                             
//ASM    EXEC  PGM=IEUASM,REGION=1024K,PARM='LIST,NOOBJECT,DECK'                
//SYSLIB   DD  DSN=SYS1.AGENLIB,DISP=SHR,                                       
//             UNIT=SYSDA,VOL=SER=SMP000                                        
//SYSUT1   DD  UNIT=SYSDA,SPACE=(1700,(1400,50))                                
//SYSUT2   DD  UNIT=SYSDA,SPACE=(1700,(1400,50))                                
//SYSUT3   DD  UNIT=SYSDA,SPACE=(1700,(1400,50))                                
//SYSPRINT DD  SYSOUT=*                                                         
//SYSPUNCH DD  DSN=&&LINKS,UNIT=SYSDA,DISP=(,PASS),                             
//             SPACE=(TRK,15),DCB=BLKSIZE=80                                    
//SYSIN    DD  *                                                                
         PRINT OFF                                                              
         SGIFO401                                                               
         SGIEH402                                                               
         SGIEH404                                                               
         END                                                                    
/*                                                                              
//IDCAMS EXEC  PGM=IDCAMS,REGION=1024K                                          
//JCL001   DD  DATA,DLM='><'                                                    
//SMPJOB07 JOB (SYSGEN),'LINK UTILITIES',                                       
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1)                                
//* ***************************************************************** *         
//* Re-link IFOX00 from the Distribution Library AOS03                *         
//* ***************************************************************** *         
//LINK   EXEC  LINKS,PARM=(NCAL,LIST,XREF),                                     
//             CLASS=A,OBJ=,UNIT=,SER=,N=' ',NAME=,P1=,MOD=,P2=                 
//SYSPUNCH DD  DUMMY,DSN=DUMMY                                                  
//SYSLMOD  DD  DSN=SYS1.LINKLIB,DISP=SHR                                        
//AOS03    DD  DISP=SHR,DSN=SYS1.AOS03                                          
//SYSLIN   DD  *                                                                
><                                                                              
//JCL002   DD  DATA,DLM='><'                                                    
/*                                                                              
//* ***************************************************************** *         
//* Re-link IEBGENER from the Distribution Library AOSU0              *         
//* ***************************************************************** *         
//LINK   EXEC  LINKS,PARM=(NCAL,LET,LIST,XREF),                                 
//             CLASS=A,OBJ=,UNIT=,SER=,N=' ',NAME=,P1=,MOD=,P2=                 
//SYSPUNCH DD  DUMMY,DSN=DUMMY                                                  
//SYSLMOD  DD  DSN=SYS1.LINKLIB,DISP=SHR                                        
//AOSU0    DD  DISP=SHR,DSN=SYS1.AOSU0                                          
//SYSLIN   DD  *                                                                
><                                                                              
//JCL003   DD  DATA,DLM='><'                                                    
/*                                                                              
//* ***************************************************************** *         
//* Re-link ICKDSF from the Distribution Library AOSU0                *         
//* ***************************************************************** *         
//LINK   EXEC  LINKS,PARM=(NCAL,LIST,XREF,LET,RENT,REFR),                       
//             CLASS=A,OBJ=,UNIT=,SER=,N=' ',NAME=,P1=,MOD=,P2=                 
//SYSPUNCH DD  DUMMY,DSN=DUMMY                                                  
//SYSLMOD  DD  DSN=SYS1.LINKLIB,DISP=SHR                                        
//AOSU0    DD  DISP=SHR,DSN=SYS1.AOSU0                                          
//SYSLIN   DD  *                                                                
><                                                                              
//JCL004   DD  DATA,DLM='><'                                                    
/*                                                                              
//*********************************************************************         
//* Copy the SVC required by ICKDSF to SVCLIB                                   
//*********************************************************************         
//*                                                                             
//COPY   EXEC  PGM=IEBCOPY,REGION=1024K                                         
//SYSPRINT DD  SYSOUT=A                                                         
//AOSU0    DD  DISP=SHR,DSN=SYS1.AOSU0                                          
//SVCLIB   DD  DSN=SYS1.SVCLIB,DISP=OLD                                         
//SYSUT3   DD  UNIT=SYSDA,SPACE=(80,(60,45)),DISP=(,DELETE)                     
//SYSIN    DD  *                                                                
  COPY INDD=AOSU0,OUTDD=SVCLIB                                                  
  SELECT MEMBER=(IGG019P2)                                                      
/*                                                                              
//*                                                                             
//*********************************************************************         
//* This step assembles PDSLOAD into SYS1.LINKLIB. The source for the           
//* utility is CBT (V502) File #093.                                            
//*********************************************************************         
//*                                                                             
//ASM EXEC PGM=IFOX00,PARM='OBJ,LIST,NOXREF',REGION=1024K                       
//STEPLIB  DD DISP=SHR,DSN=SYS1.LINKLIB,UNIT=3330,VOL=SER=START1                
//SYSLIB   DD DISP=SHR,DSN=SYS1.AMACLIB,UNIT=SYSDA,VOL=SER=SMP000               
//         DD DISP=SHR,DSN=SYS1.AMODGEN,UNIT=SYSDA,VOL=SER=SMP000               
//SYSUT1   DD UNIT=SYSSQ,SPACE=(1700,(600,100))                                 
//SYSUT2   DD UNIT=SYSSQ,SPACE=(1700,(300,50))                                  
//SYSUT3   DD UNIT=SYSSQ,SPACE=(1700,(300,50))                                  
//SYSPRINT DD SYSOUT=A,DCB=BLKSIZE=1089                                         
//SYSPUNCH DD DUMMY                                                             
//SYSGO    DD DSN=&&OBJSET,UNIT=SYSSQ,SPACE=(80,(200,50)),                      
//            DISP=(MOD,PASS)                                                   
//SYSIN    DD *                                                                 
PDSLOAD  TITLE 'P D S L O A D  **  LOAD IEBUPDTE INPUT TO A PDS'                
* ---------- Updated by Gerhard Postpischil ---- Jan 2012 ---------- *          
* Note that Greg Price and Gerhard Postpischil have the same initials.          
* ----------------------------------------------------------------.SBG.         
* Added version level.  Since there are so many levels before     .SBG.         
* here, I am starting with Version 10.0.                          .SBG.         
* ----------------------------------------------------------------.SBG.         
* Optional DDNAME of SYSUPLOG to ensure data integrity of files   .SBG.         
* which should have the UPDTE(><) characters in column 1, and     .SBG.         
* which should not be changed to ./ .  See below for details.     .SBG.         
* //SYSUPLOG is "an exception file", created by LISTPDS or OFFLOAD.SBG.         
* ----------------------------------------------------------------              
* Corrected program for 8-digit ISPF userids.                                   
*           (Sam Golob, Greg Price, and Bill Godfrey)                           
* Also forced extended ISPF stats when they were there before,                  
* even if the counts were not bigger than 65535.  Version 10.1                  
* ----------------------------------------------------------------              
*$DOC@*****************************************************************         
*                                                                     *         
*          PDSLOAD - LOAD SEQUENTIAL DATA SET INTO PDS MEMBERS        *         
*                                                                     *         
***********************************************************************         
*                                                                               
*         WRITTEN BY: BILL GODFREY, PLANNING RESEARCH CORPORATION.              
*         INSTALLATION: PRC COMPUTER CENTER INC, MCLEAN VA.                     
*         DATE WRITTEN: NOVEMBER 25 1980.                                       
*         DATE UPDATED: FEBRUARY 17, 2008                                       
*         ATTRIBUTES: RE-ENTRANT. (AMODE AND RMODE MUST BE 24.)                 
*                                                                               
*         THIS PROGRAM CONVERTS A SEQUENTIAL DATA SET OF PDS                    
*         MEMBERS IN 'IEBUPDTE' FORMAT TO A PARTITIONED DATA SET.               
*                                                                               
*         THE IEBUPDTE UTILITY PROGRAM CAN DO THE SAME THING,                   
*         BUT THIS PROGRAM HAS THE FOLLOWING ADDED CAPABILITIES:                
*         .  STORES SPF STATISTICS IN A MEMBER'S DIRECTORY ENTRY                
*            IF THEY ARE PRESENT ON THE './ ADD' STATEMENT,                     
*         .  CAN GENERATE SPF STATISTICS IF NONE ARE PRESENT,                   
*         .  CAN SELECT ONE MEMBER FROM INPUT FILE,                             
*         .  RESTORES MODIFIED IEBUPDTE STATEMENTS WITHIN A MEMBER              
*            (CHANGES '/.' BACK TO './').                                       
*         .  DOES NOT LIST THE DATA IN THE MEMBER,                              
*         .  PRINTS NUMBER OF RECORDS FOR EACH MEMBER WRITTEN.                  
*                                                                               
*         IF PARM='CTL(XX)' IS SPECIFIED, THEN ALL OCCURRENCES                  
*         OF THE 2 CHARACTERS IN PARENTHESES WILL BE USED TO LOOK               
*         FOR THE ADD AND ALIAS CARDS.   GERHARD POSTPISCHIL    GP06315         
*                                                                               
*         IF PARM='UPDTE(XX)' IS SPECIFIED, THEN ALL OCCURRENCES                
*         OF THE 2 CHARACTERS IN PARENTHESES WILL BE CHANGED TO                 
*         './' BEFORE BEING WRITTEN TO THE PDS, IF THEY OCCUR                   
*         IN COLUMNS 1-2 OF THE DATA.  THIS IS USED IN CONJUNCTION              
*         WITH ANOTHER PROGRAM THAT CREATES IEBUPDTE-FORMAT                     
*         DATA SETS FROM A PDS, AND IN SO DOING CHANGES ALL                     
*         OCCURRENCES OF './' IN COLUMNS 1-2 OF THE DATA WITHIN                 
*         THE MEMBERS TO ANOTHER CONSTANT, SO IEBUPDTE AND THIS                 
*         PROGRAM WILL NOT TREAT THE DATA RECORDS AS CONTROL CARDS.             
*         IEBUPDTE DOESN'T CHANGE THE DATA BACK. THIS PROGRAM DOES.             
*                                                                               
*         LOG OF CHANGES:                                                       
*          28MAY81 - SUPPORT NAME= AS SECOND OPERAND (FOLLOWING SSI).           
*          28MAY81 - SINGLE MEMBER MAY BE SPECIFIED IN PARM.                    
*                    PARM='S(ABC)' WILL SELECT MEMBER 'ABC' ONLY.               
*          28MAY81 - PARM=SPF WILL FORCE SPF STATS TO BE GENERATED.             
*                    IF SPF IS SPECIFIED IN PARM, IT MUST BE FIRST.             
*                    IF UPDTE(XX) IS SPECIFIED, IT MUST BE LAST.                
*----------------------------------------------------------------------         
*          ??JUL87 - THIS VERSION OF THE PDSLOAD PROGRAM HAS BEEN               
*                    MODIFIED WITH A GLOBAL VARIABLE SO THE LRECL OF            
*                    THE INPUT AND OUTPUT DATASETS CAN BE CHANGED               
*                    MERELY BY MODIFYING THE GLOBAL AND REASSEMBLING            
*                    THE PROGRAM.  AN EYECATCHER HAS BEEN ADDED SO              
*                    THAT YOU CAN SEE THE ASSEMBLED LRECL BY BROWSING           
*                    THE LOAD MODULE.  SEE LABEL "&LRECL".                      
*                    YOU NEED TO REASSEMBLE THE PROGRAM EVERY TIME YOU          
*                    WANT TO CHANGE THE LRECL THAT THE PROGRAM TAKES.           
*                    (ADMITTEDLY IT'S BETTER TO DO THIS WITH A PARM AT          
*                    EXECUTION TIME.)  BUT THIS WORKS.  (IT HAS NOT             
*                    BEEN TESTED WITH LRECL MUCH LESS THAN 80.)                 
*                                                                               
* S. GOLOB - NEWSWEEK - MOUNTAIN LAKES, N.J.                        NWK         
*----------------------------------------------------------------------         
*          01SEP92 - AVOID ABEND S0C4 AFTER ERROR RETURN CODE FROM              
*                    STOW.  (EG. DIRECTORY FULL, OR, I/O ERROR.)                
*                  - CEASE PROCESSING INPUT RECORDS AFTER A './ ENDUP '         
*                    RECORD IS ENCOUNTERED.                                     
*                  - DELETE RUN-TIME CODE TO LOAD EXIT ENTRY POINTS             
*                    INTO DCB AREAS BY SPECIFYING APPROPRIATE OPERANDS          
*                    ON THE DCB MACROS.                                         
*                  - DELETE THE &LRECL SYMBOLIC VARIABLE AND ALTER              
*                    CODE TO HANDLE ANY RECORD SIZE UP TO 256.                  
*                    RECORD FORMAT MUST STILL BE FIXED LENGTH RECORDS.          
*                    INPUT AND OUTPUT RECORD LENGTHS NEED NOT BE THE            
*                    SAME.  HENCE, OFFLOAD/PDSLOAD CAN BE USED TO               
*                    TRUNCATE OR EXTEND THE RECORD LENGTH OF A PDS.             
*                  - ENSURE BLANKS ARE USED FOR RECORD EXTENSION.               
*                  - IF THE OPEN OF SYSUT1 FAILS THEN THE OPEN IS               
*                    RETRIED WITH DDNAME=SYSIN IN CASE THE JOB IS               
*                    A HASTILY RE-EDITED IEBUPDTE JOB STREAM.                   
*                  - REDO LOGIC OF PDS OPEN EXIT TO COPY INPUT LRECL            
*                    TO OUTPUT LRECL (IF NOT SUPPLIED), AND TO USE              
*                    SYSTEM-DETERMINED BLOCKSIZE (IF NOT SUPPLIED)              
*                    IF DFP IS 2.4.0 OR HIGHER.  OTHERWISE, 39 TIMES            
*                    THE LRECL IS USED IF IT IS LESS THAN 32K (WHICH            
*                    IT SHOULD BE SINCE MAX LRECL IS 256), OR IF IT             
*                    IS NOT UNDER 32K THEN THE PDS IS NOT BLOCKED.              
*                                                                               
* GREG PRICE - FERNTREE COMPUTER SERVICES - MELBOURNE, AUSTRALIA  GP@FT         
*----------------------------------------------------------------------         
*          26JUN98 - ADD Y2K DATE WINDOWING CODE FOR SPFCREDT AND               
*                    SPFCHGDT.                                                  
*                                                                               
* JOHN KALINICH - USA LSSC, ST. LOUIS, MISSOURI               DRK JUN98         
*----------------------------------------------------------------------         
*          20APR99 - SUPPORT ANY LRECL FOR FIXED-LENGTH AND                     
*                    VARIABLE LENGTH RECORDS.                                   
*                  - FIXED-LENGTH OUTPUT RECORDS ARE WRITTEN FROM               
*                    EITHER FIXED-LENGTH OR VARIABLE-LENGTH INPUT.              
*                    (OFTEN PC TEXT FILE TRANSFERS GO TO A RECFM=VB             
*                    DATA SET ON MVS.)                                          
*                  - VARIABLE-LENGTH OUTPUT DATA REQUIRES VARIABLE-             
*                    LENGTH INPUT RECORDS.                                      
*                  - MINIMUM INPUT LRECL (F AND V) REMAINS AT 80, BUT           
*                    MINIMUM OUTPUT LRECL IS 1 (PLUS 4 FOR RDW IF V).           
*                  - RECORDS ARE TRUNCATED TO FIT INTO THE OUTPUT               
*                    LRECL AS NECESSARY.                                        
*                  - BLANKS ARE USED TO EXTEND FIXED-LENGTH RECORDS             
*                    WHERE OUTPUT LRECL IS BIGGER THAN INPUT LRECL.             
*                  - SUPPORT DDNAME OVERRIDES AS PER IEBUPDTE AND               
*                    OTHER OS UTILITIES FOR INTERFACING WITH REVIEW.            
*                  - PARM=NEW IS USED TO REQUEST IEBUPDTE BEHAVIOUR.            
*                    SPECIFICALLY, OPENING SYSUT1 IS NOT ATTEMPTED,             
*                    AND SYSIN IS ASSUMED TO SPECIFY THE INPUT FILE.            
*                    'NEW' MUST BE THE FIRST OR ONLY OPTION IN THE              
*                    PARAMETER STRING, BEFORE 'SPF' EVEN.                       
*                  - THE RECORD COUNT STORED IN SPF STATISTICS WILL             
*                    BE THE NUMBER OF RECORDS LOADED BY PDSLOAD, AND            
*                    NOT NECESSARILY THE VALUE ON THE ./ ADD CARD.              
*                  - SUPPORT MEMBER NAME SELECTION BY MASK.                     
*                    EG. S(ABC)      - MEMBER ABC ONLY.                         
*                        S(ABC*****) - ALL MEMBERS STARTING WITH ABC.           
*                        S(*BC*)     - ABC, ABCD, EBC3 BUT NOT ABCDE.           
*                    ASTERISK (*), QUESTION MARK (?), AND PERCENT               
*                    SIGN (%) CAN BE USED INTERCHANGABLY AS SINGLE-             
*                    CHARACTER PLACEHOLDERS.                                    
*                  - ENSURE SPF STATS DATA FROM ./ ADD ARE NUMERIC.             
* GREG PRICE                                                      GP@P6         
*----------------------------------------------------------------------         
*          13FEB00 - STARTOOL'S "COMBINE" SUBCOMMAND PUTS     SBG 02/00         
*                    ISPF STATISTICS RECORDS INTO THE ./ ADD  SBG 02/00         
*                    CARDS DIFFERENTLY THAN LISTPDS AND       SBG 02/00         
*                    REVIEW.  PDSLOAD IS BEING MODIFIED TO    SBG 02/00         
*                    RECOGNIZE EITHER FORMAT, AND TO BE ABLE  SBG 02/00         
*                    TO RE-CONSTITUTE THE ISPF STATS NO       SBG 02/00         
*                    MATTER WHICH UTILITY WAS USED TO CREATE  SBG 02/00         
*                    THEM, INSIDE THE ./ ADD NAME=XXXX CARDS. SBG 02/00         
*                                                             SBG 02/00         
*      WHAT "STARTOOL COMBINE" WAS DOING, THE DIFFERENCE      SBG 02/00         
*      IS AS FOLLOWS:   "CREATE DATE" AND "MODIFY DATE"       SBG 02/00         
*      ARE GIVEN SEVEN CHARACTERS INSTEAD OF FIVE, THAT IS:   SBG 02/00         
*                                                             SBG 02/00         
*        CCYYDDD , INSTEAD OF YYDDD .                         SBG 02/00         
*                                                             SBG 02/00         
*      THIS INTRODUCES FOUR EXTRA CHARACTERS.  IF YOU HAVE    SBG 02/00         
*      A 7-CHARACTER USERID, A NON-BLANK WILL BE SHOVED INTO  SBG 02/00         
*      COLUMN 72, RENDERING THE MEMBER UN-STOWABLE BY IBM'S   SBG 02/00         
*      IEBUPDTE.  IEBUPDTE TREATS THE NON-BLANK IN COLUMN 72  SBG 02/00         
*      AS A CONTINUATION CHARACTER, AND EXPECTS ANOTHER       SBG 02/00         
*      CONTROL CARD ON THE NEXT LINE.  AT LEAST PDSLOAD WILL  SBG 02/00         
*      NOW BE ABLE TO DEAL WITH THIS SITUATION PROPERLY.      SBG 02/00         
*                                                             SBG 02/00         
*      I'VE ENTERED AN APAR WITH BRUCE LELAND OF STARTOOL     SBG 02/00         
*      SUPPORT.  BUT THE OLD SEQUENTIAL DATASETS THAT HAVE    SBG 02/00         
*      BEEN CREATED WITH EXISTING RELEASES OF STARTOOL, IN    SBG 02/00         
*      ITS FORMAT, STILL HAVE TO BE DEALT WITH.               SBG 02/00         
*                                                             SBG 02/00         
* SAM GOLOB                                                   SBG 02/00         
*----------------------------------------------------------------------         
*        11NOV2006 - ADDED CTL PARM OPTION TO SUPPORT ADDITIONAL LEVEL          
*                    OF ./ SUBSTITUTION E.G., MEMBERS W/SMP UPDATES             
*                  - ALSO CHANGED PARM PARSING - ANY ORDER NOW ALLOWED          
* GERHARD POSTPISCHIL                                           GP06315         
*----------------------------------------------------------------------         
*        17FEB2008 - ADD SYNAD EXIT ETC. TO ACQUIRE AND DISPLAY                 
*                    I/O ERROR MESSAGE WHEN WRITE TO PDS FAILS.                 
*                    ABEND U0101 AFTER WRITE I/O ERROR.                         
*        10MAY2009 - DO NOT MAKE ALIAS WHEN REAL MEMBER NOT MADE.               
*                  - NOW COMPLETE THE ALLOWED RECFM COMBO SET:                  
*                    FIXED-LENGTH INPUT WITH VARIABLE-LENGTH                    
*                    OUTPUT WITH TRAILING BLANKS TRUNCATION.                    
*        29SEP2009 - ISPF STATISTICS ENHANCEMENTS:                 0909         
*                    - PROCESS SECONDS PART OF TIMESTAMP.                       
*                    - SUPPORT ISPF EXTENDED STATISTICS.                        
* GREG PRICE                                                      GP@P6         
*----------------------------------------------------------------------         
*        05JAN2012 - MEMBER NAME VALIDITY CHECK PROBLEMS.                       
*                    ADD { X'C0' SUPPORT TO ALPHANUM TRANSLATE                  
*                    TABLE.  IF YOU WANT TO GET RID OF THE MEMBER               
*                    NAME VALIDITY CHECK ENTIRELY, THEN UNCOMMENT               
*                    THE STATEMENT:                                             
*                    "B    BYPVALID"                                            
*                    AFTER THE LABEL "SIMPLE".                                  
* SAM GOLOB                                                                     
*----------------------------------------------------------------------         
*        06JAN2012 - MEMBER NAME VALIDITY CHECK PROBLEMS, PART DEUX:            
*                    SAM'S SOLUTION WORKS, BUT IS ONE I FIND                    
*                    UNDESIRABLE (BABY - BATHWATER)                             
*                    INSTEAD I ADDED A PARM OPTION NAME=                        
*       (DEFAULT)    NAME=ASIS    BYPASS ALL CHECKS                             
*                    NAME=CHECK   ALLOW ALL PRINTABLE CHARACTERS                
*                                 (EXCEPT COMMA) USING CODEPAGE 037             
*                    NAME=IBM     ENFORCE STRICT IBM JCL STANDARDS              
*                  - FIXED LRECL FOR UNLIKE RECFM COPY                          
*                  - ADDED NON-SDB BLOCK SIZE CODE BACK IN FOR MVS 3.8          
* GERHARD POSTPISCHIL                                           GP12006         
*----------------------------------------------------------------------         
*        17OCT2015 - READ SYSUPLOG IF PRESENT, WHICH CONTAINS A LIST            
*                    OF EXCEPTIONS TO THE UPDTE(XX) SUBSTITUTION.               
*                    SYSUPLOG DATA IS GENERATED BY AN EXPERIMENTAL              
*                    VERSION OF LISTPDS/LISPDS, ONE OF THE PROGRAMS             
*                    THAT GENERATE THE IEBUPDTE-UNLOADED-PDS FILE               
*                    USED AS INPUT TO THIS PROGRAM.                             
*                    SOMETIMES A LINE IN THE INPUT FILE BEGINS WITH             
*                    THE 2 CHARACTERS IN UPDTE(XX) NOT BECAUSE THEY             
*                    WERE ORIGINALLY ./ BUT BECAUSE THAT'S WHAT THEY            
*                    ALWAYS WERE, AND SHOULD REMAIN.                            
*                    THE SYSUPLOG FILE IDENTIFIES WHICH LINES IN WHICH          
*                    MEMBERS SHOULD NOT BE CHANGED TO ./ IN THE FIRST           
*                    2 COLUMNS, EVEN THOUGH THEY HAVE THE UPDTE(XX)             
*                    CHARACTERS. THE RECORDS IN SYSUPLOG HAVE THE               
*                    MEMBER NAME IN THE FIRST 8 COLUMNS AND A 7-DIGIT           
*                    LINE NUMBER IN COLUMNS 10 THROUGH 16.                      
*                    THE LINE NUMBER INDICATES A COUNTED LINE,                  
*                    NOT A SEQUENCE NUMBER IN AN INPUT LINE.                    
*                    THE MEMBER NAMES IN THE INPUT FILE AND IN THE              
*                    SYSUPLOG FILE MUST BE IN ASCENDING ORDER.                  
*                    ENDLESS LOOP AFTER PARMNCTL WAS FIXED, WHICH               
*                    OCCURRED WHEN UPDTE(XX) IS MISSPELLED IN PARM.             
* EX-PRC GUY                                                                    
*----------------------------------------------------------------------         
*        17OCT2015 - ADD PARM=CK3 AS REQUESTED BY SAM GOLOB FOR                 
*                    EXPERIMENTING WITH REDUCING UNDESIRED CHANGES              
*                    OF UPDTE(XX) TO ./ BY ONLY CHANGING XX TO ./               
*                    IF COLUMN 3 IS BLANK.                                      
*                    CK3 MIGHT INTRODUCE ANOTHER PERHAPS LESSER PROBLEM         
*                    OF NOT PROPERLY RESTORING ./LABEL STATEMENTS.              
*                    UNDESIRED CHANGES OF XX TO ./ CAN STILL OCCUR              
*                    IF COLUMN 3 IS BLANK.                                      
*                    CK3 CAN REDUCE THE RELIABILITY OF SYSUPLOG IF              
*                    SYSUPLOG IS USED AT THE SAME TIME, SO ANY                  
*                    USEFULNESS OF CK3 WOULD ONLY BE SEEN WHEN                  
*                    SYSUPLOG IS NOT USED.                                      
* EX-PRC GUY                                                                    
*----------------------------------------------------------------------         
*        23OCT2015 - Added reporting for the number of SYSUPLOG   .SBG.         
*                    records read for each member which has them. .SBG.         
* SAM GOLOB                                                       .SBG.         
***********************************************************************         
         EJECT                                                                  
***********************************************************************         
*                                                                               
*     PDSLOAD NOW ACCEPTS DDNAME OVERRIDES IN THE SECOND PROGRAM                
*     PARAMETER.  THE IBM OS/360-TO-OS/390 UTILITY PROGRAM DDNAME               
*     PARAMETER FORMAT IS USED.  THE THIRD PARAMETER (INITIAL PAGE              
*     NUMBER FOR REPORT) IS NOT USED.  THE SYSIN SLOT IS USED FOR               
*     THE INPUT SEQUENTIAL FILE DDNAME, THE SYSPRINT SLOT IS USED               
*     FOR THE OUTPUT REPORT DDNAME, AND THE SYSUT2 SLOT IS USED                 
*     FOR THE OUTPUT PARTITIONED FILE DDNAME.  THE PARAMETER                    
*     CONSISTS OF A HALFWORD LENGTH COUNT FOLLOWED BY A NUMBER OF               
*     CONTIGUOUS 8-BYTE SLOTS.  PDSLOAD REQUIRES THAT THE LENGTH                
*     COUNT IS A MULTIPLE OF 8.  A NULL SLOT MEANS NO OVERRIDE FOR              
*     THE CORRESPONDING DDNAME.  THERE IS NO MINIMUM SLOT COUNT                 
*     REQUIREMENT.  DDNAMES MUST BE PADDED WITH BLANKS TO 8-BYTES               
*     IF NECESSARY.                                                             
*                                                                               
*     THE ABILITY TO OVERRIDE DDNAMES WAS IMPLEMENTED TO FACILITATE             
*     THE DYNAMIC INVOCATION OF PDSLOAD FROM THE REVIEW TSO COMMAND.            
*                                                                               
*     THE IBM UTILITY DDNAME SLOT CONVENTION GOES SOMETHING LIKE THIS:          
*         01  SYSLIN                                                            
*         02  OUTPUT MEMBER NAME                                                
*         03  SYSLMOD                                                           
*         04  SYSLIB                                                            
*         05  SYSIN                                                             
*         06  SYSPRINT      (SYSLOUT)                                           
*         07  SYSPUNCH                                                          
*         08  SYSUT1                                                            
*         09  SYSUT2                                                            
*         10  SYSUT3                                                            
*         11  SYSUT4                                                            
*         12  SYSTERM                                                           
*         13  SYSUT5                                                            
*         14  SYSUT6        (SYSCIN FOR PL/I COMPILER)                          
*         15  SYSUT7                                                            
*         16  SYSADATA                                                          
*         17  SYSIDL                                                            
*                                                                               
***********************************************************************         
         EJECT                                                                  
***********************************************************************         
*                                                                               
*         THE ONLY IEBUPDTE CONTROL STATEMENTS THAT ARE ACCEPTABLE              
*         ARE THE ./ ADD STATEMENT AND THE ./ ALIAS STATEMENT.                  
*         THE 'NAME=' OPERAND MUST BE SPECIFIED AS THE FIRST OR                 
*         SECOND OPERAND (SOMETIMES SSI= IS SPECIFIED FIRST).                   
*         ANY OTHER IEBUPDTE OPERAND (EXCEPT SSI=) IS INVALID AND               
*         WILL PREVENT SUBSEQUENT OPERANDS FROM BEING PROCESSED.                
*         ./ ENDUP STATEMENTS WILL NOW TERMINATE PROCESSING.                    
*                                                                               
*         THESE ADD STATEMENTS WILL BE PROCESSED CORRECTLY -                    
*         ./ ADD NAME=XYZ                                                       
*         ./ ADD NAME=XYZ,SSI=0012C06A                                          
*         ./ ADD SSI=1234ABCD,NAME=XYZ                                          
*                                                                               
*         IN ORDER FOR SPF STATISTICS TO BE STORED, THE './ ADD'                
*         STATEMENT MUST LOOK LIKE THIS:                                        
*                                                                               
*            COL     DESCRIPTION                                                
*            1-20    ./ ADD NAME=XXXXXXXX                                       
*            21      BLANK                                                      
*            22-71   VVMM-YYDDD-YYDDD-HHMM-NNNNN-NNNNN-NNNNN-UUUUUUUUUU         
*                    VER CREATE LASTMODIFY  SIZE  INIT   MOD   ID               
*                                                                               
*         THE 'LISTPDS' UTILITY PROGRAM (FROM NASA GODDARD) HAS                 
*         BEEN LOCALLY MODIFIED TO PUNCH AN IEBUPDTE DECK WITH                  
*         SPF STATISTICS IN THE ABOVE FORMAT. IT DOES NOT PUNCH                 
*         ./ ALIAS STATEMENTS, HOWEVER.                                         
*                                                                               
*         THE 'REVIEW' UTILITY TSO COMMAND IN CBT FILE 134 HAS                  
*         BEEN LOCALLY MODIFIED TO PUNCH AN IEBUPDTE DECK WITH                  
*         SPF STATISTICS IN THE ABOVE FORMAT. IT CAN ALSO PUNCH                 
*         ./ ALIAS STATEMENTS WHEN THE MEMBER LIST HAS BEEN SORTED              
*         INTO TTR ORDER.                                                       
*                                                                               
*         THE SPF DATA IS IN THE 'COMMENTS' AREA OF THE STATEMENT               
*         SO THE INPUT COULD BE RUN THRU 'IEBUPDTE' SUCCESSFULLY.               
*         IT WOULD JUST IGNORE THE SPF DATA.                                    
*                                                                               
*         THE FORMAT OF THE 50-BYTE SPF FIELD IS FIXED. EACH VALUE              
*         MUST HAVE THE CORRECT NUMBER OF DIGITS (USE LEADING ZEROES            
*         IF NECESSARY). ONLY THE 10-BYTE 'ID' FIELD AT THE END                 
*         MAY HAVE A VARIABLE LENGTH. NO IMBEDDED BLANKS ALLOWED.               
*         VALUES MUST BE SEPARATED BY A HYPEN AS ABOVE. IF THE                  
*         DATA DOES NOT CONFORM TO THESE RULES, THE MEMBER WILL                 
*         STILL BE WRITTEN BUT WITHOUT SPF STATISTICS.  NOTE THAT               
*         ISPF INSISTS THAT THE NINTH AND TENTH BYTES OF THE USERID             
*         ARE BLANKS OR ISPF WILL NOT SHOW THE STATISTICS.                      
*                                                                               
*         INPUT (SYSUT1) DCB ATTRIBUTES NEED NOT BE SPECIFIED IF                
*         THE FILE HAS STANDARD LABELS. IF IT IS AN UNLABELED TAPE,             
*         ONLY THE BLKSIZE NEED BE SPECIFIED (IF IT IS NOT &LRECL).             
*                                                                               
*         IF THE OUTPUT FILE DOES NOT HAVE ATTRIBUTES IN ITS LABEL              
*         AND NONE ARE SPECIFIED IN THE SYSUT2 DD STATEMENT, THE                
*         PROGRAM WILL SET THEM TO LRECL=&LRECL, BLKSIZE=39*&LRECL. NWK         
*                                                                               
*         RECOMMENDATION: SUPPLY COMPLETE INPUT DCB EITHER VIA DATA             
*         SET LABELS (TAPE OR DISK) OR VIA JCL.                                 
*                                                                               
*         NOTES ON OUTPUT DCB:  IF SUPPLIED COMPLETELY FROM DATA SET            
*         LABELS, JCL, OR BOTH COMBINED, THEN THAT IS FINE.  SOME               
*         PEOPLE CODE 'RECFM=F,BLKSIZE=80' SO DCBLRECL IS ZERO.                 
*         HENCE, IF OUTPUT BLKSIZE IS SUPPLIED AND OUTPUT LRECL IS              
*         NOT, THEN IT IS COPIED FROM THE OUTPUT BLKSIZE AND AN                 
*         UNBLOCKED PDS IS ASSUMED.  IF BOTH LRECL AND BLKSIZE ARE              
*         SUPPLIED THEN THE SUPPLIED VALUES ARE USED.  IF NEITHER IS            
*         SUPPLIED THEN THE OUTPUT LRECL IS COPIED FROM THE INPUT               
*         SEQUENTIAL FILE LRECL.  IF YOU HAVE DFP 2.4.0 OR LATER                
*         THEN CODE OR LEAVE OUTPUT BLKSIZE=0 FOR SYSTEM-DETERMINED             
*         BLOCKSIZE.  OLD DFP OR NON-DFP DEFAULT IS 39 TIMES LRECL.             
*                                                                               
*$DOC$*****************************************************************         
* ------------------------------------------------------------------ *          
         MACRO ,                                                                
&NM      TRENT &TAB,&VAL,&OFF,&FILL=                    ADDED ON 86311          
.*                                                                              
.*   This macro is used to create translate and translate and test              
.*     tables in compact fashion.                                               
.*                                                                              
.*   The table may be built by (separate) DC statements, or by                  
.*     a TRENT entry with a FILL= operand and a name field.     GP12005         
.*                                                                              
.*   Any name field is attached to first expanded DC, if any                    
.*     First positional is name of table to be modified; may be                 
.*       null after first occurrence and after a FILL                           
.*     Second positional is value to be placed in table; may be                 
.*       null after first occurrence. May be expression.                        
.*     Subsequent values are offsets in self-defining form, i.e.,               
.*       X'nn', C'x', integer, equate value, or absolute expression.            
.*     A sublist may be used, offset in first value, repeat count               
.*       in second.                                                             
.*     When the last parm is null, no final ' ORG ' is created.                 
.*       (requested by trailing comma)                                          
.*     When no parameters are supplied, a final ' ORG ' is expanded.            
.*                                                                              
.*       ex.:  upper case translate:                                            
.*       UPTAB DC    256AL1(*-UPTAB)     or                                     
.*       UPTAB TRENT FILL=(*-UPTAB)                                             
.*             TRENT UPTAB,*-UPTAB+X'40',(X'81',9),(X'91',9),(X'A2,8)           
.*                                                                              
         GBLC  &ZZ@TAB,&ZZ@VAL                                                  
         LCLC  &N                                                               
         LCLA  &I,&J                                                            
&J       SETA  N'&SYSLIST                                                       
&N       SETC  '&NM'                                                            
         AIF   (T'&FILL EQ 'O').DATA                            GP12005         
         AIF   ('&N' NE '').BUILD                               GP12005         
         MNOTE 8,'TRENT WITH FILL= REQUIRES A LABEL'            GP12005         
         MEXIT ,                                                GP12005         
.*   BUILD TRANSLATE OR TRT TABLE                               GP12005         
.*                                                              GP12005         
.BUILD   ANOP  ,                                                GP12005         
&N       DC    256AL1(&FILL)                                    GP12005         
&ZZ@TAB  SETC  '&N'                                             GP12005         
&N       SETC  ''                                               GP12005         
         AIF   (&J EQ 0).MEND                                   GP12005         
.*   EXPAND TABLE MODIFICATIONS                                                 
.*                                                                              
.DATA    AIF   (&J EQ 0).ORG                                                    
         AIF   ('&TAB' EQ '').NOTAB                                             
&ZZ@TAB  SETC  '&TAB'                                                           
.NOTAB   AIF   ('&VAL' EQ '').NOVAL                                             
&ZZ@VAL  SETC  '&VAL'                                                           
.NOVAL   AIF   (&J LT 3).MEND                                                   
&I       SETA  2                                                                
.LOOP    AIF   (&I GE &J).DONE                                                  
&I       SETA  &I+1                                                             
         AIF   ('&SYSLIST(&I)' EQ '').LOOP                                      
         AIF   (N'&SYSLIST(&I) EQ 2).PAIR                                       
         ORG   &ZZ@TAB+&SYSLIST(&I)                                             
&N       DC    AL1(&ZZ@VAL)                                                     
&N       SETC  ''                                                               
         AGO   .LOOP                                                            
.PAIR    ORG   &ZZ@TAB+&SYSLIST(&I,1)                                           
&N       DC    (&SYSLIST(&I,2))AL1(&ZZ@VAL)                                     
&N       SETC  ''                                                               
         AGO   .LOOP                                                            
.DONE    AIF   ('&SYSLIST(&J)' EQ '').MEND                                      
.ORG     ORG   ,                                                                
.MEND    MEND  ,                                                                
* ------------------------------------------------------------------ *          
         MACRO                                                                  
&NAME    HEX   &TO,&LEN,&FROM                                                   
&NAME    DS    0H                                                               
         ST    R4,SAV4HEX                                                       
         STM   R15,R1,HEXSAVE                                                   
         LA    R1,&FROM                                                         
         LA    R0,&LEN                                                          
         LA    R15,&TO                                                          
         BAL   R4,HEX                                                           
         L     R4,SAV4HEX                                                       
         LM    R15,R1,HEXSAVE                                                   
         MEND                                                                   
* ------------------------------------------------------------------ *          
         GBLC  &VER                                               .SBG.         
&VER     SETC  'V10.1'                                            .SBG.         
* ------------------------------------------------------------------ *          
         LCLB  &NODIAG                                                          
&NODIAG  SETB  1                                                                
* ------------------------------------------------------------------ *          
         SPACE                                                                  
PDSLOAD  CSECT                                                                  
         USING PDSLOAD,R15                                                      
         B     @PROLOG                                                          
         DROP  R15                                                              
         DC    AL1(17),CL17'PDSLOAD &SYSDATE '   MVS 3.8        GP06315         
         DC    CL10' ANY LRECL'                                                 
         DC    CL48' OUT:  1:F,V->F (TRUNC,EXTEND)  2:F,V->V (TRUNC)'           
@SIZE    DC    0F'0',AL1(1),AL3(@DATAL)                                         
         USING PDSLOAD,R10,R11,R12                                              
@PROLOG  STM   R14,R12,12(R13)                                                  
         LR    R10,R15             BASE REGISTER                                
         LA    R15,4095                                                         
         LA    R11,1(R15,R10)      BASE REGISTER                                
         LA    R12,1(R15,R11)      BASE REGISTER                                
         LR    R2,R1                                                            
         L     R0,@SIZE                                                         
         GETMAIN R,LV=(0)                                                       
         L     R15,@SIZE           TARGET SIZE                                  
         LR    R14,R1              TARGET ADDRESS                               
         SLR   R5,R5               SOURCE SIZE AND PAD                          
         MVCL  R14,R4              ZERO DYNAMIC AREA                            
         ST    R13,4(,R1)          CHAIN SAVE AREAS                             
         ST    R1,8(,R13)                                                       
         LR    R13,R1                                                           
         USING @DATA,R13                                                        
         MVC   SYNADMSG,SYNADWTO   PRIME I/O ERROR MESSAGE      FEB2008         
         SPACE 1                                                                
*   VALIDITY CHECKING FOR MEMBER NAMES IS SUPPRESSED BY DEFAULT GP12006         
*   TO CHANGE THE DEFAULT, ACTIVATE THE DESIRED LA INSTRUCTION: GP12006         
*        LA    R0,CHARIBM          STRICT IBM NAME CHECK        GP12006         
*        LA    R0,CHAR037          ANY PRINTABLE EXCEPT COMMA   GP12006         
*        LA    R0,0                NO CHECKING                  GP12006         
*        ST    R0,@TRTTAB                                       GP12006         
*        MVI   CHARIBM+C'-',0      ALLOW OS/360 HYPHEN IN NAME  GP12006         
         SPACE 1                                                                
         ZAP   REPORTPG,=P'0'      INITIAL PAGE COUNTER                         
         ZAP   REPORTLN,=P'0'      INITIAL LINE COUNTER                         
         ZAP   REPORTMX,=P'50'     INITIAL LINES PER PAGE                       
         MVI   REPORTO-1,C' '      BLANK PROPAGATOR                             
         MVI   LINE-1,C' '         BLANK PROPAGATOR                             
         MVC   MEMSEL,=CL8' '                                                   
         MVC   UPDTE,=C'./'        CONVERSION CODE (./)                         
         MVC   CTLMODEL(2),UPDTE   CONTROL CARD CODE (./)       GP06315         
         MVC   CTLMODEL+2(10),=C' ADD NAME='                    GP06315         
         SPACE                                                                  
         L     R1,0(,R2)           POINT TO PARM                                
         LH    R0,0(,R1)           GET LENGTH OF PARM                           
         LTR   R0,R0                                                            
         BNP   PARMDONE                                         GP06315         
PARMLOOP CLI   2(R1),C','                                       GP06315         
         BNE   PARMNCOM                                         GP06315         
         LA    R3,1                SKIP COMMA                   GP06315         
         B     PARMBUMP                                         GP06315         
PARMNCOM CH    R0,=H'3'            IS PARM LONG ENOUGH FOR SPF                  
         BL    PARMBAD             NO, BYPASS COMPARE                           
         CLC   =C'NEW',2(R1)       IS IT NEW, AS PER IEBUPDTE?  GP06315         
         BNE   TRYSPF              NO                                           
         OI    FLAG1,NEWPRM        YES, TOLERATE AS PDSLOAD DOES THIS           
         LA    R3,3                SET SKIP LENGTH              GP06315         
         B     PARMBUMP            AND SKIP                     GP06315         
TRYSPF   CLC   =C'SPF',2(R1)       IS IT SPF                    GP06315         
         BNE   PARMSX                                                           
         OI    FLAG1,GENSPF        YES, GENERATE SPF STATISTICS                 
         LA    R3,3                SET SKIP LENGTH              GP06315         
         B     PARMBUMP            AND SKIP                     GP06315         
PARMSX   CLC   =C'CK3',2(R1)       IS IT CK3                    OCT2015         
         BNE   PARMCX                                           OCT2015         
         OI    FLAG1,CK3           YES, CHECK FOR BLANK IN 3    OCT2015         
         LA    R3,3                SET SKIP LENGTH              OCT2015         
         B     PARMBUMP            AND SKIP                     OCT2015         
PARMCX   CLC   =C'S(',2(R1)        IS IT S( ?                   GP06315         
         BNE   PARMMX              NO, BRANCH                                   
         LA    R1,2(,R1)           YES, POINT PAST PAREN                        
         SH    R0,=H'2'                                                         
         LA    R15,MEMSEL                                                       
         LA    R14,L'MEMSEL        SET MAX LOOP COUNT           GP06315         
PARMML   CLI   2(R1),C')'                                       GP06315         
         BE    PARMME                                                           
         MVC   0(1,R15),2(R1)      COPY ONE BYTE OF MEMBER NAME                 
         LA    R15,1(,R15)                                                      
         LA    R1,1(,R1)           BUMP SKIP SIZE               GP06315         
         BCT   R0,PARMMIG          OK IF MORE                   GP06315         
         B     PARMBAD             ALL DONE, BUT MISSING ')'    GP06315         
PARMMIG  BCT   R14,PARMML          LOOP FOR MEMBER NAME         GP06315         
         CLI   2(R1),C')'          PROPER TERMINATION ?         GP06315         
         BL    PARMBAD             NO, FAIL                     GP06315         
PARMME   LA    R3,1                POINT PAST PAREN             GP06315         
         B     PARMBUMP            SKIP TO NEXT OPERAND         GP06315         
PARMMX   CH    R0,=H'5'            IS PARM LONG ENOUGH ?        GP12006         
         BL    PARMBAD               NO                         GP12006         
         CLC   =C'NAME=',2(R1)     IS IT NAME CHECK ?           GP12006         
         BNE   PARMNN                NO                         GP12006         
         LA    R3,5                SKIP KEYWORD                 GP12006         
         XC    @TRTTAB,@TRTTAB     RESET PRIOR, JUST IN CASE    GP12006         
         CH    R0,=H'5'            END OF PARM ?                GP12006         
         BNH   PARMBUMP              YES; DONE                  GP12006         
         CLI   5+2(R1),C','        NULL VALUE ?                 GP12006         
         BE    PARMBUMP              YES                        GP12006         
         LA    R3,8                SKIP KEYWORD AND VALUE       GP12006         
         CR    R0,R3               LONG ENOUGH FOR VALUE?       GP12006         
         BL    PARMBAD               NO; ERROR                  GP12006         
         LA    R14,CHARIBM         POINT TO IBM TEST TABLE      GP12006         
         CLC   =C'IBM',2+5(R1)     IS IT IBM?                   GP12006         
         BE    PARMHTAB              YES; STASH VALUE           GP12006         
         CLC   =C'JCL',2+5(R1)     IS IT ALTERNATE?             GP12006         
         BE    PARMHTAB              YES; STASH VALUE           GP12006         
         LA    R3,9                SKIP KEYWORD AND VALUE       GP12006         
         CR    R0,R3               LONG ENOUGH FOR VALUE?       GP12006         
         BL    PARMBAD               NO; ERROR                  GP12006         
         LA    R14,0               RESET TEST TABLE ADDRESS     GP12006         
         CLC   =C'ASIS',2+5(R1)    SKIP TESTING ?               GP12006         
         BE    PARMHTAB              YES                        GP12006         
         LA    R3,10               SKIP KEYWORD AND VALUE       GP12006         
         CR    R0,R3               LONG ENOUGH FOR VALUE?       GP12006         
         BL    PARMBAD               NO; ERROR                  GP12006         
         LA    R14,CHAR037         SET FOR CODEPAGE 037 EXC ,   GP12006         
         CLC   =C'CHECK',2+5(R1)   TEST 037 PRINTABLES?         GP12006         
         BNE   PARMBAD               NO; BAD PARAMETER          GP12006         
PARMHTAB ST    R14,@TRTTAB         SAVE TRANSLATE TABLE ADDRESS GP12006         
         B     PARMBUMP              AND SKIP TO NEXT FIELD     GP12006         
PARMNN   CH    R0,=H'7'            IS PARM LONG ENOUGH ?        GP06315         
         BL    PARMBAD             NO, BYPASS COMPARE           GP06315         
         CLC   =C'CTL(',2(R1)      IS IT CTL(XX)                GP06315         
         BNE   PARMNCTL                                         GP06315         
         CLI   8(R1),C')'          CORRECT TERMINATION ?        GP06315         
         BNE   PARMBAD             NO, FAIL                     GP06315         
         MVC   CTLMODEL(2),6(R1)   YES, SAVE NEW CONTROLS       GP06315         
         LA    R3,7                  SKIP SEVEN                 GP12006         
         B     PARMBUMP                                         GP06315         
PARMNCTL CH    R0,=H'9'            IS PARM LONG ENOUGH ?        GP06315         
         BL    PARMBAD             NO, BYPASS COMPARE           GP06315         
         CLC   =C'UPDTE(',2(R1)    IS IT UPDTE(XX)              GP06315         
*        BNE   PARMNCTL                   (WAS ENDLESS LOOP)    *.VTO.          
         BNE   PARMBAD                    (FIX ENDLESS LOOP)     .VTO.          
         CLI   10(R1),C')'         CORRECT TERMINATION ?        GP06315         
         BNE   PARMBAD             NO, FAIL                     GP06315         
         MVC   UPDTE,8(R1)         YES, SAVE NEW CONVERSION     GP06315         
         LA    R3,9                                             GP06315         
PARMBUMP AR    R1,R3               NEXT PARM                    GP06315         
         SR    R0,R3               RESIDUAL LENGTH              GP06315         
         BP    PARMLOOP                                         GP06315         
         B     PARMDONE                                         GP06315         
PARMBAD  WTO   'PDSLOAD: INVALID PARM FIELD'                    GP06315         
         ABEND 100                                                              
         EJECT                                                                  
************************************************************                    
*                                                          *                    
*        INITIALIZE THE DCBS                               *                    
*                                                          *                    
************************************************************                    
         SPACE                                                                  
PARMDONE MVC   PRTDCBW(PRTDCBL),PRTDCB                                          
         MVC   UT1DCBW(UT1DCBL),UT1DCB                                          
         MVC   PDSDCBW(PDSDCBL),PDSDCB                                          
         MVC   VTODCBW(VTODCBL),VTODCB                                          
         LA    R3,PRTDCBW                                                       
         LA    R4,UT1DCBW                                                       
         LA    R5,PDSDCBW                                                       
         TM    FLAG1,NEWPRM        WAS PARM=NEW SPECIFIED?                      
         BZ    NEWPRMOK            NO                                           
         MVC   DDNAM(8,R4),=CL8'SYSIN'   YES, BEHAVE LIKE IEBUPDTE              
NEWPRMOK TM    0(R2),X'80'         ANY DDNAME OVERRIDES?                        
         BO    PARM2X              NO, ONLY ONE PARAMETER                       
         L     R1,4(,R2)           POINT TO SECOND PARAMETER                    
         LA    R1,0(,R1)           ENSURE ADDRESS FORMAT                        
         LTR   R1,R1               ZERO POINTER?                                
         BZ    PARM2BAD            YES, NO OVERRIDES SUPPLIED                   
         CLI   0(R1),0             LENGTH LESS THAN 256?                        
         BNE   PARM2BAD            NO                                           
         TM    1(R1),7             MULTIPLE OF EIGHT?                           
         BNZ   PARM2BAD            NO                                           
         CLI   1(R1),8*5           SYSIN SLOT PRESENT?                          
         BL    PARM2X              NO                                           
         CLI   34(R1),0   (8*4+2)  SYSIN OVERRIDE SPECIFIED?                    
         BE    PARM2I              NO                                           
         MVC   DDNAM(8,R4),34(R1)  YES, COPY IT INTO DCB                        
PARM2I   CLI   1(R1),8*6           SYSPRINT SLOT PRESENT?                       
         BL    PARM2X              NO                                           
         CLI   42(R1),0   (8*5+2)  SYSPRINT OVERRIDE SPECIFIED?                 
         BE    PARM2P              NO                                           
         MVC   DDNAM(8,R3),42(R1)  YES, COPY IT INTO DCB                        
PARM2P   CLI   1(R1),8*9           SYSUT2 SLOT PRESENT?                         
         BL    PARM2X              NO                                           
         CLI   66(R1),0   (8*8+2)  SYSUT2 OVERRIDE SPECIFIED?                   
         BE    PARM2X              NO                                           
         MVC   DDNAM(8,R5),66(R1)  YES, COPY IT INTO DCB                        
         B     PARM2X              DDNAME OVERRIDE PROCESSING COMPLETE          
PARM2BAD WTO   'PDSLOAD - INVALID DDNAME OVERRIDE PARAMETER IGNORED',  +        
               ROUTCDE=(11)                                                     
PARM2X   DS    0H                                                               
         EJECT                                                                  
************************************************************                    
*                                                          *                    
*        OPEN THE DCBS                                     *                    
*                                                          *                    
************************************************************                    
         SPACE                                                                  
         LA    R6,OPEN                                                          
         MVI   0(R6),X'80'                                                      
         SPACE                                                                  
         OPEN  ((R3),OUTPUT),MF=(E,(R6))                                        
         SPACE                                                                  
         TM    OFLGS(R3),X'10'                                                  
         BO    OKPRT                                                            
         LA    R15,16                                                           
         B     EXIT                                                             
PRTEXO   CLC   BLKSI(2,R1),=H'0'                                                
         BNER  R14                                                              
         MVC   BLKSI(2,R1),LRECL(R1)                                            
         NI    RECFM(R1),255-X'10' CHANGE RECFM FROM FBA TO FA                  
         BR    R14                                                              
OKPRT    OI    STATUS,PRT          SYSPRINT IS OPEN                             
         SPACE                                                                  
         LR    R5,R4               FOR ERROR MESSAGE, IF ANY    GP12006         
         DEVTYPE DCBDDNAM-IHADCB(R4),DOUBLE                     GP12006         
         BXLE  R15,R15,HAVEUT1                                  GP12006         
         MVC   LINE,LINE-1                                      GP12006         
         MVC   LINE+1(L'MSGMISS1),MSGMISS1                      GP12006         
         MVC   LINE+1(8),DCBDDNAM-IHADCB(R4)                    GP12006         
         BAL   R14,REPORT          DISPLAY WARNING              GP12006         
         WTO   'PDSLOAD WILL RETRY WITH DDNAME=SYSIN',                 +        
               ROUTCDE=(11)        USE SAME ROUTING AS IEC130I                  
         MVC   DDNAM(8,R4),=CL8'SYSIN'   YES, NO OVERRIDE SO RETRY              
         DEVTYPE DCBDDNAM-IHADCB(R4),DOUBLE                     GP12006         
         BXH   R15,R15,MISSUT2     SHOW FILE MISSING            GP12006         
HAVEUT1  LA    R5,PDSDCBW          RESTORE OUTPUT DCB ADDRESS   GP12006         
         OPEN  ((R4),INPUT),MF=(E,(R6))                                         
         SPACE                                                                  
         TM    OFLGS(R4),X'10'                                                  
         BO    OKUT1                                                            
         LR    R5,R4               FOR ERROR MESSAGE            GP12006         
         B     MISSUT2                                          GP12006         
         SPACE 1                                                                
UT1EXO   TM    RECFM(R1),X'C0'     UNDEFINED RECORD FORMAT?                     
         BOR   R14                 YES, TAKE NO ACTION HERE                     
         MVI   DWLIN+1,4           PREPARE FOR INPUT RDWS                       
         TM    RECFM(R1),X'40'     FIXED LENGTH RECORD INPUT?                   
         BOR   R14                 NO, TAKE NO ACTION HERE                      
         MVI   DWLIN+1,0           NO INPUT RDWS                                
         OI    RECFM(R1),X'80'     FORCE SOME RECORD FORMAT                     
         CLC   BLKSI(2,R1),=H'0'   IS BLKSIZE SPECIFIED?                        
         BNE   UT1EX1              YES, CHECK LRECL                             
         MVC   BLKSI(2,R1),LRECL(R1)  NO, DEFAULT IS UNBLOCKED                  
         NI    RECFM(R1),255-X'10' CHANGE RECFM FROM FB TO F                    
         BR    R14                 RETURN                                       
UT1EX1   CLC   LRECL(2,R1),=H'0'   IS LRECL SPECIFIED?                          
         BNER  R14                 YES, RETURN                                  
         MVC   LRECL(2,R1),BLKSI(R1)  NO, DEFAULT IS UNBLOCKED                  
         NI    RECFM(R1),255-X'10' CHANGE RECFM FROM FB TO F                    
         BR    R14                 RETURN                                       
         SPACE 1                                                                
OKUT1    OI    STATUS,UT1          SYSUT1 IS OPEN                               
         TM    RECFM(R4),X'C0'     INPUT RECFM=U?                               
         BO    UNDEFBAD            YES, INVALID                                 
         MVC   LINE,LINE-1                                                      
         MVC   LINE+1(SHOMSGLN),SHORTMSG                                        
         LA    R0,80               MINIMM DATA LENGTH           GP12006         
         AH    R0,DWLIN            ADJUST FOR RECFM=V           GP12006         
         CH    R0,LRECL(,R4)       INPUT LRECL<80?              GP12006         
         BH    FAILEXIT            YES, INVALID                                 
         SPACE                                                                  
         DEVTYPE DCBDDNAM-IHADCB(R5),DOUBLE   EXIT NEEDS TYPE   GP12006         
         BXH   R15,R15,MISSUT2                                  GP12006         
         CLI   DOUBLE+2,X'20'      UCB3DACC                     GP12006         
         BNE   MISSUT2               NO; CAN'T BE PDS           GP12006         
         OPEN  ((R5),OUTPUT),MF=(E,(R6))                                        
         SPACE                                                                  
         TM    OFLGS(R5),DCBOFOPN                               GP12006         
         BO    OKUT2                                                            
MISSUT2  MVC   LINE,LINE-1                                      GP12006         
         MVC   LINE+1(L'MSGMISS2),MSGMISS2                      GP12006         
         MVC   LINE+1+STRMIDD2-STRMISS2(8),DCBDDNAM-IHADCB(R5)  GP12006         
         BAL   R14,REPORT          DISPLAY THE ERROR MESSAGE    GP12006         
         LA    R15,16                                                           
         B     EXIT                                                             
         SPACE 1                                                                
*   SYSUT2 DCB EXIT - IF NOT SPECIFIED, USE DCB PARAMETERS FROM GP12006         
*   SYSUT1/SYSIN. CODE ADDED TO ADJUST LRECL BY FOUR IF F->V OR GP12006         
*   V->F REQUESTED.                                             GP12006         
*                                                               GP12006         
         PUSH  USING                                            GP12006         
**       USING UT2EXO,R15         JUST IN CASE - BUT FIX ASMA303W D1701         
         USING IHADCB,R1           MAKE (MY) LIFE EASIER        GP12006         
UT2EXO   LH    R2,LRECL(,R4)       COPY INPUT LENGTH (DEFAULT)  GP12006         
         TM    DCBRECFM,X'C0'      NULL RECORD FORMAT?                          
         BM    UT2EX3              NO, FIXED OR VARIABLE LENGTH                 
         BZ    UT2EX2              YES, COPY INPUT RECORD FORMAT                
         XC    DCBLRECL,DCBLRECL   RECFM=U SO FORCE LRECL=0     GP12006         
         BR    R14                 RETURN                                       
UT2EX2   MVC   DCBRECFM,RECFM(R4)  YES, COPY INPUT RECFM        GP12006         
UT2EX3   TM    DCBRECFM,X'80'      FIXED ?                      GP12006         
         BNZ   UT2EX3B               YES; ELSE                  GP12006         
         MVI   DWLOT+1,4           USE OUTPUT BDWS AND RDWS     GP12006         
UT2EX3B  CLC   =H'0',DCBLRECL      IS LRECL SPECIFIED?          GP12006         
         BNE   UT2EX4              YES, TAKE NO ACTION HERE                     
*   WHEN INPUT AND OUTPUT ARE BOTH F OR BOTH V, NO ADJUSTMENT   GP12006         
*   IS NECESSARY. FOR F->V, ADD 4, FOR V->F, SUBTRACT 4         GP12006         
         TM    RECFM(R4),X'80'     FROM F ?                     GP12006         
         BNZ   UT2FROF               YES                        GP12006         
         TM    DCBRECFM,X'80'      TO F ?                       GP12006         
         BZ    UT2BLK                NO; JUST CHECK BLOCK       GP12006         
         SH    R2,=H'4'            ADJUST FOR V->F              GP12006         
         B     UT2BLK                CHECK BLOCK                GP12006         
UT2FROF  TM    DCBRECFM,X'80'      OUTPUT ALSO F ?              GP12006         
         BNZ   UT2BLK                YES; NO ADJUSTMENT         GP12006         
         LA    R2,4(,R2)           ALLOW FOR OUTPUT RDW         GP12006         
UT2BLK   STH   R2,DCBLRECL         SET NEW LRECL                GP12006         
UT2EX4   SR    R7,R7               PREP FOR DIVIDE              GP12006         
         ICM   R7,3,DCBBLKSI       GET BLOCK SIZE               GP12006         
         BNZR  R14                   HOPE FOR THE BEST          GP12006         
         LH    R2,DCBLRECL         GET RECORD LENGTH BACK       GP12006         
         L     R3,CVTPTR(,0)       GET CVT                      GP12006         
         TM    CVTDCB-CVTMAP(R3),X'80'   XA OR LATER ?          GP12006         
         BNZR  R14                   YES; ASSUME SDB AVAILABLE  GP12006         
         IC    R3,DOUBLE+3         GET DEVICE TYPE              GP12006         
         LA    R0,X'0F'            MAKE DASD TYPE MASK          GP12006         
         NR    R3,R0               ISOLATE SUBTYPE              GP12006         
         SLL   R3,1                MAKE HALFWORD OFFSET         GP12006         
         LH    R7,MVSBLK(R3)       GET (SUB)OPTIMAL SIZE        GP12006         
         TM    DCBRECFM,X'80'      FIXED?                       GP12006         
         BZ    UT2BLKV             NO; HANDLE VARIABLE BLOCK    GP12006         
         SR    R6,R6                                            GP12006         
         DR    R6,R2               NUMBER OF RECORDS IN BLOCK   GP12006         
         LTR   R7,R7               ANY ?                        GP12006         
         BP    *+8                   YES                        GP12006         
         LA    R7,1                DEFAULT TO ONE               GP12006         
         MR    R6,R2               NEW BLOCK SIZE               GP12006         
         B     UT2BLKST              YES; USE IT                GP12006         
UT2BLKV  LA    R2,4(,R2)           MINIMUM BLOCK SIZE           GP12006         
         CR    R7,R2               ADEQUATE BLOCK SIZE ?        GP12006         
         BNL   UT2BLKST              YES; USE IT                GP12006         
         LR    R7,R2               USE LRECL+4 FOR BLOCK        GP12006         
UT2BLKST STH   R7,DCBBLKSI         SHOULD WORK ?                GP12006         
         BR    R14                 CONTINUE                     GP12006         
         POP   USING                                            GP12006         
*          0-7   ???? 2311 2301 2303 2321 9345  2305 2305       GP12006         
MVSBLK   DC    H'4096,3625,4096,2446,4906,22928,3210,3516'      GP12006         
*          8-F   2314 3330  3340 3350  3375  333D  3380  3390   GP12006         
         DC    H'7294,13030,8368,19069,17600,13030,23476,27998' GP12006         
         SPACE 1                                                                
*  TEST FOR BACK LEVEL MVS AND DFP DROPPED.  COMPLETE DCB DETAILS               
*  OF TARGET PDS SHOULD BE IN VTOC BEFORE THIS PROGRAM GETS CONTROL.            
*  EVEN SO, THE ABOVE CODE SHOULD ALLOW A PDSLOAD TO A NEW PDS THAT             
*  HAS HAD NO DCB ATTRIBUTES PREVIOUSLY SUPPLIED ON A "MODERN" MVS.             
*                                                                               
*  SOME OF US ARE STUCK WITH MVS 3.8, SO NON-SDB CODE ADDED     GP12006         
*                                                                               
*  IN ANY CASE, DCB CONFLICTS ARE HEREBY DECREED TO BE USER ERROR(S).           
*                                                                               
OKUT2    OI    STATUS,UT2          SYSUT2 IS OPEN                               
         TM    RECFM(R5),X'C0'     OUTPUT RECFM=U?                              
         BO    UNDEFBAD            YES, INVALID                                 
         SPACE                                                                  
         LA    R0,7                                                             
         AH    R0,BLKSI(,R5)                                                    
         SRL   R0,3                                                             
         SLL   R0,4                DOUBLE ROUNDED-UP BLKSIZE                    
         ST    R0,FREEM                                                         
         GETMAIN R,LV=(0)                                                       
         ST    R1,FREEM+4                                                       
         ST    R1,PUTPDSX          BUFFER 1 ADDRESS                             
         XC    0(4,R1),0(R1)       RESET BDW 1                                  
         LR    R0,R1                                                            
         AH    R0,DWLOT            ALLOW FOR OUTPUT BDW                         
         ST    R0,PUTPDSX+4        BUFFER 1 ADDRESS TO USE NEXT                 
         AH    R1,BLKSI(,R5)                                                    
         ST    R1,PUTPDSX+8        PAST END OF BUFFER 1                         
         LA    R1,7(,R1)                                                        
         SRL   R1,3                                                             
         SLL   R1,3                ALIGN BUFFER 2                               
         ST    R1,PUTPDSY          BUFFER 2 ADDRESS                             
         XC    0(4,R1),0(R1)       RESET BDW 2                                  
         LR    R0,R1                                                            
         AH    R0,DWLOT            ALLOW FOR OUTPUT BDW                         
         ST    R0,PUTPDSY+4        BUFFER 2 ADDRESS TO USE NEXT                 
         AH    R1,BLKSI(,R5)                                                    
         ST    R1,PUTPDSY+8        PAST END OF BUFFER 2                         
         LA    R1,PDSDECB1                                                      
         MVC   0(PDSDECBL,R1),PDSDECB                                           
         ST    R1,PUTPDSX+12                                                    
         LA    R1,PDSDECB2                                                      
         MVC   0(PDSDECBL,R1),PDSDECB                                           
         ST    R1,PUTPDSY+12                                                    
         SPACE                                                                  
         MVC   LINE,LINE-1                                                      
         MVC   MEMBER,=CL8' '      BLANK OUT MEMBER NAME                        
         SR    R1,R1                                                            
         ST    R1,SEQ                                                           
         ST    R1,UPR                                                           
         BAL   R14,REPORT          FORCE A HEADER                               
         SPACE                                                                  
         SR    R15,R15                                            .VTO.         
         ST    R15,VTOSTAT                                        .VTO.         
         ST    R15,VTOEOF                                         .VTO.         
         LA    R3,VTODCBW                                         .VTO.         
         DEVTYPE DCBDDNAM-IHADCB(R3),DOUBLE                       .VTO.         
         LTR   R15,R15                                            .VTO.         
         BNZ   VTOSET                                             .VTO.         
         LA    R6,OPEN                                            .VTO.         
         MVI   0(R6),X'80'                                        .VTO.         
         OPEN  ((R3),INPUT),MF=(E,(R6))                           .VTO.         
         ST    R3,VTOSTAT                                         .VTO.         
VTOSET   EQU   *                                                  .VTO.         
         EJECT                                                                  
************************************************************                    
*                                                          *                    
*        READ AN INPUT RECORD                              *                    
*                                                          *                    
************************************************************                    
         SPACE                                                                  
READ     NI    FLAG1,255-FGNOCON   CHECK FOR UPDTE TRANSLATE    GP06315         
         GET   (R4)                                                             
         SPACE                                                                  
         ST    R1,RECAD            SAVE INPUT RECORD ADDRESS                    
         LA    R0,1                                                             
         A     R0,COUNTIN                                                       
         ST    R0,COUNTIN                                                       
         MVC   LINE,LINE-1                                                      
         LR    R15,R1              POINT TO INPUT RECORD                        
         AH    R15,DWLIN           POINT TO INPUT DATA                          
         CLC   CTLMODEL(2),0(R15)  CONTROL STATEMENT?           GP06315         
         BNE   COPY                NO                                           
         SR    R0,R0               YES,                           .VTO.         
         ST    R0,COUNTIN           RESET COUNTER                 .VTO.         
         OI    FLAG1,FGNOCON       NO UPDTE TRANSLATE           GP06315         
         SPACE                                                                  
************************************************************                    
*                                                          *                    
*         PARSE THE CONTROL STATEMENT                      *                    
*                                                          *                    
************************************************************                    
         SPACE                                                                  
         MVI   INREC,C' '          CLEAR CONTROL RECORD HOLD AREA               
         MVC   INREC+1(79),INREC                                                
         LA    R14,80-1            GET LENGTH CODE IF FIXED LEN   C0909         
         CR    R1,R15              FIXED LENGTH RECORDS?                        
         BE    COPYCNTL            YES, AND MINIMUM LRECL IS 80                 
         SLR   R3,R3               NO                                           
         ICM   R3,3,0(R1)          GET RECORD LENGTH                            
         SH    R3,=H'5'            GET DATA LENGTH CODE                         
         CR    R3,R14              IS RECORD TOO LONG FOR INREC?                
         BH    COPYCNTL            YES                                          
         LR    R14,R3              NO, USE ACTUAL DATA LENGTH                   
COPYCNTL EX    R14,LOADECHO        COPY CONTROL STATEMENT IMAGE                 
         LA    R15,INREC           POINT TO COLUMN 1                            
         LA    R3,80-1             LENGTH CODE OF CONTROL STMT    C0909         
         LA    R6,ODL              POINT TO OPERAND DESCRIPTOR LIST             
         XC    0(ODLL,R6),0(R6)    ZERO THE ODL                                 
         SR    R1,R1               ENSURE HI ORDER BYTE ZERO                    
         LA    R0,ODLL/8-1         NUMBER OF ENTRIES IN O.D.L.                  
*                                  MINUS 1 (LAST ODE WILL REMAIN ZERO)          
LOOP     XC    0(8,R6),0(R6)       ZERO THE OPERAND DESCRIPTOR ENTRY            
         EX    R3,TRTNONBL         FIND A NONBLANK                              
         BZ    DONE                BRANCH IF ALL BLANKS                         
         LR    R14,R1              GET ADDRESS OF STRING                        
         SR    R14,R15             GET LENGTH OF PRECEDING BLANKS               
         SR    R3,R14              GET LENGTH OF REMAINING TEXT                 
         LR    R15,R1              GET ADDRESS OF NONBLANK                      
         EX    R3,TRTBLANK         FIND A BLANK                                 
         BZ    LAST                BRANCH IF NOT FOUND                          
         LR    R14,R1              GET ADDRESS OF BLANK                         
         SR    R14,R15             GET LENGTH OF FIELD                          
         OI    6(R6),X'80'         OPERAND PRESENT                              
         ST    R15,0(,R6)          ADDRESS OF OPERAND                           
         STH   R14,4(,R6)          LENGTH OF OPERAND                            
         SR    R3,R14              GET LENGTH CODE OF REMAINING TEXT            
         BZ    DONE                BRANCH IF ONE TRAILING BLANK                 
         LA    R6,8(,R6)           POINT TO NEXT O.D.E.                         
         LR    R15,R1              POINT TO BLANK                               
         BCT   R0,LOOP                                                          
         B     DONE                                                             
LOADECHO MVC   INREC(0),0(R15)     <<< EXECUTED >>>                             
TRTNONBL TRT   0(0,R15),TABNONBL   <<< EXECUTED >>>                             
TRTBLANK TRT   0(0,R15),TABBLANK   <<< EXECUTED >>>                             
LAST     LA    R14,1(,R3)          GET LENGTH                                   
         OI    6(R6),X'80'         OPERAND PRESENT                              
         ST    R15,0(,R6)          ADDRESS OF OPERAND                           
         STH   R14,4(,R6)          LENGTH OF OPERAND                            
DONE     DS    0H                                                               
* --- >                                          JAN 2017 < --- *               
*       IF ODE4 (4TH PARAMETER) CONTAINS AN 8-CHARACTER         *               
*       USERID, THEN THERE IS NO SPACE BETWEEN IT AND THE       *               
*       SECONDS FIELD.  THEREFORE ODE5, IF IT EXISTS, REALLY    *               
*       CONTAINS 0DE6.  BUT THE QUANTITIES IN ODE5 AND ODE4     *               
*       THEN HAVE TO BE ADJUSTED, IF THAT IS THE CASE.          *               
* --- >                                                   < --- *               
*--------->                        TEST DISPLAY BELOW                           
         AIF   (&NODIAG).NODIAG1                                                
         MVC   LINE,LINE-1                                                      
         BAL   R14,REPORT                                                       
.NODIAG1 ANOP                                                                   
*--------->                        TEST DISPLAY ABOVE                           
         TM    ODE4+6,X'80'        ANY TEXT IN COMMENT FIELD?                   
         BZ    BASIC (NOT COPY)    NO, ONLY BASIC IEBUPDTE DATA HERE            
         LH    R15,ODE4+4          GET LENGTH OF STRING                         
         LA    R0,50               GET LENGTH IF SS ADDED TO STRING             
         CR    R15,R0              IS SS GLUED ON TO 8-CHAR USER ID?            
         BNE   OP2GOON1            NO, SO NO PARSING HASSLES                    
*--------->                        TEST DISPLAY BELOW                           
         AIF   (&NODIAG).NODIAG2                                                
         MVC   LINE,LINE-1                                                      
         HEX   LINE+1,8,ODE3                                                    
         HEX   LINE+21,8,ODE4                                                   
         HEX   LINE+41,8,ODE5                                                   
         HEX   LINE+61,8,ODE6                                                   
         BAL   R14,REPORT                                                       
.NODIAG2 ANOP                                                                   
*--------->                        TEST DISPLAY ABOVE                           
*                                                                               
OPTGOON0 DS    0H                  ODE4 ALSO DESCRIBES ODE5'S DATA              
         MVC   ODE7(8),ODE6        SLIDE OPERAND INDICATORS UP                  
         MVC   ODE6(8),ODE5        SLIDE PREVIOUS ONE UP TOO                    
         MVI   ODE5+6,X'80'        SHOW ODE5 OCCUPIED                           
         LA    R0,2                GET THE LENGTH OF SECONDS DIGITS             
         STH   R0,ODE5+4           SET LENGTH INTO ODE                          
         L     R1,ODE4             POINT ISPF STATS STRING                      
         LA    R1,48(,R1)          POINT PAST IT TO GET TO SS                   
         ST    R1,ODE5             SAVE ADDRESS OF SECONDS DIGITS               
         MVI   ODE4+5,48           REDUCE STATS LENGTH TO REMOVE SS             
OP2GOON1 DS    0H                                                               
* --- >             END OF THIS OPERATION        JAN 2017 < --- *               
*--------->                        TEST DISPLAY BELOW                           
         AIF   (&NODIAG).NODIAG3                                                
         MVC   LINE,LINE-1                                                      
         HEX   LINE+1,8,ODE3                                                    
         HEX   LINE+21,8,ODE4                                                   
         HEX   LINE+41,8,ODE5                                                   
         HEX   LINE+61,8,ODE6                                                   
         BAL   R14,REPORT                                                       
.NODIAG3 ANOP                                                                   
*--------->                        TEST DISPLAY ABOVE                           
BASIC    DS    0H                                                               
         SPACE                                                                  
************************************************************                    
*                                                          *                    
*         DETERMINE TYPE OF CONTROL STATEMENT              *                    
*                                                          *                    
************************************************************                    
         SPACE                                                                  
         LA    R6,ODE1             POINT TO FIRST O.D.E.                        
         TM    6(R6),X'80'         ANYTHING PRESENT?                            
         BZ    COPY                BRANCH IF WHOLE STATEMENT BLANK              
         L     R1,0(,R6)           POINT TO FIRST STRING                        
         LH    R15,4(,R6)          GET LENGTH OF STRING                         
         LA    R0,3                MAX VALID LENGTH                             
         CR    R15,R0              IS STRING TOO LONG ?                         
         BH    COPY                BRANCH IF TOO LONG                           
         SLL   R15,2               MULTIPLY LENGTH BY 4                         
         B     *(R15)              BRANCH TO ONE OF NEXT 7                      
         B     COPY                1 CHAR                                       
         B     CONTROL             2 CHAR                                       
         B     COPY                3 CHAR                                       
         SPACE                                                                  
COPY     DS    0H                                                               
         CLI   MEMBER,C' '         HAS A ./ADD RECORD BEEN READ?                
         BE    COPYERR             NO, PRINT A MESSAGE                          
         LA    R1,1                                                             
         A     R1,SEQ              COUNT THE RECORDS IN THIS MEMBER             
         ST    R1,SEQ                                                           
         SPACE                                                                  
         TM    FLAG1,SELECT        ARE WE SELECTING THIS MEMBER?                
         BZ    READ                NO, BRANCH                                   
         SPACE                                                                  
*        MVC   INREC+72(8),=C'00000000'                                         
*        CVD   R1,DOUBLE                                                        
*        OI    DOUBLE+7,X'0F'                                                   
*        UNPK  INREC+72(5),DOUBLE+5(3)                                          
         SPACE                                                                  
         LH    R1,LRECL(,R4)       GET INPUT LRECL                              
         L     R14,RECAD           POINT TO THE INPUT RECORD                    
         CLI   DWLIN+1,0           FIXED-LENGTH INPUT?                          
         BE    *+8                 YES                                          
         ICM   R1,3,0(R14)         NO, GET RECORD LENGTH                        
         SH    R1,DWLIN            GET DATA LENGTH                              
         CH    R1,=H'1'            LONG ENOUGH?                                 
         BNH   NOTUPDTE            NO                                           
         AH    R14,DWLIN           POINT TO DATA OF INPUT RECORD                
         TM    FLAG1,FGNOCON       NO UPDTE TRANSLATE ?         GP06315         
         BNZ   NOTUPDTE            CORRECT; SKIP AROUND         GP06315         
         CLC   0(2,R14),UPDTE      IS THIS XX OF UPDTE(XX)?                     
         BNE   NOTUPDTE            NO, SKIP MVC                                 
         TM    FLAG1,CK3           WAS CK3 SPECIFIED?           OCT2015         
         BZ    NOTCK3              NO                           OCT2015         
         CLI   2(R14),C' '         YES, IS COLUMN 3 BLANK?      OCT2015         
         BNE   NOTUPDTE            NO, DON'T CHANGE IT          OCT2015         
NOTCK3   EQU   *                                                OCT2015         
         BAL   R1,VTOTEST          YES, CHECK FOR EXCEPTION       .VTO.         
         LTR   R15,R15             IS IT IN EXCEPTION LIST        .VTO.         
         BZ    NOTEXCEP            NOT IN EXCEPTION LIST. GO ON.  .SBG.         
         ST    R0,SAVER0           COUNT EXCEPTION RECORDS        .SBG.         
         LA    R0,1                INCREMENT                      .SBG.         
         A     R0,UPS                SYSUPLOG                     .SBG.         
         ST    R0,UPS                  RECORD COUNT               .SBG.         
         L     R0,SAVER0           RESTORE WORK REGISTER          .SBG.         
         B     NOTUPDTE            EXCEPTIONS ARE NOT UPDATED.    .SBG.         
NOTEXCEP DS    0H                  CARD IS NOT ON EXCEPTION LIST  .SBG.         
         MVC   0(2,R14),=C'./'     YES, CHANGE TO ./                            
         LA    R1,1                                                             
         A     R1,UPR              COUNT THE MODIFIED RECORDS                   
         ST    R1,UPR                                                           
NOTUPDTE DS    0H                                                               
         SPACE                                                                  
         BAL   R14,PUTPDS                                                       
         B     READ                                                             
         SPACE                                                                  
VTOTEST  L     R15,VTOSTAT         IS THERE A SYSUPLOG DD?        .VTO.         
         LTR   R15,R15             IF NOT                         .VTO.         
         BZR   R1                  THEN RETURN NOT-IN-LIST        .VTO.         
         STM   R14,R3,VTOSAVE      SAVE REGS                      .VTO.         
         L     R2,VTOPREV          POINT TO LAST SPARE RECORD     .VTO.         
         LTR   R2,R2               IF THIS IS FIRST TIME          .VTO.         
         BZ    VTOGET              GO READ FIRST SPARE RECORD     .VTO.         
VTONEXT  CLC   0(8,R2),MEMBER      DOES NAME MATCH MEMBER?        .VTO.         
         BE    VTONUM              YES, CHECK THE NUMBER          .VTO.         
         BL    VTOGET              NO, NEED TO READ MORE SPARE    .VTO.         
         B     VTONOT              NO, SPARE MEMBER IS BEYOND     .VTO.         
VTONUM   PACK  DOUBLE,9(7,R2)      GET RECORD NUMBER              .VTO.         
         CVB   R0,DOUBLE           TO BINARY                      .VTO.         
         C     R0,COUNTIN          IF IT MATCHES CURRENT RECORD   .VTO.         
         BE    VTOMATCH            RETURN MATCH FOUND             .VTO.         
         BH    VTONOT              IF IT'S TOO HIGH, NO MATCH     .VTO.         
VTOGET   CLI   VTOEOF+3,0          IF ALL OF SPARE HAS BEEN READ  .VTO.         
         BNE   VTONOT              THEN RETURN NOT-IN-LIST        .VTO.         
         L     R3,VTOSTAT          POINT TO VTODCBW               .VTO.         
         GET   (R3)                                               .VTO.         
VTOGOT   CLI   VTOEOF+3,0          IF GET REACHED EOF             .VTO.         
         BNE   VTONOT              THEN RETURN NOT-IN-LIST        .VTO.         
         LR    R2,R1               POINT R2 TO RECORD             .VTO.         
         ST    R2,VTOPREV          SAVE ADDRESS OF RECORD         .VTO.         
         B     VTONEXT                                            .VTO.         
VTOMATCH LM    R14,R3,VTOSAVE                                     .VTO.         
         LA    R15,1               THERE IS A MATCH               .VTO.         
         BR    R1                                                 .VTO.         
VTONOT   LM    R14,R3,VTOSAVE                                     .VTO.         
         SR    R15,R15             THERE IS NO MATCH              .VTO.         
         BR    R1                                                 .VTO.         
         SPACE                                                                  
COPYERR  TM    STATUS,COPYM        HAS MESSAGE BEEN ISSUED?                     
         BO    READ                YES, BRANCH                                  
         OI    STATUS,COPYM                                                     
         MVC   LINE,LINE-1                                                      
         MVC   LINE+1(24),=C'SKIPPING FOR ./ ADD CARD'                          
         MVC   LINE+1+13(2),CTLMODEL   BUT USE REAL CTL PAIR    GP06315         
         BAL   R14,REPORT                                                       
         B     READ                                                             
         EJECT                                                                  
************************************************************                    
*                                                          *                    
*         WRITE A LOGICAL RECORD TO THE PDS                *                    
*                                                          *                    
************************************************************                    
         SPACE                                                                  
PUTPDS   ST    R14,PUTPDSR         SAVE RETURN ADDRESS                          
PUTREDO  LM    R6,R9,PUTPDSX       FIRST, CURRENT, END, DECB                    
*                                                                               
*         ALLOW OUTPUT RECFM TO BE INDEPENDENT OF INPUT RECFM   MAY2009         
*                                                                               
*         1. GET INPUT DATA ADDRESS AND LENGTH                  MAY2009         
*                                                                               
         L     R14,RECAD           POINT TO THE INPUT RECORD                    
         LH    R15,LRECL(,R4)      GET LRECL OF INPUT                           
         CLI   DWLIN+1,0           FIXED-LENGTH INPUT RECORDS?                  
         BE    *+8                 YES, NO RDW PRESENT                          
         ICM   R15,3,0(R14)        NO, GET INPUT RECORD LENGTH FROM RDW         
         AH    R14,DWLIN           POINT TO INPUT RECORD DATA                   
         SH    R15,DWLIN           GET INPUT RECORD DATA LENGTH                 
*                                                                               
*         2. BRANCH TO LOGIC PATH BASED ON OUTPUT RECFM         MAY2009         
*                                                                               
         CLI   DWLOT+1,0           FIXED-LENGTH OUTPUT RECORDS?                 
         BNE   PUTVAR              NO                                           
*                                                                               
*         3. BLOCK ANOTHER FIXED-LENGTH RECORD IF IT FITS       MAY2009         
*                                                                               
         LH    R1,LRECL(,R5)       GET LRECL OF OUTPUT PDS                      
         LR    R0,R7               COPY TARGET FOR THIS RECORD                  
         AR    R7,R1               POINT TO NEXT "CURRENT" RECORD               
         CR    R7,R8               WILL THIS RECORD FIT IN THIS BLOCK?          
         BH    PUTPDS1             NO, ISSUE WRITE AND PROCURE BUFFER           
         ST    R7,PUTPDSX+4        YES, SAVE TARGET FOR NEXT RECORD             
         B     PUTPAD              GO LOAD THE RECORD'S DATA                    
*                                                                               
*         4. BLOCK VARIABLE-LENGTH RECORD IF IT FITS            MAY2009         
*                                                                               
PUTVAR   LA    R1,4(,R15)          GET IDEAL OUTPUT RECORD LENGTH               
         CLI   DWLIN+1,0           FIXED-LENGTH INPUT?                          
         BNE   TRAILOK             NO, SKIP TRAILING BLANKS DISCARD             
         LA    R1,0(R15,R14)       POINT PAST INPUT RECORD DATA                 
TRAILOOP BCTR  R1,0                BACK UP A BYTE                               
         CR    R1,R14              BACK TO START OF RECORD?                     
         BNH   TRAILMIN            YES, USE MINIMUM LENGTH                      
         CLI   0(R1),C' '          TRAILING BLANK?                              
         BE    TRAILOOP            YES, KEEP BACKING UP                         
         LA    R1,1+4(,R1)         NO, POINT PAST LAST NON-BLANK + RDW          
         SR    R1,R14              GET NEW IDEAL OUTPUT RECORD LENGTH           
         B     TRAILOK             DESIRED LENGTH NOW KNOWN                     
TRAILMIN LA    R1,5                MINIMUM IS RDW + 1 DATA BYTE                 
TRAILOK  CH    R1,LRECL(,R5)       LENGTH LONGER THAN OUTPUT LRECL?             
         BNH   *+8                 NO, USE THIS LENGTH                          
         LH    R1,LRECL(,R5)       YES, REDUCE LENGTH TO OUTPUT LRECL           
         LR    R0,R7               COPY TARGET FOR THIS RECORD                  
         AR    R7,R1               POINT TO NEXT "CURRENT" RECORD               
         CR    R7,R8               WILL THIS RECORD FIT IN THIS BLOCK?          
         BH    PUTPDS1             NO, ISSUE WRITE AND PROCURE BUFFER           
         ST    R7,PUTPDSX+4        YES, SAVE TARGET FOR NEXT RECORD             
         SR    R7,R6               GET NEW SIZE OF THIS BLOCK                   
         STH   R7,0(,R6)           SET INTO BDW                                 
         LR    R7,R0               POINT TO RECORD TO LOAD                      
         STCM  R1,3,0(R7)          SET RECORD LENGTH INTO RDW                   
         STCM  R1,12,2(R7)         CLEAR REST OF RDW                            
         AH    R0,DWLOT            POINT PAST RDW                               
         SH    R1,DWLOT            GET DATA LENGTH AFTER RDW                    
*                                                                               
*         5. LOAD THE DATA INTO THE NEW RECORD                  MAY2009         
*                                                                               
PUTPAD   ICM   R15,8,LINE-1        LOAD BLANK PAD CHARACTER                     
         MVCL  R0,R14              MOVE RECORD INTO BLOCK                       
         L     R14,PUTPDSR         RESTORE RETURN ADDRESS                       
         BR    R14                 RETURN                                       
PUTPDS1  TM    STATUS,DECB         ANY WRITES OUTSTANDING?                      
         BZ    PUTPDS2             NO, BRANCH                                   
         L     R1,PUTPDSY+12       GET LAST DECB                                
         CHECK (1)                                                              
         TM    FLAG1,IOERR         I/O ERROR?                   FEB2008         
         BO    IOERROR             YES                          FEB2008         
PUTPDS2  DS    0H                                                               
         WRITE (R9),SF,(R5),(R6),MF=E                                           
         MVC   PUTPDSX(16),PUTPDSY SWAP                                         
         STM   R6,R9,PUTPDSY       SWAP                                         
         AH    R6,DWLOT            ALLOW FOR OUTPUT BDW                         
         ST    R6,PUTPDSY+4                                                     
         OI    STATUS,DECB                                                      
         B     PUTREDO             REDRIVE WITH BUFFER NOW AVAILABLE            
         EJECT                                                                  
************************************************************                    
*                                                          *                    
*         PROCESS EACH ./ STATEMENT                        *                    
*                                                          *                    
************************************************************                    
         SPACE                                                                  
CONTROL  BAL   R14,STOW            FINISH PREVIOUS MEMBER                       
         MVC   MEMBER,=CL8' '      RESET                                        
         NI    STATUS,255-COPYM     RESET                                       
         NI    STATUS,255-SPF        RESET                                      
         NI    STATUS,255-SSI         RESET                                     
         SR    R1,R1                   RESET                                    
         ST    R1,SEQ                   RESET                                   
         ST    R1,UPR                    RESET                                  
         ST    R1,UPS                     RESET                   .SBG.         
         NI    FLAG1,255-SELECT            RESET                                
         SPACE                                                                  
         MVC   LINE,LINE-1         PRINT                                        
         MVC   LINE+1(80),INREC     THE                                         
         BAL   R14,REPORT            ./ADD STATEMENT                            
         CLC   CTLMODEL,0(R1)      ./ ADD NAME OR XX ADD        GP06315         
         BE    SIMPLE                                                           
         LA    R6,ODE2             POINT TO SECOND O.D.E.                       
         TM    6(R6),X'80'         ANYTHING PRESENT?                            
         BZ    COPY                BRANCH IF NO OPERAND                         
         CLC   4(2,R6),=H'3'       LENGTH OF 'ADD'?                             
         BNE   NOTADD                                                           
         L     R1,0(,R6)           POINT TO OPERAND                             
         CLC   0(3,R1),=C'ADD'                                                  
         BNE   COPY                                                             
         SPACE                                                                  
************************************************************                    
*                                                          *                    
*         PROCESS THE ./ ADD STATEMENT                     *                    
*                                                          *                    
************************************************************                    
         SPACE                                                                  
SIMPLE   MVC   MEMBER,=CL8' '                                                   
         XC    MEMUSER,MEMUSER     CLEAR USERDATA                 A0909         
         MVI   ZEROAREA,C'0'       GET SOME UNPACKED ZEROS        A0909         
         MVC   ZEROAREA+1(L'ZEROAREA-1),ZEROAREA                  A0909         
         MVC   SPFUSER,=CL8' '     PAD WITH BLANKS                M0909         
         MVC   SPFBLANK,=CL8' '    INITIALIZE BLANKS              A0909         
         LA    R6,ODE3             POINT TO FIRST OPERAND DESCRIPTOR            
         TM    6(R6),X'80'         ANYTHING PRESENT?                            
         BZ    COPY                BRANCH IF NO OPERAND                         
         LH    R15,4(,R6)          GET LENGTH OF STRING                         
         SH    R15,=H'5'           LENGTH OF 'NAME='                            
         BNP   OP2NAME             BRANCH IF TOO SHORT FOR NAME=                
         L     R1,0(,R6)           POINT TO OPERAND                             
         CLC   0(5,R1),=C'NAME='   IS IT NAME= ?                                
         BNE   OP2NAME             NO, ITS PROBABLY SSI=                        
         LA    R1,5(,R1)                                                        
         LA    R0,8                MAX VALID LENGTH                             
         CR    R15,R0              IS STRING TOO LONG ?                         
         BH    COPY                BRANCH IF TOO LONG                           
         NI    FLAG1,255-SELECTAL  NEW REAL MEMBER              MAY2009         
         MVC   MEMBER,=CL8' '                                                   
         BCTR  R15,0               GET LENGTH MINUS 1 FOR EX                    
         B     *+10                                                             
         MVC   MEMBER(0),0(R1)     <<< EXECUTED >>>                             
         EX    R15,*-6             MOVE NAME TO MEMBER NAME                     
         BAL   R14,NAMETEST        CHECK (OR NOT) NAME VALIDITY GP12006         
         CLI   MEMSEL,C' '         ARE WE SELECTING ALL MEMBERS?                
         BE    SELMEM1             YES, BRANCH                                  
         BAL   R14,MEMMATCH        NO, IS THIS A SELECTED MEMBER?               
         BNE   *+8                 NO                                           
SELMEM1  OI    FLAG1,SELECT        INDICATE THIS MEMBER SELECTED                
         B     OP2SSI                                                           
*                                                                               
*              SSI= WAS PROBABLY SPECIFIED FIRST,                               
*              SEE IF NAME= IS SECOND                                           
*                                                                               
OP2NAME  LA    R6,ODE4             POINT TO SECOND OPERAND                      
         TM    6(R6),X'80'         ANYTHING PRESENT?                            
         BZ    COPY                BRANCH IF NO OPERAND                         
         LH    R15,4(,R6)          GET LENGTH OF STRING                         
* --- >                                                                         
         SH    R15,=H'5'           LENGTH OF 'NAME='                            
         BNP   COPY                BRANCH IF TOO SHORT FOR NAME=                
         L     R1,0(,R6)           POINT TO OPERAND                             
         CLC   0(5,R1),=C'NAME='                                                
         BNE   COPY                                                             
         LA    R1,5(,R1)                                                        
         LA    R0,8                MAX VALID LENGTH                             
         CR    R15,R0              IS STRING TOO LONG ?                         
         BH    COPY                BRANCH IF TOO LONG                           
         NI    FLAG1,255-SELECTAL  NEW REAL MEMBER              MAY2009         
         MVC   MEMBER,=CL8' '                                                   
         BCTR  R15,0               GET LENGTH MINUS 1 FOR EX                    
         B     *+10                                                             
         MVC   MEMBER(0),0(R1)     <<< EXECUTED >>>                             
         EX    R15,*-6             MOVE NAME TO MEMBER NAME                     
         BAL   R14,NAMETEST        IS MEMBER NAME VALID         GP12006         
         CLI   MEMSEL,C' '         ARE WE SELECTING ALL MEMBERS?                
         BE    SELMEM2             YES, BRANCH                                  
         BAL   R14,MEMMATCH        NO, IS THIS A SELECTED MEMBER?               
         BNE   *+8                 NO                                           
SELMEM2  OI    FLAG1,SELECT        INDICATE THIS MEMBER SELECTED                
         SPACE                                                                  
         LA    R6,ODE3             POINT TO FIRST OPERAND                       
         LH    R15,4(,R6)          LENGTH                                       
         L     R6,0(,R6)           POINT TO OPERAND                             
         CH    R15,=H'12'          IS LENGTH RIGHT FOR SSI=XXXXXXXX?            
         BNE   NOUSER              NO, IGNORE FIRST OPND, NO USER DATA          
         CLC   0(4,R6),=C'SSI='    IS IT SSI= ?                                 
         BE    SSICVT              YES, GO PROCESS SSI                          
         B     NOUSER              NO, IGNORE FIRST OPND, NO USER DATA          
*                                                                               
*              NAME= WAS SPECIFIED FIRST                                        
*              CHECK FOR SSI= OR SPF STATS                                      
*                                                                               
OP2SSI   LA    R6,ODE4             POINT TO 2ND OPERAND DESCRIPTOR              
         TM    6(R6),X'80'         ANYTHING PRESENT?                            
         BZ    NOUSER              NO USER DATA TO BE STOWED                    
         LH    R15,4(,R6)          LENGTH                                       
         L     R6,0(,R6)           POINT TO OPERAND                             
         CH    R15,=H'12'          IS LENGTH RIGHT FOR SSI=XXXXXXXX?            
         BNE   NOSSI               NO, BRANCH                                   
         CLC   0(4,R6),=C'SSI='    IS IT SSI= ?                                 
         BNE   NOSSI               NO, BRANCH                                   
SSICVT   MVC   MEMUSER(8),4(R6)    MOVE 8 HEX CHARACTERS                        
         LA    R1,MEMUSER          POINT TO DATA TO BE CONVERTED                
         LA    R0,4                LENGTH/2 OF DATA TO BE CONVERTED             
         BAL   R14,PACK            CONVERT HEX TO BINARY                        
         OI    STATUS,SSI          SET FLAG FOR STOW                            
         B     READ                                                             
NOSSI    DS    0H                                                               
         MVI   SKIPFLG,X'00'       RESET SKIP FLAG            SBG 02/00         
         CLI   12(R6),C'-'         EXTRA 2 NUMBERS IN CRDATE? SBG 02/00         
         BNE   TESTOLD             NOT STARTOOL COMBINE       SBG 02/00         
         MVI   SKIPFLG,X'01'       SET SKIP FLAG              SBG 02/00         
         B     TESTNEW             TEST NEW FORMAT            SBG 02/00         
TESTOLD  DS    0H                  SAME CODE AS BEFORE        SBG 02/00         
         SH    R15,=H'41'          MINIMUM LENGTH 41                            
         BM    NOSPF                                                            
         CH    R15,=H'7'           ID LENGTH CODE MAY BE 0 TO 6   C1701         
         BH    NOSPF               TOTAL LENGTH EXCEEDS 50                      
         CLI   4(R6),C'-'                                                       
         BNE   NOSPF                                                            
         CLI   10(R6),C'-'                                                      
         BNE   NOSPF                                                            
         CLI   16(R6),C'-'                                                      
         BNE   NOSPF                                                            
         CLI   21(R6),C'-'                                                      
         BNE   NOSPF                                                            
         CLI   27(R6),C'-'                                                      
         BNE   NOSPF                                                            
         CLI   33(R6),C'-'                                                      
         BNE   NOSPF                                                            
         CLI   39(R6),C'-'                                                      
         BNE   NOSPF                                                            
         B     TESTNUM             TEST NUMERICS OLD WAY      SBG 02/00         
TESTNEW  DS    0H                  TEST FOR NEW FORMAT        SBG 02/00         
         SH    R15,=H'45'          MINIMUM LENGTH 45          SBG 02/00         
         BM    NOSPF                                          SBG 02/00         
         CH    R15,=H'9'        ID LENGTH CODE MAY BE 0 TO 9  SBG 02/00         
         BH    NOSPF               TOTAL LENGTH EXCEEDS 54    SBG 02/00         
         CLI   4(R6),C'-'                                     SBG 02/00         
         BNE   NOSPF                                          SBG 02/00         
         CLI   12(R6),C'-'                                    SBG 02/00         
         BNE   NOSPF                                          SBG 02/00         
         CLI   20(R6),C'-'                                    SBG 02/00         
         BNE   NOSPF                                          SBG 02/00         
         CLI   25(R6),C'-'                                    SBG 02/00         
         BNE   NOSPF                                          SBG 02/00         
         CLI   31(R6),C'-'                                    SBG 02/00         
         BNE   NOSPF                                          SBG 02/00         
         CLI   37(R6),C'-'                                    SBG 02/00         
         BNE   NOSPF                                          SBG 02/00         
         CLI   43(R6),C'-'                                    SBG 02/00         
         BNE   NOSPF                                          SBG 02/00         
         B     TESTNUMN            TEST NUMERICS NEW WAY      SBG 02/00         
TESTNUM  DS    0H                                             SBG 02/00         
         USING XPF,R6                                         SBG 02/00         
         TRT   XPFVM,NUMERIC                                  SBG 02/00         
         BNZ   NOSPF                                                            
         TRT   XPFCREDT,NUMERIC                                                 
         BNZ   NOSPF                                                            
         TRT   XPFCHGDT,NUMERIC                                                 
         BNZ   NOSPF                                                            
         TRT   XPFHHMM,NUMERIC                                                  
         BNZ   NOSPF                                                            
         TRT   XPFCCNT,NUMERIC                                                  
         BNZ   NOSPF                                                            
         TRT   XPFICNT,NUMERIC                                                  
         BNZ   NOSPF                                                            
         TRT   XPFMOD,NUMERIC                                                   
         BNZ   NOSPF                                                            
         PACK  DOUBLE,XPFVM+0(2)   GET V OF V.M                                 
         CVB   R0,DOUBLE                                                        
         STC   R0,SPFVM                                                         
         PACK  DOUBLE,XPFVM+2(2)   GET M OF V.M                                 
         CVB   R0,DOUBLE                                                        
         STC   R0,SPFVM+1                                                       
         PACK  DOUBLE,XPFCREDT     GET YYDDD                                    
         OI    DOUBLE+7,X'0F'                                                   
         CLC   XPFCREDT(2),=C'66'  BELOW 19XX WINDOW?         DRK JUN98         
         BNL   *+8                 NO,  THEN 19XX             DRK JUN98         
         OI    DOUBLE+4,X'01'      YES, THEN 20XX             DRK JUN98         
         MVC   SPFCREDT,DOUBLE+4                                                
         PACK  DOUBLE,XPFCHGDT     GET YYDDD                                    
         OI    DOUBLE+7,X'0F'                                                   
         CLC   XPFCHGDT(2),=C'66'  BELOW 19XX WINDOW?         DRK JUN98         
         BNL   *+8                 NO,  THEN 19XX             DRK JUN98         
         OI    DOUBLE+4,X'01'      YES, THEN 20XX             DRK JUN98         
         MVC   SPFCHGDT,DOUBLE+4   DATE LAST MODIFIED                           
         PACK  DOUBLE,XPFHHMM                                                   
         L     R0,DOUBLE+4         GET 000HHMMC                                 
         SRL   R0,4                GET 0000HHMM                                 
         STH   R0,SPFHHMM          TIME LAST MODIFIED                           
         MVC   #CRNTSML,XPFCCNT    CURRENT SIZE                   C0909         
         MVC   #INITSML,XPFICNT    INITIAL SIZE                   C0909         
         MVC   #MODSML,XPFMOD      CHANGED SIZE                   C0909         
         EX    R15,XPFUIDLD        LOAD USERID                    C0909         
         B     ISSPF               GO PROCESS FURTHER             C0909         
XPFUIDLD MVC   SPFUSER(0),XPFUSER  <<< EXECUTED >>>               M0909         
         DROP  R6                  (XPF)                      SBG 02/00         
         USING XP2,R6                                         SBG 02/00         
XP2UIDLD MVC   SPFUSER(0),XP2USER  <<< EXECUTED >>>               M0909         
TESTNUMN DS    0H                                             SBG 02/00         
         TRT   XP2VM,NUMERIC                                  SBG 02/00         
         BNZ   NOSPF                                          SBG 02/00         
         TRT   XP2CREDT,NUMERIC                               SBG 02/00         
         BNZ   NOSPF                                          SBG 02/00         
         TRT   XP2CHGDT,NUMERIC                               SBG 02/00         
         BNZ   NOSPF                                          SBG 02/00         
         TRT   XP2HHMM,NUMERIC                                SBG 02/00         
         BNZ   NOSPF                                          SBG 02/00         
         TRT   XP2CCNT,NUMERIC                                SBG 02/00         
         BNZ   NOSPF                                          SBG 02/00         
         TRT   XP2ICNT,NUMERIC                                SBG 02/00         
         BNZ   NOSPF                                          SBG 02/00         
         TRT   XP2MOD,NUMERIC                                 SBG 02/00         
         BNZ   NOSPF                                          SBG 02/00         
         PACK  DOUBLE,XP2VM+0(2)   GET V OF V.M               SBG 02/00         
         CVB   R0,DOUBLE                                      SBG 02/00         
         STC   R0,SPFVM                                       SBG 02/00         
         PACK  DOUBLE,XP2VM+2(2)   GET M OF V.M               SBG 02/00         
         CVB   R0,DOUBLE                                      SBG 02/00         
         STC   R0,SPFVM+1                                     SBG 02/00         
         PACK  DOUBLE,XP2CREDT     GET YYDDD                  SBG 02/00         
         OI    DOUBLE+7,X'0F'                                 SBG 02/00         
         CLC   XP2CREDT(2),=C'66'  BELOW 19XX WINDOW?         DRK JUN98         
         BNL   *+8                 NO,  THEN 19XX             DRK JUN98         
         OI    DOUBLE+4,X'01'      YES, THEN 20XX             DRK JUN98         
         MVC   SPFCREDT,DOUBLE+4                              SBG 02/00         
         PACK  DOUBLE,XP2CHGDT     GET YYDDD                  SBG 02/00         
         OI    DOUBLE+7,X'0F'                                 SBG 02/00         
         CLC   XP2CHGDT(2),=C'66'  BELOW 19XX WINDOW?         DRK JUN98         
         BNL   *+8                 NO,  THEN 19XX             DRK JUN98         
         OI    DOUBLE+4,X'01'      YES, THEN 20XX             DRK JUN98         
         MVC   SPFCHGDT,DOUBLE+4   DATE LAST MODIFIED         SBG 02/00         
         PACK  DOUBLE,XP2HHMM                                 SBG 02/00         
         L     R0,DOUBLE+4         GET 000HHMMC               SBG 02/00         
         SRL   R0,4                GET 0000HHMM               SBG 02/00         
         STH   R0,SPFHHMM          TIME LAST MODIFIED         SBG 02/00         
         PACK  DOUBLE,XP2CCNT      SIZE                       SBG 02/00         
         CVB   R0,DOUBLE                                      SBG 02/00         
         STH   R0,SPFCCNT          CURRENT SIZE               SBG 02/00         
         PACK  DOUBLE,XP2ICNT      SIZE                       SBG 02/00         
         CVB   R0,DOUBLE                                      SBG 02/00         
         STH   R0,SPFICNT          INITIAL SIZE               SBG 02/00         
         PACK  DOUBLE,XP2MOD       MOD                        SBG 02/00         
         CVB   R0,DOUBLE                                      SBG 02/00         
         STH   R0,SPFMOD           LINES MODIFIED             SBG 02/00         
         MVC   #CRNTSML,XP2CCNT    CURRENT SIZE                   C0909         
         MVC   #INITSML,XP2ICNT    INITIAL SIZE                   C0909         
         MVC   #MODSML,XP2MOD      CHANGED SIZE                   C0909         
         EX    R15,XP2UIDLD        LOAD USERID                    C0909         
ISSPF    OI    STATUS,SPF          SET FLAG FOR STOW              C0909         
         DROP  R6                  (XP2)                      SBG 02/00         
*                                                                               
*              LOOK FOR EXTENSIONS - SECONDS IS A PRE-REQ         A0909         
*                                                                               
         TM    ODE5+6,X'80'        SECONDS PRESENT?               A0909         
         BNO   XSPFOK              NO, NO EXTENDED ISPF STATS     A0909         
         LA    R0,2                                               A0909         
         CH    R0,ODE5+4           LENGTH EXACTLY TWO?            A0909         
         BNE   XSPFOK              NO, CANNOT BE SECONDS          A0909         
         L     R15,ODE5            YES, POINT TO DATA             A0909         
         TRT   0(2,R15),NUMERIC    DECIMAL DIGITS?                A0909         
         BNZ   XSPFOK              NO, CANNOT BE SECONDS          A0909         
         CLI   0(R15),C'5'         YES, BUT IS IT LESS THAN 60?   A0909         
         BH    XSPFOK              NO, CANNOT BE SECONDS          A0909         
         ICM   R0,1,1(R15)         GET SECOND DIGIT               A0909         
         SLL   R0,4                SHIFT OUT ZONE                 A0909         
         ICM   R0,2,0(R15)         GET FIRST DIGIT                A0909         
         SRL   R0,4                GET NUMERICS IN ONE BYTE       A0909         
         STC   R0,SPFSECS          SAVE THE SECONDS VALUE         A0909         
         TM    ODE6+6,X'80'        ANYTHING ELSE PRESENT?         A0909         
         BNO   XSPFOK              NO, NO EXTENDED ISPF STATS     A0909         
         LA    R0,8                                               A0909         
         CH    R0,ODE6+4           AT LEAST EIGHT NON-BLANKS?     A0909         
         BH    XSPFOK              NO, CANNOT BE EXTENSIONS       A0909         
         L     R15,ODE6            YES, POINT TO DATA             A0909         
         TRT   0(8,R15),NUMERIC    EIGHT DECIMAL DIGITS?          A0909         
         BNZ   XSPFOK              NO, CANNOT BE EXTENSIONS       A0909         
         MVC   #CRNT(3),0(R15)     FIRST 3 TO CURRENT             A0909         
         MVC   #INIT(3),3(R15)     NEXT 3 TO INITIAL              A0909         
         MVC   #MOD(2),6(R15)      LAST 2 TO MODIFIED             A0909         
         OI    SPFFLAGS,SPFXSTAT   FLAG NEED EXTENDED STATS       A1701         
*                                                                               
*              NOTE THAT EXTENDED ISPF STATS CAN BE STOWED        A0909         
*              EVEN IF THE COUNTER HIGH-ORDER EXTENSION           A0909         
*              FIELD IS NOT PRESENT IN THE INPUT RECORD.          A0909         
*                                                                               
*              IF AN ORIGINAL 5-DIGIT COUNTER HAS A VALUE         A0909         
*              OVER 65535 THEN EXTENDED ISPF STATS WILL           A0909         
*              BE STOWED.                                         A0909         
*                                                                               
*              THE CURRENT RECORD COUNTER IS EFFECTIVELY          A0909         
*              IGNORED BY PDSLOAD BECAUSE THIS FIELD IS SET       A0909         
*              FROM THE NUMBER OF RECORDS WRITTEN TO THE          A0909         
*              MEMBER BY PDSLOAD.  BUT HAVING THE CURRENT         A0909         
*              RECORD COUNT IN THE SEQUENTIAL FILE IS GOOD        A0909         
*              FOR AUDIT TRAIL AND HUMAN CONVENIENCE PURPOSES.    A0909         
*                                                                               
XSPFOK   PACK  DOUBLE,#CRNT                                       A0909         
         CVB   R0,DOUBLE                                          A0909         
         STH   R0,SPFCCNT          FIX CURRENT AT STOW TIME       A0909         
         PACK  DOUBLE,#INIT                                       A0909         
         CVB   R0,DOUBLE                                          A0909         
         ST    R0,SPFXICNT         SAVE FULLWORD COUNT            A0909         
         STH   R0,SPFICNT          SAVE HALFWORD COUNT            A0909         
         ICM   R0,3,SPFXICNT       COUNT TOO BIG FOR HALFWORD?    A0909         
         BZ    GETMOD              NO                             A0909         
         OI    SPFFLAGS,SPFXSTAT   YES, NEED EXTENDED STATS       A0909         
         MVC   SPFICNT,=X'FFFF'    SET HALFWORD COUNTER HIGH      A0909         
GETMOD   PACK  DOUBLE,#MOD                                        A0909         
         CVB   R0,DOUBLE                                          A0909         
         ST    R0,SPFXMOD          SAVE FULLWORD COUNT            A0909         
         STH   R0,SPFMOD           SAVE HALFWORD COUNT            A0909         
         ICM   R0,3,SPFXMOD        COUNT TOO BIG FOR HALFWORD?    A0909         
         BZ    NOSPF               NO                             A0909         
         OI    SPFFLAGS,SPFXSTAT   YES, NEED EXTENDED STATS       A0909         
         MVC   SPFICNT,=X'FFFF'    SET HALFWORD COUNTER HIGH      A0909         
NOSPF    DS    0H                                                               
NOUSER   DS    0H                                                               
         B     READ                                                             
         SPACE                                                                  
ILLMEM   MVC   MEMBER,=CL8' '      SUPPRESS COPY                                
         MVC   LINE,LINE-1         CLEAR OLD STUFF              GP12006         
         MVC   RESULT(38),=CL38'NOT STOWED *** INVALID MEMBER NAME ***'         
         OI    RC+1,8              NASTY ERROR                  GP12006         
         BAL   R14,REPORT          OUTPUT PRINT LINE            GP12006         
         B     COPY                                                             
         SPACE                                                                  
PACK     ST    R14,PACKR                                                        
         LR    R15,R1              REG 15 --> SENDING/RECEIVING FIELD           
         SR    R14,R14                                                          
         IC    R14,0(,R1)          REG 14  =  1ST CHAR                          
         CLI   0(R1),C'0'          NUMBER OR LETTER?                            
         BNL   *+8                 NUMBER - BRANCH                              
         LA    R14,57(,R14)        LETTER - CONVERT TO FA-FF                    
         SLL   R14,4               SHIFT LEFT 4 BITS                            
         STC   R14,0(,R15)         STORE THE LEFT HALF                          
         IC    R14,1(,R1)          REG 14  =  2ND CHAR                          
         CLI   1(R1),C'0'          NUMBER OR LETTER?                            
         BNL   *+8                 NUMBER - BRANCH                              
         LA    R14,57(,R14)        LETTER - CONVERT                             
         SLL   R14,28              SHIFT LEFT HALF TO OBLIVION                  
         SRL   R14,28              SHIFT BACK AGAIN                             
         STC   R14,1(,R15)         STORE RIGHT HALF                             
         OC    0(1,R15),1(R15)     'OR' RIGHT HALF OVER LEFT HALF               
         LA    R1,2(,R1)           INCREMENT SENDING FIELD                      
         LA    R15,1(,R15)         INCREMENT RECEIVING FLD                      
         BCT   R0,PACK+6           LOOP USING LENGTH IN REG 0                   
         L     R14,PACKR                                                        
         BR    R14                 EXIT                                         
         SPACE                                                                  
MEMMATCH STM   R14,R12,12(R13)     SAVE REGISTERS                               
         LA    R3,MEMBER           POINT TO MEMBER NAME                         
         LA    R4,MEMSEL           POINT TO SELECTION MASK                      
         LA    R0,8                GET MEMBER NAME LENGTH                       
MASKLOOP CLI   0(R4),C'*'          GENERIC CHARACTER MATCH?                     
         BE    MASKNEXT            YES, THIS CHARACTER MATCHES                  
         CLI   0(R4),C'?'          GENERIC CHARACTER MATCH?                     
         BE    MASKNEXT            YES, THIS CHARACTER MATCHES                  
         CLI   0(R4),C'%'          GENERIC CHARACTER MATCH?                     
         BE    MASKNEXT            YES, THIS CHARACTER MATCHES                  
         CLC   0(1,R4),0(R3)       SPECIFIC CHARACTER MATCH?                    
         BNE   MASKEXIT            NO, UNSUCCESSFUL MATCH                       
MASKNEXT LA    R3,1(,R3)           POINT TO NEXT BYTE OF ITEM                   
         LA    R4,1(,R4)           POINT TO NEXT BYTE OF MASK                   
         BCT   R0,MASKLOOP         TEST NEXT BYTE                               
MASKEXIT LM    R14,R12,12(R13)     RESTORE REGISTERS                            
         BR    R14                 RETURN TO CALLER                             
         SPACE 1                                                                
*---------------------------------------------------------------------*         
*   TEST MEMBER NAME VALIDITY, OR (DEFAULT) BYPASS CHECKS             *         
*---------------------------------------------------------------------*         
NAMETEST ICM   R15,15,@TRTTAB      MEMBER CHECKING ENABLED?     GP12006         
         BZR   R14                   NO; JUST RETURN            GP12006         
         TRT   MEMBER,0(R15)       IS MEMBER NAME VALID?        GP12006         
         BNZ   ILLMEM              NO, BRANCH                   GP12006         
         CLI   MEMBER,C' '         IS FIRST CHAR BLANK?         GP12006         
         BE    ILLMEM                YES; FAIL                  GP12006         
         LA    R15,CHARIBM         SET FOR STRICT TEST          GP12006         
         C     R15,@TRTTAB         IS STRICT TEST DESIRED ?     GP12006         
         BNER  R14                   NO; NAME PASSED            GP12006         
         CLI   MEMBER,C'0'         IS FIRST CHAR NUMERIC?       GP12006         
         BNL   ILLMEM                YES; FAIL                  GP12006         
*  N.B. EARLY VERSIONS OF THE READER/INTERPRETER ALLOWED HYPHEN/MINUS           
*       IN THE JCL. THE CHARIBM TABLE DOES NOT ALLOW FOR THAT.  GP12006         
*OS/360  CLI   MEMBER,C'-'         IS FIRST CHAR HYPHEN?        GP12006         
*OS/360  BE    ILLMEM                                           GP12006         
         BR    R14                 MEMBER ADHERES TO IBM JCL    GP12006         
         EJECT                                                                  
************************************************************                    
*                                                          *                    
*         PROCESS THE ./ ALIAS STATEMENT                   *                    
*                                                          *                    
************************************************************                    
         SPACE                                                                  
NOTADD   CLC   4(2,R6),=H'5'       LENGTH OF 'ALIAS'?                           
         BNE   COPY                                                             
         L     R1,0(,R6)           POINT TO OPERAND                             
         CLC   0(5,R1),=C'ENDUP'   END OF IEBUPDTE-LIKE INPUT?                  
         BE    EODUT1              YES, SIMULATE END-OF-FILE                    
         CLC   0(5,R1),=C'ALIAS'                                                
         BNE   COPY                                                             
         TM    FLAG1,SELECTAL      REAL MEMBER CREATED?         MAY2009         
         BZ    READ                NO, CANNOT MAKE ALIAS OF IT  MAY2009         
         LA    R6,ODE3             POINT TO THIRD O.D.E.                        
         TM    6(R6),X'80'         ANYTHING PRESENT?                            
         BZ    COPY                BRANCH IF NO OPERAND                         
         LH    R15,4(,R6)          GET LENGTH OF STRING                         
         SH    R15,=H'5'           LENGTH OF 'NAME='                            
         BNP   COPY                                                             
         L     R1,0(,R6)           POINT TO OPERAND                             
         CLC   0(5,R1),=C'NAME='                                                
         BNE   COPY                                                             
         LA    R1,5(,R1)                                                        
         LA    R0,8                MAX VALID LENGTH                             
         CR    R15,R0              IS STRING TOO LONG ?                         
         BH    COPY                BRANCH IF TOO LONG                           
         MVC   MEMBER,=CL8' '                                                   
         BCTR  R15,0               GET LENGTH MINUS 1 FOR EX                    
         B     *+10                                                             
         MVC   MEMBER(0),0(R1)     <<< EXECUTED >>>                             
         EX    R15,*-6             MOVE NAME TO MEMBER NAME                     
         BAL   R14,NAMETEST        IS MEMBER NAME VALID?        GP12006         
         MVC   LINE,LINE-1                                                      
         MVC   LINE+32(05),=C'ALIAS'                                            
         MVC   LINE+39(08),MEMBER                                               
         LA    R6,MEMBER                                                        
         OI    11(R6),X'80'        SET ALIAS BIT ON                             
         LA    R14,ALIASR          RETURN ADDRESS FROM STOWAR                   
         ST    R14,STOWR           RETURN ADDRESS FROM STOWAR                   
         B     STOWIT              GO CREATE ALIAS              MAY2009         
ALIASR   MVC   MEMBER,=CL8' '                                                   
         B     READ                                                             
         EJECT                                                                  
************************************************************                    
*                                                          *                    
*        ADD OR REPLACE A MEMBER                           *                    
*                                                          *                    
************************************************************                    
         SPACE                                                                  
STOW     DS    0H                                                               
         ST    R14,STOWR                                                        
         TM    STATUS,DECB         ANY WRITES OUTSTANDING?                      
         BZ    STOWW               NO, BRANCH                                   
         L     R1,PUTPDSY+12       GET LAST DECB                                
         CHECK (1)                                                              
         TM    FLAG1,IOERR         I/O ERROR?                   FEB2008         
         BO    IOERROR             YES                          FEB2008         
         NI    STATUS,255-DECB     NO OUTSTANDING WRITES                        
STOWW    LM    R6,R9,PUTPDSX       GET WRITE REGISTERS                          
         SR    R7,R6               GET LENGTH OF FINAL BLOCK                    
         SH    R7,DWLOT            ACCOUNT FOR ANY BDW                          
         BNP   STOWSET             BRANCH IF NOTHING IN BUFFER                  
         LH    R8,BLKSI(,R5)       SAVE ORIGINAL BLKSIZE                        
         CLI   DWLOT+1,4           VARIABLE-LENGTH OUTPUT RECORDS?              
         BE    *+8                 YES, LENGTH IN DATA, NOT DCB                 
         STH   R7,BLKSI(,R5)       NO, STORE FINAL BLOCK LENGTH IN DCB          
         WRITE (R9),SF,(R5),(R6),MF=E                                           
         CHECK (R9)                                                             
         STH   R8,BLKSI(,R5)       RESTORE DCB BLKSIZE FOR NEXT MEMBER          
STOWSET  L     R1,PUTPDSX                                                       
         AH    R1,DWLOT            ALLOW FOR OUTPUT BDW                         
         ST    R1,PUTPDSX+4                                                     
         L     R1,PUTPDSY                                                       
         AH    R1,DWLOT            ALLOW FOR OUTPUT BDW                         
         ST    R1,PUTPDSY+4                                                     
         MVC   LINE,LINE-1                                                      
         CLI   MEMBER,C' '         IS THERE A MEMBER NAME?                      
         BE    STOWX               NO, BRANCH                                   
         TM    FLAG1,SELECT        WAS THIS MEMBER SELECTED?                    
         BZ    STOWX               NO, BRANCH                                   
         MVI   MEMC,0                                                           
         TM    STATUS,SPF          IS THERE SPF USERDATA?                       
         BZ    STOWNSPF            NO, BRANCH                                   
         MVI   MEMC,15             LENGTH OF USER DATA IN HALFWORDS             
         CLC   SPFCCNT,SEQ+2       IS THE RECORD COUNT CORRECT?                 
         BE    STOWFIXD            YES                            C0909         
         MVC   SPFCCNT,SEQ+2       NO, CORRECT IT                               
         OI    FLAG1,FIXSZ         FLAG CORRECTION                              
STOWFIXD ICM   R0,3,SEQ            RECORD COUNT FITS IN HALFWORD? A0909         
         BZ    STOWXCHK            YES, HALFWORD COUNTER CORRECT  A0909         
         MVC   SPFCCNT,=X'FFFF'    NO, SET TO HIGH VALUES         A0909         
STOWXCHK TM    SPFFLAGS,SPFXSTAT   USING EXTENDED STATS?          A0909         
         BO    STOWXSET            YES                            A0909         
         ICM   R0,3,SEQ            RECORD COUNT FITS IN HALFWORD? A0909         
         BZ    STOWNSSI            YES, CLASSIC STATS WILL DO     A0909         
         OI    SPFFLAGS,SPFXSTAT   NO, NEED EXTENDED STATS        A0909         
STOWXSET MVC   SPFXCCNT,SEQ        SET CURRENT RECORD COUNT       A0909         
         MVI   MEMC,20             SET LONGER USER DATA           A0909         
         B     STOWNSSI                                                         
STOWNSPF DS    0H                                                               
         TM    FLAG1,GENSPF        SPF STATS TO BE GENERATED?                   
         BZ    STOWNGEN            NO, BRANCH                                   
         MVI   MEMC,15             LENGTH OF USER DATA IN HALFWORDS             
         XC    MEMUSER,MEMUSER     CLEAR USERDATA                               
         MVI   SPFVM,1             1.0                                          
         TIME  DEC                                                              
         ST    R1,SPFCREDT         DATE CREATED                                 
         ST    R1,SPFCHGDT         DATE OF LAST CHANGE                          
         STCM  R0,12,SPFHHMM       TIME OF LAST CHANGE (HHMM)     C0909         
         STCM  R0,2,SPFSECS        TIME OF LAST CHANGE (SS)       A0909         
         L     R1,SEQ              SIZE                                         
         STH   R1,SPFICNT                                                       
         STH   R1,SPFCCNT                                                       
         MVC   SPFUSER,=CL8'PDSLOAD'                              C1701         
         MVC   SPFBLANK,=CL8' '    INITIALIZE BLANKS              A0909         
         ICM   R0,3,SEQ            RECORD COUNT FITS IN HALFWORD? A0909         
         BZ    STOWNSSI            YES, SET CLASSIC STATS         A0909         
         OI    SPFFLAGS,SPFXSTAT   NO, NEED EXTENDED STATS        A0909         
         MVC   SPFICNT,=X'FFFF'    SET HALFWORD COUNTERS HIGH     A0909         
         MVC   SPFCCNT,=X'FFFF'                                   A0909         
         ST    R1,SPFXICNT         ALSO SET FULLWORD COUNTERS     A0909         
         ST    R1,SPFXCCNT                                        A0909         
         MVI   MEMC,20             SET LONGER USER DATA           A0909         
         B     STOWNSSI                                                         
STOWNGEN DS    0H                                                               
         TM    STATUS,SSI          IS THERE SSI USERDATA?                       
         BZ    STOWNSSI            NO, BRANCH                                   
         MVI   MEMC,2              LENGTH OF USERDATA SSI IN HALFWORDS          
STOWNSSI DS    0H                                                               
         MVC   LINE+32(06),=C'MEMBER'                                           
         MVC   LINE+39(08),MEMBER                                               
         LA    R6,MEMBER                                                        
         XC    8(03,R6),8(R6)      TTR                                          
         SPACE                                                                  
STOWIT   DS    0H                                               MAY2009         
         STOW  (R5),(R6),R                                                      
         SPACE                                                                  
         CL    R15,=F'24'          UNEXPECTED RETURN CODE?      GP06315         
         BH    STOWPDSE            YES, PROBABLY SOME PDSE WORRY                
         B     STOWAR(R15)          R             A                             
STOWAR   B     STOWAR00             REPLACED      ADDED                         
         B     STOWAR04             N/A           NOT ADDED, EXISTS             
         B     STOWAR08             ADDED         N/A                           
         B     STOWAR0C                                                         
         B     STOWAR10                                                         
         B     STOWAR14                                                         
         B     STOWAR18                                                         
         SPACE                                                                  
STOWAR00 TRT   LINE+39(9),TABBLANK                                              
         MVC   1(8,R1),=CL8'REPLACED'                                           
         LA    R1,9(,R1)                                                        
         B     STOWCOMW                                                         
STOWAR04 MVC   RESULT(23),=CL32'NOT ADDED *** ALREADY EXISTS ***'               
         B     STOWCOM                                                          
STOWAR08 TRT   LINE+39(9),TABBLANK                                              
         MVC   1(5,R1),=CL5'ADDED'                                              
         LA    R1,6(,R1)                                                        
         B     STOWCOMW                                                         
STOWAR0C MVC   RESULT(33),=CL33'NOT STOWED *** DIRECTORY FULL ***'              
         B     STOWCOM                                                          
STOWAR10 MVC   RESULT(28),=CL28'NOT STOWED *** I/O ERROR ***'                   
         B     STOWCOM                                                          
STOWAR14 MVC   RESULT(28),=CL28'NOT STOWED *** DCB ERROR ***'                   
         B     STOWCOM                                                          
STOWAR18 MVC   RESULT(32),=CL32'NOT STOWED *** STORAGE ERROR ***'               
         B     STOWCOM                                                          
STOWPDSE MVC   RESULT(29),=CL29'NOT STOWED *** PDSE ERROR ***'                  
         SPACE                                                                  
STOWCOM  DS    0H                                                               
         MVI   RC+1,8              WARNING IS TOO MILD ?        GP12006         
         BAL   R14,REPORT          OUTPUT PRINT LINE                            
         B     STOWX               THAT IS ALL FOR THIS MEMBER                  
STOWCOMW DS    0H                                                               
         TM    MEMC,X'80'          WAS THAT AN ALIAS?                           
         BO    STOWXA              YES, BRANCH                                  
         OI    FLAG1,SELECTAL      ALIAS NOW ALLOWED            MAY2009         
         ST    R1,STOWSVR1                                                      
         L     R15,SEQ                                                          
         CVD   R15,DOUBLE                                                       
         MVC   1(12,R1),=X'402020206B2020206B202120'              C0909         
         ED    1(12,R1),DOUBLE+3                                  C0909         
         MVI   1(R1),C'('                                                       
         LA    R1,2(,R1)                                                        
STOWCOMJ CLI   0(R1),C' '                                                       
         BNE   STOWCOMK                                                         
         MVC   0(12,R1),1(R1)                                     C0909         
         B     STOWCOMJ                                                         
STOWCOMK LA    R1,1(,R1)                                                        
         CLI   0(R1),C' '                                                       
         BNE   STOWCOMK                                                         
         MVC   1(08,R1),=C'RECORDS)'                                            
         CH    R15,=H'1'           ONE RECORD?                                  
         BNE   STOWCHEK            NO, TEXT IS GOOD                             
         MVC   7(2,R1),8(R1)       CHANGE RECORDS TO RECORD                     
         BCTR  R1,0                ADJUST FOR TEXT LENGTH CHANGE                
STOWCHEK TM    FLAG1,FIXSZ         WAS THE SPF STATISTICS SIZE FIXED?           
         BZ    STOWREPT            NO                                           
         NI    FLAG1,255-FIXSZ     YES, RESET FLAG                              
         MVC   8(15,R1),=C' - STATS FIXED)'                                     
STOWREPT BAL   R14,REPORT                                                       
         L     R15,UPR                                                          
         LTR   R15,R15                                                          
         BZ    EXCEPCNT                                                         
         MVC   LINE,LINE-1                                                      
         L     R1,STOWSVR1                                                      
         CVD   R15,DOUBLE                                                       
         MVC   1(12,R1),=X'402020206B2020206B202120'              C0909         
         ED    1(12,R1),DOUBLE+3                                  C0909         
         MVI   1(R1),C'('                                                       
         LA    R1,2(,R1)                                                        
STOWUPRJ CLI   0(R1),C' '                                                       
         BNE   STOWUPRK                                                         
         MVC   0(12,R1),1(R1)                                     C0909         
         B     STOWUPRJ                                                         
STOWUPRK LA    R1,1(,R1)                                                        
         CLI   0(R1),C' '                                                       
         BNE   STOWUPRK                                                         
         MVC   1(09,R1),=C'MODIFIED)'                                           
STOWXA   BAL   R14,REPORT                                                       
** -- >>  below                                                   .SBG.         
EXCEPCNT DS    0H                                                 .SBG.         
         L     R15,UPS                                            .SBG.         
         LTR   R15,R15                                            .SBG.         
         BZ    STOWX                                              .SBG.         
         MVC   LINE,LINE-1                                        .SBG.         
         LA    R1,LINE                                            .SBG.         
         MVC   9(18,R1),=C'Exception Report: '                    .SBG.         
         LA    R1,26(,R1)                                         .SBG.         
         MVC   14(26,R1),=C'SYSUPLOG Records Processed'           .SBG.         
         CVD   R15,DOUBLE                                         .SBG.         
         MVC   0(12,R1),=X'402020206B2020206B202120'              .SBG.         
         ED    0(12,R1),DOUBLE+3                                  .SBG.         
         BAL   R14,REPORT                                         .SBG.         
** -- >>  above                                                   .SBG.         
STOWX    L     R14,STOWR                                                        
         BR    R14                                                              
         SPACE                                                                  
UNDEFBAD MVC   LINE,LINE-1                                                      
         MVC   LINE+1(UNDMSGLN),UNDEFMSG                                        
FAILEXIT BAL   R14,REPORT          REPORT REASON FOR TERMINATION                
         LA    R15,16                                                           
         B     EXIT                                                             
         EJECT                                                                  
************************************************************                    
*                                                          *                    
*         REPORT WRITER                                    *                    
*                                                          *                    
************************************************************                    
         SPACE                                                                  
REPORT   LA    R1,LINE                                                          
         LA    R0,121                                                           
REPORTW  STM   R14,R2,REPORTS                                                   
         LA    R3,PRTDCBW          POINT R3 TO DCB                              
         CP    REPORTLN,REPORTMX   IS LINECOUNT LIMIT REACHED?                  
         BNH   *+10                NO                                           
         ZAP   REPORTLN,=P'0'      YES, FORCE NEW PAGE                          
         CP    REPORTLN,=P'0'      IS NEW PAGE REQUESTED?                       
         BE    REPORTH             YES, GO PRINT HEADING                        
REPORTD  CH    R0,=H'121'          IS OUTPUT LINE LENGTH OK?                    
         BNL   REPORTP             YES, BRANCH                                  
         MVC   REPORTO,REPORTO-1   BLANK THE WORK AREA                          
         LR    R14,R0              COPY LENGTH                  GP12006         
         BCTR  R14,0               LENGTH MINUS 1                               
         B     *+10                                                             
         MVC   REPORTO(0),0(R1)    COPY OUTPUT LINE                             
         EX    R14,*-6             EXECUTE MVC                                  
REPORTB  LA    R1,REPORTO          POINT TO NEW OUTPUT LINE                     
REPORTP  LR    R2,R1               POINT R2 TO OUTPUT LINE                      
         PUT   (R3),(R2)           WRITE OUTPUT LINE                            
         AP    REPORTLN,=P'1'      INCREMENT LINE COUNTER                       
REPORTX  LM    R14,R2,REPORTS      RESTORE REGS                                 
         BR    R14                 RETURN                                       
REPORTH  AP    REPORTPG,=P'1'      INCREMENT PAGE COUNTER                       
         MVC   REPORTO,REPORTO-1   BLANK HEADING                                
         MVI   REPORTO,C'1'        CC = NEW PAGE                                
         MVC   REPORTO+1(L'HEAD1),HEAD1                                         
         LA    R1,REPORTO+075-9    RIGHT EDGE PAGE NO                           
         MVC   3(6,R1),=X'402020202020' EDIT MASK                               
         ED    3(6,R1),REPORTPG    UNPACK PAGE NO                               
         MVC   0(4,R1),=C'PAGE'    INSERT 'PAGE'                                
         PUT   (R3),REPORTO        PUT HEADING LINE 1                           
         MVC   REPORTO,REPORTO-1   BLANK LINE                                   
         PUT   (R3),REPORTO        PUT HEADING LINE 2                           
         LM    R0,R1,REPORTS+8     RESTORE R0 AND R1                            
         B     REPORTD             GO PRINT DETAIL LINE                         
         EJECT                                                                  
************************************************************                    
*                                                          *                    
*         END OF FILE                                      *                    
*                                                          *                    
************************************************************                    
         SPACE                                                                  
EODVTO   MVI   VTOEOF+3,1                                                       
         B     VTOGOT                                                           
EODUT1   DS    0H                                                               
         BAL   R14,STOW                                                         
EXITRC   LH    R15,RC                                                           
EXIT     LR    R2,R15              SAVE RETURN CODE                             
         LA    R6,CLOSE                                           .VTO.         
         MVI   0(R6),X'80'                                        .VTO.         
         L     R3,VTOSTAT                                         .VTO.         
         LTR   R3,R3               IS SYSUPLOG OPEN?              .VTO.         
         BZ    EXITC6X             NO, SKIP CLOSE                 .VTO.         
         CLOSE ((R3)),MF=(E,(R6))                                 .VTO.         
         FREEPOOL (R3)                                            .VTO.         
EXITC6X  DS    0H                                                 .VTO.         
         SPACE                                                                  
         LA    R6,CLOSE                                                         
         MVI   0(R6),X'80'                                                      
         TM    STATUS,UT2          IS SYSUT2 OPEN?                              
         BZ    EXITC5X             NO, SKIP CLOSE                               
         CLOSE ((R5)),MF=(E,(R6))                                               
         FREEPOOL (R5)                                                          
         TM    STATUS,PDS                                                       
         BZ    EXITC5X                                                          
         LM    R0,R1,FREEM         GET LENGTH AND LOCATION OF BUFFERS           
         FREEMAIN R,LV=(0),A=(1)                                                
EXITC5X  DS    0H                                                               
         TM    STATUS,UT1          IS SYSUT1 OPEN?                              
         BZ    EXITC4X             NO, SKIP CLOSE                               
         CLOSE ((R4)),MF=(E,(R6))                                               
         FREEPOOL (R4)                                                          
EXITC4X  DS    0H                                                               
         TM    STATUS,PRT          IS SYSPRINT OPEN?                            
         BZ    EXITC3X             NO, SKIP CLOSE                               
         LA    R3,PRTDCBW          POINT R3 TO DCB                              
         CLOSE ((R3)),MF=(E,(R6))                                               
         FREEPOOL (R3)                                                          
EXITC3X  DS    0H                                                               
         SPACE                                                                  
         LR    R1,R13                                                           
         L     R0,@SIZE                                                         
         L     R13,4(,R13)                                                      
         FREEMAIN R,A=(1),LV=(0)                                                
         LR    R15,R2              RESTORE RETURN CODE                          
         LM    R0,R12,20(R13)                                                   
         L     R14,R12(,R13)                                                    
         BR    R14                                                              
         EJECT                                                                  
************************************************************                    
*                                                          *                    
*         I/O ERROR                                        *    FEB2008         
*                                                          *     GP@P6          
************************************************************                    
         SPACE                                                                  
IOERROR  WTO   MF=(E,SYNADMSG)     DISPLAY I/O ERROR MESSAGE                    
         WTO   'PDSLOAD WILL ABEND - WRITE I/O ERROR',ROUTCDE=(11)              
         ABEND 101                                                              
         SPACE                                                                  
PDSSYNAD DS    0H                                                               
         SYNADAF ACSMETH=BPAM                                                   
         MVC   SYNADMSG+4(78),50(R1)                                            
         OI    FLAG1,IOERR                                                      
         SYNADRLS                                                               
         BR    R14                                                              
         EJECT                                                                  
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - *             
HEX      DS    0H                                                               
         MVC   1(1,R15),0(R1)        Move byte                                  
         UNPK  0(3,R15),1(2,R15)     Unpack                                     
         TR    0(2,R15),HEXTAB-240                                              
         LA    R15,2(,R15)           Increment output pointer                   
         LA    R1,1(,R1)             Increment input pointer                    
         BCT   R0,HEX                Decrement length, then loop                
         MVI   0(R15),C' '           Blank the trailing byte                    
         BR    R4                    Return to caller                           
HEXTAB   DC    C'0123456789ABCDEF'   Translate table                            
         SPACE                                                                  
* --------------------------------------------------------- *                   
************************************************************                    
*                                                          *                    
*        CONSTANTS                                         *                    
*                                                          *                    
************************************************************                    
         SPACE                                                                  
         DS    0F                                                               
UT1EXLST DC    AL1(X'85'),AL3(UT1EXO)  DCB EXIT LIST FOR SYSUT1                 
PDSEXLST DC    AL1(X'85'),AL3(UT2EXO)  DCB EXIT LIST FOR SYSUT2                 
PRTEXLST DC    AL1(X'85'),AL3(PRTEXO)  DCB EXIT LIST FOR SYSPRINT               
         LTORG                                                                  
         SPACE                                                                  
HEAD1    DC    C'--- PDSLOAD --- PDS MEMBER RELOAD UTILITY --- &VER '           
         SPACE                                                                  
UNDEFMSG DC    C'    PDSLOAD TERMINATED - '                                     
         DC    C'UNDEFINED RECORD FORMAT NOT SUPPORTED'                         
UNDMSGLN EQU   *-UNDEFMSG                                                       
         SPACE 1                                                GP12006         
MSGMISS1 DC    C'SYSUT1  MISSING; WILL TRY SYSIN  '             GP12006         
         SPACE 1                                                GP12006         
STRMISS2 DC    C'    PDSLOAD TERMINATED - '                     GP12006         
STRMIDD2 DC    C'SYSUT2  MISSING OR UNUSABLE'                   GP12006         
MSGMISS2 EQU   STRMISS2,*-STRMISS2,C'C'                         GP12006         
         SPACE                                                                  
SHORTMSG DC    C'    PDSLOAD TERMINATED - '                                     
         DC    C'INPUT FILE LOGICAL RECORD LENGTH LESS THAN 80'                 
SHOMSGLN EQU   *-SHORTMSG                                                       
         SPACE                                                                  
SYNADWTO WTO   '1234567890123456789012345678901234567890123456789012345+        
               67890123456789012345678',ROUTCDE=(11),MF=L                       
SYNADLEN EQU   *-SYNADWTO                                                       
         SPACE                                                                  
         PRINT NOGEN                                                            
         SPACE                                                                  
PRTDCB   DCB   DDNAME=SYSPRINT,MACRF=(PM),DSORG=PS,EXLST=PRTEXLST,     +        
               RECFM=FBA,LRECL=121                                              
PRTDCBL  EQU   *-PRTDCB                                                         
         SPACE                                                                  
UT1DCB   DCB   DDNAME=SYSUT1,MACRF=(GL),DSORG=PS,                      +        
               EODAD=EODUT1,EXLST=UT1EXLST                                      
UT1DCBL  EQU   *-UT1DCB                                                         
         SPACE                                                                  
PDSDCB   DCB   DDNAME=SYSUT2,MACRF=(W),DSORG=PO,SYNAD=PDSSYNAD,        +        
               EXLST=PDSEXLST,BUFNO=2                                           
PDSDCBL  EQU   *-PDSDCB                                                         
         SPACE                                                                  
VTODCB   DCB   DDNAME=SYSUPLOG,MACRF=(GL),DSORG=PS,RECFM=FB,LRECL=80,  +        
               EODAD=EODVTO                                                     
VTODCBL  EQU   *-VTODCB                                                         
         PRINT GEN                                                              
         SPACE                                                                  
         WRITE PDSDECB,SF,MF=L                                                  
PDSDECBL EQU   *-PDSDECB                                                        
         SPACE                                                                  
TABNONBL TRENT ,0,C' ',C',',FILL=255   PASS ON COMMA AND BLANK  GP12006         
         SPACE 1                                                                
TABBLANK TRENT FILL=0                                           GP12006         
         TRENT ,C' ',C' '         STOP ON BLANK                 GP12006         
         TRENT ,C',',C','         STOP ON COMMA                 GP12006         
         SPACE 1                                                                
CHARIBM  TRENT FILL=255                                         GP12006         
         TRENT ,0,C'$',C'@',C'#'  ALLOW NATIONAL CHARACTERS     GP12006         
         TRENT ,0,(C'A',9),(C'J',9),(C'S',8)     LETTERS        GP12006         
         TRENT ,0,(C'0',10)                      DIGITS         GP12006         
         TRENT ,0,X'C0'           LEFT BRACE                    GP12090         
         TRENT ,0,C' '            TRAILING SPACE                GP12006         
         SPACE 1                                                                
CHAR037  TRENT FILL=255                                         GP12006         
         TRENT ,0,(X'40',X'6B'-X'40')   EVERYTHING BELOW COMMA  GP12006         
         TRENT ,0,(X'6B'+1,255-X'6B')   EVERYTHING AFTER COMMA  GP12006         
         SPACE 1                                                                
*              WARNING: 'TRT' CAN CHANGE THE LOW ORDER 8 BITS                   
*              OF REGISTER 2 AND LOW ORDER 24 BITS OF REG 1.                    
         SPACE                                                                  
NUMERIC  TRENT ,0,(C'0',10),FILL=255   DIGITS ONLY              GP12006         
         SPACE                                                                  
EODAD    EQU   32                  OFFSET INTO DCB                              
RECFM    EQU   36                  OFFSET INTO DCB                              
EXLST    EQU   36                  OFFSET INTO DCB                              
OFLGS    EQU   48                  OFFSET INTO DCB                              
DDNAM    EQU   40                  OFFSET INTO DCB                              
BLKSI    EQU   62                  OFFSET INTO DCB                              
LRECL    EQU   82                  OFFSET INTO DCB                              
         SPACE                                                                  
         DC    0D'0'               END OF CSECT                   A1701         
         EJECT                                                                  
************************************************************                    
*                                                          *                    
*        DSECTS                                            *                    
*                                                          *                    
************************************************************                    
         SPACE                                                                  
@DATA    DSECT                                                                  
         DS    18F                 REGISTER SAVEAREA                            
DOUBLE   DS    D                                                                
OPEN     DS    F                                                                
CLOSE    EQU   OPEN                                                             
COUNTIN  DS    F                                                                
SEQ      DS    F                                                                
UPR      DS    F                                                                
UPS      DS    F                                                  .SBG.         
SAVER0   DS    F                                                  .SBG.         
SAV4HEX  DS    F                                                                
HEXSAVE  DS    5F                                                               
STOWSVR1 DS    F                                                                
OPTIONS  DS    H                                                                
RC       DS    H                                                                
UPDTE    DS    CL2                                                              
CTLMODEL DC    CL12'./ ADD NAME='      LOOKING FOR              GP06315         
PRTDCBW  DS    0F,(PRTDCBL)X                                                    
UT1DCBW  DS    0F,(UT1DCBL)X                                                    
PDSDCBW  DS    0F,(PDSDCBL)X                                                    
VTODCBW  DS    0F,(VTODCBL)X                                                    
FREEM    DS    2F                                                               
PUTPDSR  DS    F                                                                
PUTPDSX  DS    4F                                                               
PUTPDSY  DS    4F                                                               
RECAD    DS    F                                                                
@TRTTAB  DS    A                                                GP12006         
DWLIN    DS    H                                                                
DWLOT    DS    H                                                                
SKIPFLG  DS    X                                              SBG 02/00         
PDSDECB1 DS    0F,(PDSDECBL)X                                                   
PDSDECB2 DS    0F,(PDSDECBL)X                                                   
STOWR    DS    F                                                                
PACKR    DS    F                                                                
VTOSTAT  DS    F                                                                
VTOEOF   DS    F                                                                
VTOSAVE  DS    6F                                                               
VTOPREV  DS    F                                                                
INREC    DS    0D,CL80                                                          
ADD      DS    CL256                                                            
ODL      DS    0F                  OPERAND DESCRIPTOR LIST                      
ODE1     DS    2F                  OPERAND DESCRIPTOR ENTRY 1                   
ODE2     DS    2F                  OPERAND DESCRIPTOR ENTRY 2                   
ODE3     DS    2F                  OPERAND DESCRIPTOR ENTRY 3                   
ODE4     DS    2F                  OPERAND DESCRIPTOR ENTRY 4                   
ODE5     DS    2F                  OPERAND DESCRIPTOR ENTRY 5                   
ODE6     DS    2F                  OPERAND DESCRIPTOR ENTRY 6     A0909         
ODE7     DS    2F                  OPERAND DESCRIPTOR ENTRY 7     A0909         
ODLL     EQU   *-ODL                                                            
STATUS   DS    C                                                                
PRT      EQU   X'80'                                                            
UT1      EQU   X'40'                                                            
UT2      EQU   X'20'                                                            
PDS      EQU   X'10'                                                            
DECB     EQU   X'08'                                                            
COPYM    EQU   X'04'                                                            
SPF      EQU   X'02'                                                            
SSI      EQU   X'01'                                                            
FLAG1    DS    C                                                                
SELECT   EQU   X'80'                                                            
GENSPF   EQU   X'40'               GENERATE SPF STATS                           
NEWPRM   EQU   X'20'               PARM=NEW WAS SPECIFIED                       
FIXSZ    EQU   X'10'               SPF STATS SIZE WAS CORRECTED                 
IOERR    EQU   X'08'               OUTPUT I/O ERROR             FEB2008         
CK3      EQU   X'04'               CHECK COLUMN 3               OCT2015         
FGNOCON  EQU   X'02'               CONTROL - SKIP UPDTE TEST    GP06315         
SELECTAL EQU   X'01'               ALIAS ALLOWED                MAY2009         
         DS    C                   LINE-1                                       
LINE     DS    CL133                                                            
RESULT   EQU   LINE+48                           (IFOX00)       GP06315         
LINEH1   DS    CL133                                                            
*                                                                               
SYNADMSG DS    XL(SYNADLEN)                                     FEB2008         
*                                                                               
MEMSEL   DS    D                                                                
MEMBER   DS    D                                                                
MEMTTR   DS    XL3                                                              
MEMC     DS    XL1                 LENGTH/2 OF MEMUSER                          
MEMUSER  DS    CL40                SPF STATISTICS OR SSI          C0909         
         ORG   MEMUSER                                            C0909         
SPFVM    DS    XL2                 VERSION, LEVEL                               
SPFFLAGS DS    X                   FLAGS                          A0909         
SPFSCLM  EQU   X'80'               SCLM-MANAGED                   A0909         
SPFXSTAT EQU   X'20'               EXTENDED STATISTICS            A0909         
SPFSECS  DS    X                   TIME LAST UPDATED (SS)         A0909         
SPFCREDT DS    PL4                 DATE CREATED                                 
SPFCHGDT DS    PL4                 DATE LAST UPDATED                            
SPFHHMM  DS    XL2                 TIME LAST UPDATED (HHMM)                     
SPFCCNT  DS    H                   CURRENT SIZE                                 
SPFICNT  DS    H                   INITIAL SIZE                                 
SPFMOD   DS    H                   MODS                                         
SPFUSER  DS    CL8                 USERID                         C1701         
SPFBLANK DS    CL2                 CLASSICALLY TWO BLANKS         C1701         
         ORG   SPFBLANK                                           C1701         
SPFXCCNT DS    F                   CURRENT SIZE                   A0909         
SPFXICNT DS    F                   INITIAL SIZE                   A0909         
SPFXMOD  DS    F                   MODS                           A0909         
*                                                                               
REPORTS  DS    6F                  REGISTER SAVE AREA                           
REPORTPG DS    PL3                 PAGE COUNT, INIT P'0'                        
REPORTLN DS    PL2                 LINE COUNT, INIT P'0'                        
REPORTMX DS    PL2                 LINES/PAGE, INIT P'50'                       
REPORTOB DS    CL1                 REPORTO-1 (INIT BLANK)                       
REPORTO  DS    CL133               OUTPUT AREA                                  
*                                                                               
ZEROAREA DS    0CL(8+8+7)          UNPACKED COUNTERS AREA         A0909         
#CRNT    DS    CL8                 CURRENT RECORD COUNT           A0909         
#CRNTSML EQU   #CRNT+3,5           CURRENT RECORD COUNT           A0909         
#INIT    DS    CL8                 INITIAL RECORD COUNT           A0909         
#INITSML EQU   #INIT+3,5           INITIAL RECORD COUNT           A0909         
#MOD     DS    CL7                 CHANGED RECORD COUNT           A0909         
#MODSML  EQU   #MOD+2,5            CHANGED RECORD COUNT           A0909         
         DS    0D                                                               
@DATAL   EQU   *-@DATA                                                          
         SPACE                                                                  
XPF      DSECT                                                                  
XPFVM    DS    CL4,C               VERSION, LEVEL                               
XPFCREDT DS    CL5,C               DATE CREATED                                 
XPFCHGDT DS    CL5,C               DATE LAST UPDATED                            
XPFHHMM  DS    CL4,C               TIME LAST UPDATED                            
XPFCCNT  DS    CL5,C               CURRENT SIZE                                 
XPFICNT  DS    CL5,C               INITIAL SIZE                                 
XPFMOD   DS    CL5,C               MODS                                         
XPFUSER  DS    CL10                USERID                                       
XP2      DSECT                                                                  
XP2VM    DS    CL4,C               VERSION, LEVEL                               
         DS    CL2                 EXTRA LETTERS FOR YEAR                       
XP2CREDT DS    CL5,C               DATE CREATED                                 
         DS    CL2                 EXTRA LETTERS FOR YEAR                       
XP2CHGDT DS    CL5,C               DATE LAST UPDATED                            
XP2HHMM  DS    CL4,C               TIME LAST UPDATED                            
XP2CCNT  DS    CL5,C               CURRENT SIZE                                 
XP2ICNT  DS    CL5,C               INITIAL SIZE                                 
XP2MOD   DS    CL5,C               MODS                                         
XP2USER  DS    CL10                USERID                                       
R0       EQU   0                                                                
R1       EQU   1                                                                
R2       EQU   2                                                                
R3       EQU   3                                                                
R4       EQU   4                                                                
R5       EQU   5                                                                
R6       EQU   6                                                                
R7       EQU   7                                                                
R8       EQU   8                                                                
R9       EQU   9                                                                
R10      EQU   10                                                               
R11      EQU   11                                                               
R12      EQU   12                                                               
R13      EQU   13                                                               
R14      EQU   14                                                               
R15      EQU   15                                                               
         SPACE 2                                                                
         PRINT GEN                                                              
         CVT   LIST=YES,DSECT=YES   NEED FOR SYSTEM LEVEL CHECK GP12006         
         DCBD  DEVD=DA,DSORG=PO   WANT FOR DCB VALUES           GP12006         
         END                                                                    
/*                                                                              
//LKED EXEC PGM=IEWL,PARM=(XREF,LET,LIST,NCAL),REGION=128K                      
//SYSLIN DD DSN=&&OBJSET,DISP=(OLD,DELETE)                                      
//       DD *                                                                   
  SETSSI  CB493093                                                              
  ENTRY   PDSLOAD                                                               
  ALIAS   PDSLOADW                                                              
  NAME    PDSLOAD(R)                                                            
/*                                                                              
//SYSLMOD DD DSN=SYS1.LINKLIB,DISP=MOD,UNIT=3330,VOL=SER=START1                 
//SYSPRINT DD SYSOUT=A                                                          
//*                                                (END SUBMITTED JOB)          
><                                                                              
//SYSUT1   DD  DISP=(OLD,DELETE),DSN=&&LINKS                                    
//SYSUT2   DD  DSN=&&JOBS,UNIT=SYSDA,DISP=(MOD,PASS),                           
//             SPACE=(TRK,(15,15)),DCB=(RECFM=FB,LRECL=80,BLKSIZE=6400)         
//SYSPRINT DD  SYSOUT=*                                                         
//SYSIN    DD  *                                                                
  REPRO INFILE(JCL001) OUTFILE(SYSUT2)                                          
  REPRO INFILE(SYSUT1) OUTFILE(SYSUT2) SKIP(6) COUNT(50)                        
  REPRO INFILE(JCL002) OUTFILE(SYSUT2)                                          
  REPRO INFILE(SYSUT1) OUTFILE(SYSUT2) SKIP(68) COUNT(9)                        
  REPRO INFILE(JCL003) OUTFILE(SYSUT2)                                          
  REPRO INFILE(SYSUT1) OUTFILE(SYSUT2) SKIP(293) COUNT(67)                      
  REPRO INFILE(JCL004) OUTFILE(SYSUT2)                                          
/*                                                                              
//*                                                                             
//*********************************************************************         
//* Write completed jobstream to Internal Reader                                
//*********************************************************************         
//*                                                                             
//IEBGENER EXEC PGM=IEBGENER                                                    
//SYSIN    DD  DUMMY                                                            
//SYSPRINT DD  DUMMY                                                            
//SYSUT1   DD  DISP=(OLD,DELETE),DSN=&&JOBS                                     
//SYSUT2   DD  SYSOUT=(A,INTRDR)                                                
//                                                                              
