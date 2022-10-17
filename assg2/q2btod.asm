.model small
.stack 100h
.data
    INPUT1 DB "Enter a Binary Number: $"
    OUTPUT1 DB "Required binary number: $"
    NEWL DB 13, 10, "$"
.code
    MOV AX, @DATA
    MOV DS, AX

    JMP startLabel

inputBinaryNumberFunction:
    XOR BX, BX
    
    inputNumberLabel:
        MOV AH, 01H
        INT 21H

        CMP AL, 0DH
        JE inputNumberDone

        CMP AL, '0'
        JL others
        CMP AL, '1'
        JG others

        SUB AL, '0'
        JMP appendToNum
    others:
        MOV AL, 01H

    appendToNum:
        SHL BX, 1
        ADD BL, AL
        JMP inputNumberLabel
    inputNumberDone:
        RET
        
printDecimalNumberFunction:
    push ax
    push bx
    push cx
    push dx
        CMP AX, 0000H
        JNE contLabel1
        MOV AH, 02H
        MOV DL, '0'
        INT 21H
        JMP exit
        contLabel1:
        MOV CX, 0
        MOV DX, 0
        label1:
            cmp ax,0
            je print1     
            mov bx,10       
            div bx                 
            push dx             
            inc cx             
            xor dx,dx
            jmp label1
        print1:
            cmp cx,0
            je exit
            pop dx
            add dx,48
            mov ah,02h
            int 21h
            dec cx
            jmp print1
        exit:
    pop dx
    pop cx
    pop bx
    pop ax
            RET


startLabel:


    LEA DX, INPUT1
    MOV AH, 09H
    INT 21H

    call inputBinaryNumberFunction
    
    LEA DX, OUTPUT1
    MOV AH, 09H
    INT 21H

    MOV AX, BX

    call printDecimalNumberFunction

    MOV AH, 4CH
    INT 21H 
END