section .data
msg1: db 'Enter the size of the array',0Ah
sz_msg1: equ $-msg1
msg2: db 'Enter the elements',0Ah
sz_msg2: equ $-msg2
msg3: db 'The Array is',0Ah
sz_msg3: equ $-msg3
msg4: db 'The Average of the elements is:'
sz_msg4: equ $-msg4
newline: db 0Ah
sz_newline: equ $-newline
msg5: db 'The above averge numbers are',0Ah
sz_msg5: equ $-msg5
space: db ' '
sz_space: equ $-space

section .bss
arr: resd 50
jr: resd 1
jp: resd 1
counter: resd 1
temp: resd 1
a: resd 1
avg: resd 1

section .text
global _start:
_start:

mov eax, 4
mov ebx, 1
mov ecx, msg1
mov edx, sz_msg1
int 80h

call read_num
mov eax, dword[jr]
mov dword[a], eax

mov eax, 4
mov ebx, 1
mov ecx, msg2
mov edx, sz_msg2
int 80h


call read_array

call average

mov eax, 4
mov ebx, 1
mov ecx, msg4
mov edx, sz_msg4
int 80h

mov eax, dword[avg]
mov dword[jp], eax
call print_num

mov eax, 4
mov ebx, 1
mov ecx, newline
mov edx, sz_newline
int 80h

mov eax, 4
mov ebx, 1
mov ecx, msg5
mov edx, sz_msg5
int 80h


call aboveavg


mov eax, 4
mov ebx, 1
mov ecx, newline
mov edx, sz_newline
int 80h


;mov eax, 4
;mov ecx, 1
;mov ecx, msg3
;mov edx, sz_msg3
;int 80h

;call print_array

mov eax, 1
mov ebx, 0
int 80h

read_num:
pusha
mov dword[jr], 0
	
		reading:
			mov eax, 3
			mov ebx, 0
			mov ecx, temp
			mov edx, 1
			int 80h
			cmp dword[temp], 10
			je end_read
			sub dword[temp], 30h
			mov eax, dword[jr]
			mov ebx, 10
			mov edx, 0
			mul ebx
			add eax, dword[temp]
			mov dword[jr], eax
			jmp reading
		
		end_read:
			popa
			ret

print_num:
pusha
mov dword[counter], 0
cmp dword[jp], 0
jne extracting
mov eax, 4
mov ebx, 1
mov ecx, 0
mov edx, 1
int 80h
jmp end_print
		
		extracting:
				cmp dword[jp], 0
				je printing
				mov eax, dword[jp]
				mov ebx, 10
				mov edx, 0
				div ebx
				push edx
				mov dword[jp], eax
				inc dword[counter]
				jmp extracting
		printing:
				cmp dword[counter], 0
				je end_print
				pop edx
				mov dword[temp], edx
				add dword[temp], 30h
				mov eax, 4
				mov ebx, 1
				mov ecx, temp
				mov edx, 1
				int 80h
				dec dword[counter]
				jmp printing
		end_print:	
				popa
				ret
				

read_array:
pusha
mov ebx, arr
mov eax, 0
	readarr:
		cmp eax, dword[a]
		je end_read_array
		call read_num
		mov ecx, dword[jr]
		mov dword[ebx+4*eax], ecx
		inc eax
		jmp readarr

	end_read_array:
			popa 
			ret

print_array:
pusha
mov ebx, arr
mov eax, 0
		printarr:
			cmp eax, dword[a]
			je end_print_array
			mov ecx, dword[ebx+4*eax]
			mov dword[jp], ecx
			call print_num
			
		        mov dword[temp], eax
		        mov eax, 4
			mov ebx, 1
			mov ecx, space
			mov edx, sz_space
			int 80h
		
			mov eax, dword[temp]
			mov ebx, arr

			inc eax
			jmp printarr
		
		end_print_array:
				popa
				ret		
average:
pusha
mov ebx, arr
mov eax, 0
mov dword[avg], 0

		iterating:
			  cmp eax, dword[a]
			  je end_average
			  mov ecx, dword[ebx+4*eax]
			  add dword[avg], ecx
			  inc eax
			  jmp iterating

		end_average:
			    mov eax, dword[avg]
			    mov ebx, dword[a]
			    mov edx, 0
			    div ebx
			    mov dword[avg], eax
			    popa
			    ret
aboveavg:
pusha
mov ebx, arr
mov eax, 0
		iter2:
			cmp eax, dword[a]
			je end_aboveavg
			
			mov ecx, dword[ebx+4*eax]
			cmp ecx, dword[avg]
			ja printabove
			
			inc eax
			jmp iter2
		
		printabove:
			    mov dword[jp], ecx
			    call print_num
			  
			    mov dword[temp], eax
			    mov eax, 4
			    mov ebx, 1
			    mov ecx, space
			    mov edx, sz_space
			    int 80h
		
			    mov eax, dword[temp]
			    mov ebx, arr

			    inc eax
			    jmp iter2

		end_aboveavg:
			     popa
			     ret			

