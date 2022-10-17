.MODEL SMALL
.STACK 100H

.DATA
    NEWL DB 13, 10, "$" 
    SPACE DB "  $"

    TELL1 DB "Prime Numbers are: $"



.CODE
    MOV AX, @DATA  ; for moving data to data segment
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


isPrimeFunction:
    push ax
    push bx
    ; Sets DX to 0001H if prime else 0000H
    CMP AX, 0001H
    JA prime_start

    ; Base Case <= 1 is not prime
    XOR DX, DX
    JMP ret_label

    prime_start:
    MOV BX, 0001H

        loop_calc:
        INC BX
        CMP BX, AX
        JB continue

        ; No factors - Prime
        MOV DX, 0001H
        JMP ret_label

        continue:
        PUSH AX

        XOR DX, DX
        DIV BX

        POP AX
        CMP DX, 0000H
        JNE notAFactorLabel

        XOR DX, DX  ; Not Prime
        JMP ret_label

        notAFactorLabel:
        JMP loop_calc

    ret_label:
    pop bx
    pop ax
    RET




startLabel:

    print_prompt TELL1
    print_prompt NEWL

    MOV AX, 0001H

mainLoopLabel:

    CMP AX, 0063H 
    JA endl

    INC AX

    CALL isPrimeFunction

    ;;; DX == 0 -> prime, else not prime
    CMP DX, 0001H
    JNE mainLoopLabel

    CALL printDecimalNumberFunction

    print_prompt SPACE
    JMP mainLoopLabel



    ; Exit
endl:
    MOV AH, 4CH
    INT 21H

END