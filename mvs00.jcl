//MVS00    JOB (1),'INITIALIZE DASD',                                   
//             CLASS=A,MSGLEVEL=(1,1),MSGCLASS=A                        
//*                                                                     
//ICKDSF   EXEC PGM=ICKDSF13,REGION=4096K                               
//* ***************************************************************** * 
//* Initialize PUB000.3380 on 180 and PUB001.3390 on 190.             * 
//* ***************************************************************** * 
//SYSPRINT DD  SYSOUT=*                                                 
//SYSIN    DD  *                                                        
  INIT UNIT(180) -                                                      
               VERIFY(111111) -                                         
               OWNER(HERCULES) -                                        
               VOLID(PUB000) -                                          
               VTOC(0,1,30)                                             
  INIT UNIT(190) -                                                      
               VERIFY(222222) -                                         
               OWNER(HERCULES) -                                        
               VOLID(PUB001) -                                          
               VTOC(0,1,60)                                             
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
//*                                                                     
//IEBGENER EXEC PGM=IEBGENER,COND=(0,NE)                                
//* ***************************************************************** * 
//* If ICKDSF RC=0000, submit MVS00 continuation job to internal      * 
//* reader.                                                           * 
//* ***************************************************************** * 
//SYSPRINT DD  DUMMY                                                    
//SYSIN    DD  DUMMY                                                    
//SYSUT1   DD  DATA,DLM='><'                                            
//MVS00    JOB (1),'PUT NEW DASD ONLINE',CLASS=S,MSGCLASS=A             
//********************************************************************* 
//* Issues Vary and Mount commands to place newly initialized DASD    * 
//* online. IMPORT SYSCPK User Catalog into Master Catalog.           * 
//********************************************************************* 
// V (180,190),ONLINE                       
// M 180,VOL=(SL,PUB000),USE=PRIVATE                                    
// M 190,VOL=(SL,PUB001),USE=PRIVATE                                    
//IEFBR14  EXEC PGM=IEFBR14                                             
//IDCAMS01 EXEC PGM=IDCAMS,REGION=4096K                                 
//SYSPRINT DD SYSOUT=*                                                  
//SYSCPK DD UNIT=SYSDA,DISP=OLD,VOL=SER=SYSCPK                          
//SYSIN DD *                                                            
                                                                        
  /* THERE IS A USER CATALOG IN EXISTENCE ON SYSCPK THAT       */       
  /* CONTAINS CATALOG ENTRIES FOR THE DATASETS ON THAT VOLUME. */       
  /* IT IS CONNECTED TO THE MASTER CATALOG AND AN ALIAS TO THE */       
  /* HIGH ORDER INDEX IS DEFINED TO ALLOW ACCESS TO THE        */       
  /* DATASETS CATALOGUED IN THAT USER CATALOG.                 */       
                                                                        
  IMPORT CONNECT OBJECTS ( -                                            
         UCSYSCPK  -                                                    
         DEVICETYPE (3350) -                                            
         VOLUMES (SYSCPK) )                                             
                                                                        
  DEFINE ALIAS ( -                                                      
        NAME (SYSC) -                                                   
        RELATE (UCSYSCPK) )                                             

  /* THE GCC COMPILER, LOCATED ON THE SYSCPK VOLUME, REQUIRES  */       
  /* 2 ALIASES TO POINT TO THE USER CATALOG ON SYSCPK. THE     */
  /* FOLLOWING STATEMENTS DEFINE THOSE ALIASES.                */              

  DEFINE ALIAS ( NAME(GCC)     RELATE(UCSYSCPK) )
  DEFINE ALIAS ( NAME(PDPCLIB) RELATE(UCSYSCPK) )
                                                                        
//*    END OF MVS00 CONTINUATION JOB                                    
><                                                                      
//SYSUT2   DD  SYSOUT=(A,INTRDR)                                        
//* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
//                                                                      
