.model small
.stack 100h
.data
    ; oldfn db 'hello.txt$'
    ; newfn db 'welcome.txt$'
    oldfn db 255 dup(0)
    newfn db 255 dup(0)
    ok db 'file renamed $'
    notok db 'file not renamed $'
    TELL1 DB "Enter original file name (full path) to rename: $"
    TELL2 DB "Enter new file name: $"
    DESTRUCTIVE_BACKSPACE DB " ", 8, "$"  ; Space, destructive backspace -> after user gives a non-destructive backspace
.code

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
begin:
    jmp cont
bufferedInputFunction:
    MOV BX, 0000H
    loopBufferedInputLabel:
    MOV AH, 01H
    INT 21H

    CMP AL, 0DH
    JE loopBufferedInputCompleteLabel
    MOV [SI], AL
    INC SI
    INC BX
    JMP loopBufferedInputLabel
    loopBufferedInputCompleteLabel:
    MOV AL, '$'
    MOV [SI], AL  ; '$' at end
    RET




cont:
    mov ax, @data
    mov ds, ax
    mov es, ax

    print_message TELL1
    
    lea si, oldfn
    call bufferedInputFunction

    print_message TELL2

    lea si, newfn
    call bufferedInputFunction

    mov dx, offset oldfn
    mov di, offset newfn
    mov ah, 56h
    int 21h
    jc error
    mov dx, offset ok
    mov ah, 09
    int 21h
    jmp over

error:
    mov dx, offset notok
    mov ah, 09
    int 21h

over:
    mov ah, 4ch
    int 21h
end begin