.model small
.stack 100h
.data
	EQTE db 0dh, 0ah, "Enter q to exit: ", "$"
	TA db 0dh, 0ah, "Try Again: ", "$"
.code
	main proc
	mov ax,@data
	mov ds,ax
	jmp start
	loop1:
		lea dx,TA
		mov ah,09h
		int 21h
	start:
		lea dx,EQTE
		mov ah,09h
		int 21h
		mov ah,01h
		int 21h
		cmp al,'q'
		jne loop1
		mov ah,4ch
		int 21h
		main endp
end