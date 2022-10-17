.MODEL SMALL
.STACK 100H

.DATA
    NEWL DB 13, 10, "$"  
    TELL1 DB "Required pairs are: $"
    COMMA DB " , $"
    BRS DB "( $"
    BRE DB " )$"

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
    print_prompt TELL1
    print_prompt NEWL

    XOR AX, AX

mainLoopLabel:
    CMP AX, 0064H  
    JA endingLabel;

    print_prompt BRS
    CALL printDecimalNumberFunction
    print_prompt COMMA
        PUSH AX
        MOV CX, 0064H
        SUB CX, AX
        MOV AX, CX
    CALL printDecimalNumberFunction
    print_prompt BRE
        POP AX
        ADD AX, 0002H
    JMP mainLoopLabel

    
endingLabel:
    MOV AH, 4CH
    INT 21H

END