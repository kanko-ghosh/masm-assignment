.model small
.stack 100h
.data
	err db"Not an uppercase character$"
	ques db"Enter an uppercase character: $"
	output db"The lowercase character is: $"
.code
main proc
	mov ax,@data
	mov ds,ax
	lea dx,ques
	mov ah,09h
	int 21h
;at this moment the question is printed
	
	mov ah,01h
	int 21h
	mov bl,al
	mov dl,0ah	
	mov ah,02h
	int 21h
	mov dl,0dh
	mov ah,02h
	int 21h
;at this moment ready for input
	cmp bl, 'A'
	jnl nextcheck
	lea dx,err
	mov ah,09h
	int 21h
	jmp endl

nextcheck:
	cmp bl, 'Z'
	jng valid
	lea dx,err
	mov ah,09h
	int 21h
	jmp endl
valid:
	add bl,32
	lea dx,output
	mov ah,09h
	int 21h
	mov dl,bl
	mov ah,02h
	int 21h
endl:
	mov ah,4ch
	int 21h
	main endp
end