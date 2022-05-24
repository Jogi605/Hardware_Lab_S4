section .data
	str1:db 'Enter elements to be inserted: ',10
	l2: equ $-str1
	str2:db 'Largest element is: '
	l3: equ $-str2
	str3:db 'Smallest element is: '
	l4: equ $-str3
	space: db ' '
    sl: equ $-space
	newline: db 10
	sn: equ $-newline
	zero1: db 30h
    n: dd 10

section .bss
	arr: resd 50
	counter: resd 1
	jr: resd 1
	jp: resd 1
	digit: resd 1
	min: resd 1
	max: resd 1
	temp: resd 1
        zero:resd 1 

section .text
global _start
_start:
	mov eax,4
	mov ebx,1
	mov ecx,str1
	mov edx,l2
	int 80h
	call read_array
	
	call min_max
	mov eax,dword[min]
	mov dword[jp],eax
	mov eax,4
	mov ebx,1
	mov ecx,str3
	mov edx,l4	
	int 80h

	call print_num

	mov eax,4
	mov ebx,1
	mov ecx,newline
	mov edx,sn
	int 80h
	
	mov eax,dword[max]
	mov dword[jp],eax
	mov eax,4
	mov ebx,1
	mov ecx,str2
	mov edx,l3
	int 80h
	call print_num

	call exit

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
    mov dword[zero],30h
    mov eax, 4
    mov ebx, 1
    mov ecx, zero
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
                          mov eax, 4
                          mov ebx, 1
                          mov ecx, 0Ah
                          mov edx, 1
                          int 80h				
                                popa
				ret

read_array:
    pusha
    mov ebx, arr
    mov eax, 0
	readarr:
		cmp eax, dword[n]
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
			cmp eax, dword[n]
			je end_print_array
			mov ecx, dword[ebx+4*eax]
			mov dword[jp], ecx
			call print_num
			
		        mov dword[temp], eax
		        mov eax, 4
			mov ebx, 1
			mov ecx, space
			mov edx, sl
			int 80h
		
			mov eax, dword[temp]
			mov ebx, arr

			inc eax
			jmp printarr
		
		end_print_array:
				popa
				ret		

min_max:
	pusha
	mov ebx,arr
	mov eax,0
	mov dword[min],9999
	mov dword[max],0
	loops:
		cmp eax,dword[n]
		jnb end_1
		mov ecx,dword[ebx+4*eax]
		cmp ecx,dword[min]
		jb if
		jmp maxi
		if:
			mov dword[min],ecx
			jmp maxi
		maxi:
		cmp ecx,dword[max]
		ja if_1
		inc eax
		jmp loops
		if_1:
			mov dword[max],ecx
			inc eax
			jmp loops
	end_1:
		popa
		ret

exit:
	mov eax,1
	mov ebx,0
	int 80h 
