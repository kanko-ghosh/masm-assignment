.MODEL SMALL
.STACK 100H

.DATA
    NEWL DB 13, 10, "$"  
    Q1 DB "Enter dividend: $"
    Q2 DB "Enter divisor: $"
    QUO DB "Quotient: $"
    REM DB "Remainder: $"
    TELL5 DB "0H$"

    

.CODE
    MOV AX, @DATA 
    MOV DS, AX

    JMP startLabel
                print_alphabet macro msg
                    push ax
                    push bx
                    push cx
                    push dx
                    mov ah, 02h
                    mov al, msg
                    int 21h
                    pop dx
                    pop cx
                    pop bx
                    pop ax
                endm
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
inputHexadecimalNumberFunction:
        ; Setting initial number to 0
        XOR BX, BX

    inputNumberLabel:
        ; Read the character
        MOV AH, 01H
        INT 21H

        ; Check if character is carriage return
        CMP AL, 0DH
        JE inputNumberDoneLabel

        ; Check if character is not number
        CMP AL, '0'
        JL isLetterLabel
        CMP AL, '9'
        JG isLetterLabel

        ; Now our character is a digit
        SUB AL, '0'
        JMP appendToNum

        ; Now our character is a letter
    isLetterLabel:
        SUB AL, 'A'
        ADD AL, 0AH

        ; Append to first number
    appendToNum:
        SHL BX, 1
        SHL BX, 1
        SHL BX, 1
        SHL BX, 1
        ADD BL, AL
        JMP inputNumberLabel

    inputNumberDoneLabel:
        RET



printHexadecimalNumberFunction:
        ; First Digit
        MOV DL, BH
        SHR DL, 1
        SHR DL, 1
        SHR DL, 1
        SHR DL, 1

        ; Checking digit is number
        CMP DL, 0AH
        JL isDigitLabel1

        ; Character is letter
        SUB DL, 0AH
        ADD DL, 'A'
        JMP printDigitLabel1

        ; Character is digit
    isDigitLabel1:
        ADD DL, '0'

        ; Printing the digit
    printDigitLabel1:
        MOV AH, 02H
        INT 21H




        ; Second Digit
        MOV DL, BH
        AND DL, 0FH

        ; Checking digit is number
        CMP DL, 0AH
        JL isDigitLabel2

        ; Character is letter
        SUB DL, 0AH
        ADD DL, 'A'
        JMP printDigitLabel2

        ; Character is digit
    isDigitLabel2:
        ADD DL, '0'

        ; Printing the digit
    printDigitLabel2:
        MOV AH, 02H
        INT 21H




        ; Third Digit
        MOV DL, BL
        SHR DL, 1
        SHR DL, 1
        SHR DL, 1
        SHR DL, 1

        ; Checking digit is number
        CMP DL, 0AH
        JL isDigitLabel3

        ; Character is letter
        SUB DL, 0AH
        ADD DL, 'A'
        JMP printDigitLabel3

        ; Character is digit
    isDigitLabel3:
        ADD DL, '0'

        ; Printing the digit
    printDigitLabel3:
        MOV AH, 02H
        INT 21H




        ; Fourth Digit
        MOV DL, BL
        AND DL, 0FH

        ; Checking digit is number
        CMP DL, 0AH
        JL isDigitLabel4

        ; Character is letter
        SUB DL, 0AH
        ADD DL, 'A'
        JMP printDigitLabel4

        ; Character is digit
    isDigitLabel4:
        ADD DL, '0'

        ; Printing the digit
    printDigitLabel4:
        MOV AH, 02H
        INT 21H

    completeLabel:
        ; Print H at end
        MOV DL, 'H'
        MOV AH, 02H
        INT 21H

    inputEndingLabel:
        RET



    ; Main .....................................................................................................................
startLabel:
    print_prompt Q1
    CALL inputHexadecimalNumberFunction
    MOV CX, BX

    print_prompt Q2
    CALL inputHexadecimalNumberFunction
    print_prompt NEWL

    MOV AX, CX
    XOR DX, DX  ; before division
    DIV BX

    ;;; DX = Remainder
    ;;; AX = Quotient

    MOV CX, DX  
    MOV BX, AX

    print_prompt QUO
    CALL printHexadecimalNumberFunction
    print_prompt NEWL

    print_prompt REM
    MOV BX, CX
    CALL printHexadecimalNumberFunction
    print_prompt NEWL

endingLabel:
    MOV AH, 4CH
    INT 21H

END