.MODEL SMALL
.STACK 100H

.DATA
    NEWL DB 13, 10, "$"  ; Carriage return and linefeed = Newline
    DESTRUCTIVE_BACKSPACE DB " ", 8, "$"  ; Space, destructive backspace -> after user gives a non-destructive backspace

    inp_orig_str DB "Enter original string: $"
    inp_del_str DB "Enter deleting string: $"

    res DB "Output String: $"

    ORG_STR DB 255 DUP('$')
    DEL_STR DB 255 DUP('$')
    RES_STR DB 255 DUP('$')  ; Result String
    DEL_STR_LEN DW 0

    ORG_PTR DW 0
    RES_PTR DW 0

    

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


startLabel:
    print_prompt inp_orig_str
    LEA SI, ORG_STR
    CALL bufferedInputFunction

    print_prompt inp_del_str
    LEA SI, DEL_STR
    CALL bufferedInputFunction

    MOV DEL_STR_LEN, BX  ;;;; length of the string

    print_prompt NEWL


    ;;;Varaibles i = 0; j = 0
    LEA SI, ORG_STR
    MOV ORG_PTR, SI
    LEA SI, RES_STR
    MOV RES_PTR, SI

    mainLoop:

        ;;; PTR -> MOV
        ;;; STR -> LEA

        MOV SI, ORG_PTR
        MOV AH, [SI]
        CMP AH, '$'
        JE loop_end

        MOV SI, ORG_PTR 
        LEA DI, DEL_STR

        checkLoop:
            MOV AH, [SI]
            MOV AL, [DI]

            CMP AH, '$'
            JNE orig_not_end
                CMP AL, '$'
                JE del_ended  ;;; del ended, orig ended
                JMP no_match  ;;; del not ended, string ended
            orig_not_end:
            CMP AL, '$'
            JE del_ended  ;;; del ended, orig ended


            CMP AH, AL ;;; both dint end.. continue
            JE cur_match ;;match
            JMP no_match ;;nomatch

            cur_match:
            INC SI
            INC DI
            JMP checkLoop 

            del_ended:
            JMP match



        match:
            MOV AX, DEL_STR_LEN
            ADD ORG_PTR, AX
            JMP mainLoop


        no_match:
            MOV SI, ORG_PTR
            MOV DI, RES_PTR
            MOV AH, [SI]
            MOV [DI], AH
            INC ORG_PTR
            INC RES_PTR
            JMP mainLoop

loop_end:
    MOV DI, RES_PTR
    MOV AL, '$'
    MOV [DI], AL


    print_prompt res
    LEA DX, RES_STR
    MOV AH, 09H
    INT 21H

endingLabel:
    MOV AH, 4CH
    INT 21H

END