.MODEL SMALL
.STACK 100H

.DATA
    NEWL DB 13, 10, "$"

    Q1 DB "Enter number 1: $"
    Q2 DB "Enter number 2: $"
    Q3 DB "Enter number 3: $"
    GCD_RES DB "GCD of 3 numbers: $"
    LCM_RES DB "LCM of 3 numbers: $"
    TELL5 DB "0H$"

    
    

.CODE
    MOV AX, @DATA
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
        CMP BX, 0000H
        JNE computeLabel

        ; Our number is 0 , simply print it
        LEA DX, TELL5
        MOV AH, 09H
        INT 21H
        JMP inputEndingLabel

        ; Our number is non-zero , lets print it
    computeLabel:
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




gcdFunction:

    POP AX ;;;; Return address
    MOV SI, AX

    POP AX  ;;; large
    POP DX  ;;; small

    ; Return Address
    PUSH SI

    CMP AX, DX
    JAE gcd_no_swap
            MOV CX, AX
            MOV AX, DX
            MOV DX, CX
    gcd_no_swap:
    CMP DX, 0000H
    JE ret_ans

    
    SUB AX, DX
    PUSH AX
    PUSH DX
    CALL gcdFunction  ;;;gcd(AX, DX) = gcd (AX-DX, DX);
    POP AX

    ret_ans:
        POP DX
        PUSH AX
        PUSH DX
    RET




lcmFunction:
    ; Return address
    POP SI
    POP BX
    POP CX
    PUSH SI

    MOV AX, 1
        lcmLoopLabel:
        PUSH AX

        XOR DX, DX
        DIV BX

        CMP DX, 0000H
        JNE lcmGoNext

        POP AX
        PUSH AX

        XOR DX, DX
        DIV CX

        CMP DX, 0000H
        JNE lcmGoNext

        ; Divisible by both - LCM
        POP AX
        POP SI  ; Return address
        PUSH AX
        PUSH SI  ; Return address
        JMP lcmDoneLabel

        lcmGoNext:
        POP AX
        INC AX
        JMP lcmLoopLabel


    lcmDoneLabel:
    RET





    ; Main .....................................................................................................................
startLabel:

    print_prompt Q1    
    CALL inputHexadecimalNumberFunction
    PUSH BX
    print_prompt Q2
    CALL inputHexadecimalNumberFunction
    PUSH BX
    print_prompt Q3
    CALL inputHexadecimalNumberFunction
    PUSH BX

    print_prompt NEWL

    CALL gcdFunction
    CALL gcdFunction

    print_prompt GCD_RES
    POP BX
    CALL printHexadecimalNumberFunction

    print_prompt NEWL

    ;;;;; LCM ;;;;;;;
    

    print_prompt Q1    
    CALL inputHexadecimalNumberFunction
    PUSH BX
    print_prompt Q2
    CALL inputHexadecimalNumberFunction
    PUSH BX
    print_prompt Q3
    CALL inputHexadecimalNumberFunction
    PUSH BX

    print_prompt NEWL

    CALL lcmFunction
    CALL lcmFunction

    print_prompt LCM_RES
    POP BX
    CALL printHexadecimalNumberFunction

    print_prompt NEWL


    MOV AH, 4CH
    INT 21H

END