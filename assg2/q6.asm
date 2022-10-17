.MODEL SMALL
.STACK 100H

.DATA
    NEWL DB 13, 10, "$" 
    SPACE DB " $"

    START DB "Fibonacci Numbers are $"
    BASE_CASE DB "0 1 $"

    

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
    print_prompt START 
    print_prompt NEWL
    print_prompt BASE_CASE

    XOR AX, AX
    PUSH AX ;0
    INC AX
    PUSH AX ;1

    MOV CX, 0008H  ; # Still left to print

mainLoopLabel:
    POP BX 
    POP AX  
    ADD AX, BX
    PUSH BX
    PUSH AX

    CALL printDecimalNumberFunction
    print_prompt SPACE
    
    LOOP mainLoopLabel

    MOV AH, 4CH
    INT 21H
END