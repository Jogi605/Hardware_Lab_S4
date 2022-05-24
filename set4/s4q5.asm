section .data
newline : db 0Ah
zero : db '0'
space : db ' '
msg1: db "Enter the string:", 10
  l1: equ $-msg1
msg2: db "The number of spaces are:"
  l2: equ $-msg2

section .bss
str : resb 500
n : resw 1
i : resw 1
tmp : resb 1
cnta : resw 1
num : resw 1
count : resw 1
dig : resb 1

section .text
global _start

_start :
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, l1
   int 80h

call read

cmp word[n], 0
jne countcall
mov word[num], 0
call print_num
jmp exit

countcall:
call counter
      mov eax, 4
      mov ebx, 1
      mov ecx, msg2
      mov edx, l2
      int 80h

mov cx, word[cnta]
mov word[num], cx
call print_num

exit :
	mov eax, 1
	mov ebx, 0
	int 80h

read :
	pusha
	mov word[n], 0
read_loop :
	mov eax, 3
	mov ebx, 0
	mov ecx, tmp
	mov edx, 1
	int 80h

	cmp byte[tmp], 10
	je end_read

	mov ebx, str
        movzx eax, word[n]
	mov cl, byte[tmp]
        mov byte[ebx+eax], cl

	inc word[n]
	jmp read_loop

end_read :
	mov ebx, str
	movzx eax, word[n]
	mov byte[ebx+eax], 0
	popa
	ret
 	
counter :
	pusha
	mov word[cnta], 0
	mov word[i], 0

count_loop :
	mov ebx, str
	movzx eax, word[i]
	mov cl, byte[ebx+eax]
	
	cmp cl, 0
	je end

	cmp cl, 32
	jne continue
         inc word[cnta]
         inc word[i]
         jmp count_loop
continue :
	inc word[i]
	jmp count_loop
		
end :
	popa
	ret
	

print_num :
	pusha
	mov byte[count], 0
	cmp word[num], 0
	je print0
		
extract_loop : 
	cmp word[num], 0
	je print
	mov ax, word[num]
	mov dx, 0
	mov bx, 10
	div bx
	push dx
	inc byte[count]
	mov word[num], ax
	jmp extract_loop

print :
	cmp byte[count], 0
	je end_print_num
	dec byte[count]
	pop dx
	add dl, 30h
	mov byte[dig], dl
	
	mov eax, 4
	mov ebx, 1
	mov ecx, dig
	mov edx, 1
	int 80h

	jmp print

print0 :
        mov eax, 4
        mov ebx, 1
        mov ecx, zero
        mov edx, 1
        int 80h

end_print_num :
	mov eax, 4
        mov ebx, 1
        mov ecx, newline
        mov edx, 1
        int 80h
	popa
	ret

printnewline :
	pusha
	mov eax, 4
	mov ebx, 1
	mov ecx, newline
	mov edx, 1
	int 80h
	popa 
	ret

