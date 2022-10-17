.MODEL SMALL
.STACK 100H

.DATA
    NEWL    db 13, 10, "$"
    prompt1     db "Enter Len: $"
    prompt2     db "Enter Num: $"
    msg1        db "Array is: $"
    msg2        db "Selection Sort:$"
    msg3        db "Array size: 0, exiting$"
    len db ?
    ARRAY dw 10 DUP(0), "$"
    ; dec_out db 2 DUP(0), "$"

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
                maxm_function MACRO
                    push ax
                    push bx
                    push cx
                    push dx
                        MOV CX, [SI]
                        MOV DX, [DI]
                        CMP CX, DX
                        JL break
                        MOV DI, SI
                    break:
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

    print_prompt prompt1
    CALL inputHexadecimalNumberFunction
    ;; BX contains it!!

    CMP BL, 00H
    JNE continueLabel
    print_prompt msg3
    print_prompt NEWL
    JMP endl

continueLabel:
    MOV CX, BX
    PUSH BX ;;size in stack
    LEA SI, ARRAY

    loop_input:
        print_prompt prompt2
        call inputHexadecimalNumberFunction
        MOV [SI], BX
        INC SI
        INC SI
        LOOP loop_input
    
    POP BX
    ;;input done at this point

    MOV DH, BL
    outer_loop:
        DEC DH
        CMP DH, 0H
        JE outer_loop_ends

        LEA SI, ARRAY
        MOV DI, SI
        INC SI
        INC SI
        ;;;DI will contain the pointer to max value

        MOV CL, DH
        MOV CH, 00H
        inner_loop:
            maxm_function
            INC SI
            INC SI
            LOOP inner_loop
                    push ax
                    push bx
                    push cx
                    push dx
                        DEC SI
                        DEC SI
                        ;;take DI, PUsh others put DI

                        MOV AX, [DI]
                    move_again:
                        CMP DI, SI
                        JE move_end
                        INC DI
                        INC DI
                        MOV BX, [DI]
                        DEC DI
                        DEC DI
                        MOV [DI], BX
                        INC DI
                        INC DI
                        jmp move_again

                    move_end:
                        MOV [SI], AX

                    pop dx
                    pop cx
                    pop bx
                    pop ax
        jmp outer_loop
    outer_loop_ends:

    LEA SI, ARRAY
    MOV CX, BX
    loop_print:
        MOV BX, [SI]
        call printHexadecimalNumberFunction
        INC SI
        INC SI
        LEA DX, NEWL
        MOV AH, 09H
        INT 21H
        LOOP loop_print

endl:
    MOV AH, 4CH
    INT 21H
END
