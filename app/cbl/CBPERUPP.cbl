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

           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.

       PROCEDURE DIVISION.
       BEGIN.
           OPEN INPUT PERSON-FILE
           PERFORM UNTIL EOF = 'Y'
               READ PERSON-FILE
                   AT END
                       MOVE 'Y' TO EOF
                   NOT AT END
                       MOVE FIRST-NAME TO WS-FIRST-NAME
                       MOVE LAST-NAME TO WS-LAST-NAME
                       MOVE BIRTH-DATE TO WS-BIRTH-DATE
                       PERFORM CONVERT-UPPERCASE
                       EXEC SQL
                           INSERT INTO PERSON_TABLE
                               (FIRST_NAME, LAST_NAME, BIRTH_DATE)
                           VALUES
                               (:WS-FIRST-NAME, :WS-LAST-NAME,
                                :WS-BIRTH-DATE)
                       END-EXEC
               END-READ
           END-PERFORM
           CLOSE PERSON-FILE
           STOP RUN.

       CONVERT-UPPERCASE.
           INSPECT WS-FIRST-NAME CONVERTING
               'abcdefghijklmnopqrstuvwxyz'
               TO 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
           INSPECT WS-LAST-NAME CONVERTING
               'abcdefghijklmnopqrstuvwxyz'
               TO 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.
