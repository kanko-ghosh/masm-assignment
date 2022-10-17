.MODEL SMALL
.STACK 100H

.DATA
    NEWL DB 13, 10, "$" 
    DESTRUCTIVE_BACKSPACE DB " ", 8, "$"
    MUL1 DB 4 DUP(0)
    MUL2 DB 4 DUP(0)
    PDT DB 8 DUP(0)
    Q DB "Enter 2 hexadecimal numbers (8 digits): $"
     TELL5 DB "0H$"

.CODE


    MOV AX, @DATA
    MOV DS, AX
    JMP startLabel

                print_message macro msg
                    push ax
                    push bx
                    push cx
                    push dx
                    mov ah, 09h
                    lea dx, msg
                    int 21h
                    pop dx
                    pop cx
                    pop bx
                    pop ax
                endm
                
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

add_carry:
    JNC endl
                    push ax
                    push bx
                    push cx
                    push dx
    DEC SI
    MOV DL, 01H
    ADD [SI], DL
    call add_carry
    INC SI
                    pop dx
                    pop cx
                    pop bx
                    pop ax
    endl:
        RET

input32bitFunction:
        ; Setting initial number to 0
        XOR BX, BX
        XOR CX, CX
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
        SHL CX, 1
        SHL BX, 1
        JNC adddone1
        INC CX
        adddone1:
        SHL CX, 1
        SHL BX, 1
        JNC adddone2
        INC CX
        adddone2:
        SHL CX, 1
        SHL BX, 1
        JNC adddone3
        INC CX
        adddone3:
        SHL CX, 1
        SHL BX, 1
        JNC adddone4
        INC CX
        adddone4:
        ADD BL, AL
        JMP inputNumberLabel


    inputNumberDoneLabel:
        RET

printHexadecimalNumberFunction:
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
    inputEndingLabel:
        RET

; inputModFunction1:
;     XOR BX, BX
;     MOV CX, 04H
;     loop_input:
;         MOV AH, 01H
;         INT 21h
;         CMP AL, '0'
;         JL isLetterLabel
;         CMP AL, '9'
;         JG isLetterLabel
;         LOOP loop_input

startLabel:
    print_message Q
    ; call inputModFunction1
    ; call inputModFunction2

    ; debug input already taken!!  

    call input32bitFunction
        LEA SI, MUL1
        MOV [SI], CH
        INC SI
        MOV [SI], CL
        INC SI
        MOV [SI], BH
        INC SI
        MOV [SI], BL
        INC SI

    call input32bitFunction
        LEA SI, MUL2
        MOV [SI], CH
        INC SI
        MOV [SI], CL
        INC SI
        MOV [SI], BH
        INC SI
        MOV [SI], BL
        INC SI

    ;;;;;;;;;;;;; do the multiplication here!!!
    ;;; ok ;;;; double for loop time.. bruh moment here!!!
    ;;; dh -> outer for loop
    ;;; dl -> inner for loop

    MOV dh, 4
    outer_loop:
        DEC DH
        CMP DH, 0H
        JL outer_loop_ends
        MOV DL, 4
        inner_loop:
            DEC DL
            CMP DL, 0H
            JL inner_loop_ends

                ; PUSH DX

                ; MOV BX, DX
                ; MOV BH, 0H
                ; call printHexadecimalNumberFunction

                ; MOV BH, 00H
                ; MOV BL, DH
                ; call printHexadecimalNumberFunction
                ; LEA DX, NEWL
                ; MOV AH, 09H
                ; INT 21H


                ; POP DX

                ;;; DL -> position of MUL1
                LEA SI, MUL1
                MOV BX, DX
                MOV BH, 00H
                ADD SI, BX
                MOV AL, [SI]
                ;;; DH -> position of MUL2
                LEA SI, MUL2
                MOV BL, DH
                MOV BH, 00H
                ADD SI, BX
                MOV BH, [SI]

                ;;; DL+DH+1 -> position of PDT
                MUL BH

                LEA SI, PDT
                MOV CL, DH
                MOV CH, 00H
                ADD SI, CX
                MOV CL, DL
                MOV CH, 00H
                ADD SI, CX
                INC SI
                ADD [SI], AL
                PUSH SI
                call add_carry
                DEC SI
                ADD [SI], AH
                call add_carry
                INC SI
            jmp inner_loop
        inner_loop_ends:

    ;                 push ax
    ;                 push bx
    ;                 push cx
    ;                 push dx
    ; LEA SI, PDT
    ; MOV CX, 8
    ; loop_print_temp:
    ;     MOV BH, 00
    ;     MOV BL, [SI]
    ;     call printHexadecimalNumberFunction
    ;     INC SI
    ;     LOOP loop_print_temp
    ;     print_message NEWL
    ;                 pop dx
    ;                 pop cx
    ;                 pop bx
    ;                 pop ax
        jmp outer_loop
    outer_loop_ends:

    LEA SI, PDT
    MOV CX, 8
    loop_print:
        MOV BH, 00
        MOV BL, [SI]
        call printHexadecimalNumberFunction
        INC SI
        LOOP loop_print
    

    MOV AH, 4CH
    INT 21H
END

