      ******************************************************************
      * Program     : CBPERUPP.CBL                                      
      * Application : CardDemo                                          
      * Type        : BATCH COBOL Program                                
      * Function    : Read people data from file and write to db.                 
      ******************************************************************
      * Copyright Amazon.com, Inc. or its affiliates.                   
      * All Rights Reserved.                                            
      *                                                                 
      * Licensed under the Apache License, Version 2.0 (the "License"). 
      * You may not use this file except in compliance with the License.
      * You may obtain a copy of the License at                         
      *                                                                 
      *    http://www.apache.org/licenses/LICENSE-2.0                   
      *                                                                 
      * Unless required by applicable law or agreed to in writing,      
      * software distributed under the License is distributed on an     
      * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,    
      * either express or implied. See the License for the specific     
      * language governing permissions and limitations under the License
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. CBPERUPP.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PERSON-FILE ASSIGN TO 'PERSON.DAT'
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  PERSON-FILE.
       01  PERSON-RECORD.
           05 FIRST-NAME         PIC X(20).
           05 LAST-NAME          PIC X(20).
           05 BIRTH-DATE         PIC X(10).

       WORKING-STORAGE SECTION.
       01  WS-FIRST-NAME         PIC X(20).
       01  WS-LAST-NAME          PIC X(20).
       01  WS-BIRTH-DATE         PIC X(10).
       01  EOF                   PIC X VALUE 'N'.
       01  SQLCODE               PIC S9(4) COMP.

       PROCEDURE DIVISION.
       BEGIN.
           OPEN INPUT PERSON-FILE.
           PERFORM UNTIL EOF = 'Y'
               READ PERSON-FILE
                   AT END
                       MOVE 'Y' TO EOF
                   NOT AT END
                       MOVE FIRST-NAME TO WS-FIRST-NAME
                       MOVE LAST-NAME TO WS-LAST-NAME
                       MOVE BIRTH-DATE TO WS-BIRTH-DATE
                       PERFORM CONVERT-UPPERCASE
                       DISPLAY 'WRITE RECORD TO DATABASE'
               END-READ
           END-PERFORM.
           CLOSE PERSON-FILE.
           STOP RUN.

       CONVERT-UPPERCASE.
           INSPECT WS-FIRST-NAME CONVERTING
               'abcdefghijklmnopqrstuvwxyz'
               TO 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
           INSPECT WS-LAST-NAME CONVERTING
               'abcdefghijklmnopqrstuvwxyz'
               TO 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.
           EXIT.
