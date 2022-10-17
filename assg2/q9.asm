.MODEL SMALL
.STACK 100H

.DATA
    NEWL DB 13, 10, "$"  ; Carriage return and linefeed = Newline

    Q1 DB "Number of elements: $"
    Q2 DB "Enter array elements: $"
    Q3 DB "Enter search element: $"
    found_res DB "Array element found in position = $"
    not_found_res DB "Array element not found ...$"
    empty DB "Array is empty , no need of searching $"
    TELL5 DB "0H$"

    ARRAY DW 250 DUP(0)

    

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




linearSearchFunction:
    ; Returns (pushed in stack) DX = 1 indexed position if found else DX = 0
    POP DI  ; Return Address
    POP SI  ; Array Address
    POP BX  ; Size of Array
    POP CX  ; Search Element
    PUSH DI  ; Return Address

    XOR DX, DX
    XOR DI, DI
        linearSearchLoopLabel:
        INC DI
        DEC BX

        JS linearSearchDoneLabel

        CMP [SI], CX
        JNE linearSearchNotEqualLabel

        ; Found ...
        MOV DX, DI
        JMP linearSearchDoneLabel

        linearSearchNotEqualLabel:
        ADD SI, 02H
        JMP linearSearchLoopLabel

    linearSearchDoneLabel:
    POP DI  ; Return Address
    PUSH DX
    PUSH DI  ; Return Address
    RET




binarySearchFunction:
    POP DX  ;;;Return Address
    POP BX  ;;;Starting Index
    POP CX  ;;;Ending Index
    POP DI  ;;;Search Element
    PUSH DX ;;;Return Address

    XOR DX, DX
    CMP BX, CX
    JB contLabel1

    ; Base Case (left == right)
    LEA SI, ARRAY
    SUB SI, 02H  ; To compensate for 1-indexed indexing
    SHL BX, 1
    ADD SI, BX

    CMP [SI], DI
    JNE baseCaseNotEqual

    ; Equal - Found
    MOV DX, CX

    baseCaseNotEqual:
    JMP bs_done

    contLabel1:
    MOV AX, BX
    ADD AX, CX
    SHR AX, 1  ; MidPoint

    LEA SI, ARRAY
    SUB SI, 02H  ; To compensate for 1-indexed indexing
    SHL AX, 1
    ADD SI, AX
    SHR AX, 1

    CMP DI, [SI]
    JA caseGreaterLabel
    JB caseBelowLabel

    ; Equal - Found
    MOV DX, AX
    JMP bs_done

    caseGreaterLabel:
    PUSH DI
    PUSH CX
    INC AX
    PUSH AX
    CALL binarySearchFunction
    POP DX
    JMP bs_done

    caseBelowLabel:
    PUSH DI
    DEC AX
    PUSH AX
    PUSH BX
    CALL binarySearchFunction
    POP DX
    JMP bs_done

    bs_done:
    POP DI  ; Return Address
    PUSH DX
    PUSH DI  ; Return Address
    RET




    ; Main .....................................................................................................................
startLabel:

    print_prompt Q1
    CALL inputHexadecimalNumberFunction

    CMP BL, 00H
    JNE continueLabel

    print_prompt empty
    print_prompt NEWL

    JMP endingLabel

; _________________________________________________________________________________________________________________________

    
    continueLabel:
    MOV CX, BX
    MOV AH, CL

    LEA SI, ARRAY

    print_prompt Q2
    print_prompt NEWL

loopInputLabel:
    PUSH AX
    CALL inputHexadecimalNumberFunction
    POP AX

    MOV [SI], BX
    ADD SI, 02H

    LOOP loopInputLabel


    print_prompt NEWL
    print_prompt Q3

    PUSH AX
    CALL inputHexadecimalNumberFunction
    POP AX

    ; Setting size in AX
    MOV AL, AH
    XOR AH, AH

    PUSH BX  
    PUSH AX  
    PUSH BX  ;;;Search Element
    PUSH AX  ;;;Size of array

    LEA SI, ARRAY
    PUSH SI
    CALL linearSearchFunction
    POP AX

    CMP AX, 0000H
    JE linear_not_found

    ; Found
    MOV BX, AX
    print_prompt found_res
    CALL printHexadecimalNumberFunction
    print_prompt NEWL
    JMP linearDoneLabel

linear_not_found:
    print_prompt not_found_res


linearDoneLabel:

    MOV AX, 0001H ;; starting pointer
    PUSH AX
    CALL binarySearchFunction
    POP AX

    CMP AX, 0000H
    JE myBinaryNotFoundLabel

    ; Found
    MOV BX, AX
    print_prompt found_res
    CALL printHexadecimalNumberFunction
    JMP BinaryDoneLabel

myBinaryNotFoundLabel:
    print_prompt not_found_res

BinaryDoneLabel:
    print_prompt NEWL

endingLabel:
    MOV AH, 4CH
    INT 21H

END