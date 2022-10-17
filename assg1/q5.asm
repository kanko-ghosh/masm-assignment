.model small
.stack 100h
.data
	TER db "Program Terminating: $"
.code
	main proc
	mov ax,@data
	mov ds,ax
	lea dx,TER
	mov ah,09h
	int 21h
	mov ah,4ch
	int 21h
	main endp
end