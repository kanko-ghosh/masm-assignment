.model small
.stack 100h
.data
    INPUT1 DB "Enter a Decimal Number: $"
    OUTPUT1 DB "Required binary number: $"
    NEWL DB 13, 10, "$"
    TELL5 DB "0H$"
.code
    MOV AX, @DATA
    MOV DS, AX

    JMP startLabel

inputDecimalNumberFunction:
    XOR BX, BX
    
    inputNumberLabel:
        MOV AH, 01H
        INT 21H

        CMP AL, 0DH
        JE inputNumberDone

        CMP AL, '0'
        JL others
        CMP AL, '9'
        JG others

        SUB AL, '0'
        JMP appendToNum
    others:
        MOV AL, 09H

    appendToNum:
        MOV AH, 0H
        MOV CX, 09H
        MOV DX, BX
        LOOPS1:
            ADD BX, DX
		    loop LOOPS1
        ADD BX, AX
        JMP inputNumberLabel
    inputNumberDone:
        RET
        
printBinaryNumberFunction:
    ;in BX
    MOV CX, 10H
    LOOPS:
        SHL BX, 1
        JC printone
        JNC printzero
    printzero:
        MOV DL, 30H
        MOV AH, 02H
        INT 21H
        JMP retprint
    printone:
        MOV DL, 31H
        MOV AH, 02H
        INT 21H
        JMP retprint
    retprint:
        loop LOOPS
    
    RET





startLabel:

    LEA DX, INPUT1
    MOV AH, 09H
    INT 21H

    call inputDecimalNumberFunction

    LEA DX, OUTPUT1
    MOV AH, 09H
    INT 21H

    call printBinaryNumberFunction

    MOV AH, 4CH
    INT 21H 
END