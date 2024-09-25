#!/usr/bin/env regina

/* Script:  condcode.rexx
   Purpose: Scan MVS SYSOUT for IEF142I messages
   Author:  Jay Moseley
   Date:    Sat May 2, 2020
   Update:  Sun April 21, 2024 - Removed coding for 'USERMODSn' meta jobs
                                 for V8

   This REXX script scans a text file containing MVS SYSOUT content. Any line
   containing 'IEF142I', the message identifier for step condition code information,
   is processed.

   The first argument to the script specifies the name of the host Operating System 
   file containing the SYSOUT content to process.

   The second argument to the script specifies the name of the job to process. Two
   values trigger special circumstances:

       A value of 'ALL' will cause all IEF142 messages to be processed and printed
       regardless of the name of the job.

*/

PARSE ARG printFile jobName;    /* retrieve the two arguments */

/* verify that a print file name has been specified and exists: */

IF LENGTH(printFile)=0 THEN DO
  SAY 'First argument must be Hercules printer file, for example: prt00e.txt';
  EXIT 1;   /* exit script */
END;

IF LENGTH(STREAM(printFile,'C','QUERY EXISTS'))=0 THEN DO
  SAY 'Hercules printer file specified as first argument ('||printFile||') cannot be opened'
  EXIT 1;   /* exit script */
END;

/* verify that a jobname to be searched for has been specified: */

IF LENGTH(jobName)=0 THEN DO
  SAY 'Second argument must be MVS job name to scan printer file for (or ALL)';
  EXIT 2;   /* exit script */
END;

rcRecap. = 0;	/* initialize return code summary array */

/* print headings: */

SAY 'Searching' printFile 'for MVS Job Name' jobName;
SAY ' ';
SAY 'Job Name    Step Name    Proc Step Name    Completion Code';
SAY '--------    ---------    --------------    ---------------';

priorJob='NONE';    /* variable to track reported job name change */
ccKey='COND CODE '; /* text preceeding condition code in message line */

/* process all lines in the text file: */

DO WHILE LINES(printFile)\=0    /* while there are lines remaining to be processed */

  inpLine=LINEIN(printFile);    /* read a line from the file */

  IF POS('IEF142I',inpLine)>0 THEN DO   /* does the line contain IEF142I? */

    thisJob=WORD(inpLine,2);                /* extract job name from message line */

    printFlag='n';		/* reset flag for printing step CC */

    SELECT			/* determine whether to print this line */
      WHEN UPPER(jobName)=='ALL'
        THEN printFlag='y';
      OTHERWISE
        IF thisJob==UPPER(jobName)
          THEN printFlag='y';
    END;

    IF printFLag=='y' THEN DO
      stepName=WORD(inpLine,3);             /* extract step name from message line */
      procName=WORD(inpLine,4);             /* extract proc name from message line */
      IF procName=='-' THEN procName=' ';   /* don't print - when proc name omitted */
      ccPos=POS(ccKey,inpLine)+LENGTH(ccKey); /* location of cc in message line */
      condCode=SUBSTR(inpLine,ccPos,4);     /* extract condition code from message line */

      IF condCode\='0000'                   /* make non-zero condition codes stand out */
        THEN ccFlag=' <--';
      ELSE
        ccFlag='';

      rcRecap.steps = rcRecap.steps + 1;    /* count this step in total steps */
      rcRecap.condCode = rcRecap.condCode + 1;      /* count ending condcode for summary */

      IF priorJob\=thisJob THEN             /* print blank line between jobs */
        IF priorJob\='NONE' THEN
          SAY ' ';

      SAY LEFT(thisJob,11,' ') LEFT(stepName,12,' ') LEFT(procName,17,' ') condCode||ccFlag;

      priorJob=thisJob;

    END;

  END;

END;

/* At conclusion, print summary of jobs executed and condition codes received */

SAY ' ';
SAY RIGHT(rcRecap.steps,3,' ') 'steps executed in selected jobs';
DO ix=0 BY 1 TO 65535
  thisCC = RIGHT(D2X(ix),4,'0')
  IF rcRecap.thisCC > 0 THEN
    SAY RIGHT(rcRecap.thisCC,3,' ') 'steps received completion code =' thisCC
END;

EXIT 0; /* exit script */
