.MODEL SMALL
.STACK 100H

.DATA
    NEWL DB 13, 10, "$"  ; Carriage return and linefeed = Newline
    date_op DB "System Date: $"
    time_op DB "System Time: $"

.CODE
    MOV AX, @DATA  ; for moving data to data segment
    MOV DS, AX

    JMP startLabel
                print_prompt MACRO msg
                    push ax
                    push bx
                    push cx
                    push dx
                    LEA DX, msg
                    MOV AH, 09H
                    INT 21H
                    pop dx
                    pop cx
                    pop bx
                    pop ax
                endm

    ; User defined functions ...................................................................................................
displayLabel:
    MOV DL,BH      ; Since the values are in BX, BH Part
    ADD DL,30H     ; ASCII Adjustment
    MOV AH,02H     ; To Print in DOS
    INT 21H

    MOV DL,BL      ; BL Part 
    ADD DL,30H     ; ASCII Adjustment
    MOV AH,02H     ; To Print in DOS
    INT 21H

    RET




startLabel:

    print_prompt date_op

    MOV AH, 2AH    
    INT 21H
    MOV AL, DL     
    AAM
    MOV BX, AX
    CALL displayLabel

    MOV DL, '/'
    MOV AH, 02H
    INT 21H

    MOV AH, 2AH    
    INT 21H
    MOV AL, DH     
    AAM
    MOV BX, AX
    CALL displayLabel

    MOV DL, '/'
    MOV AH, 02H
    INT 21H

    MOV AH, 2AH    
    INT 21H
    ADD CX, 0F830H 
    MOV AX, CX   
    AAM
    MOV BX, AX
    CALL displayLabel

    print_prompt NEWL


    print_prompt time_op

    MOV AH, 2CH   
    INT 21H
    MOV AL, CH   
    AAM
    MOV BX, AX
    CALL displayLabel

    MOV DL, ':'
    MOV AH, 02H
    INT 21H


    MOV AH, 2CH   
    INT 21H
    MOV AL,CL   
    AAM
    MOV BX, AX
    CALL displayLabel

    MOV DL, ':'
    MOV AH, 02H
    INT 21H


    MOV AH, 2CH
    INT 21H
    MOV AL,DH
    AAM
    MOV BX, AX
    CALL displayLabel

    print_prompt NEWL

endingLabel:
    MOV AH, 4CH
    INT 21H

END 