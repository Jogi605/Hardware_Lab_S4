section .data
msg1 : db 'Enter the string: '
l1 : equ $-msg1
msg2: db "The lexicographical order:"
 l2: equ $-msg2
newline : db 0ah
space: db " "

section .bss
string : resb 100
n1 : resb 1
string_length : resb 1
word_addresses: resd 20
word_count : resb 1
temp : resb 1
min : resb 1
min_address : resd 1
n2 : resb 1
i1 : resb 1
i2 : resb 1

section .text
	global _start:
	_start:


	mov eax, 4
	mov ebx, 1
	mov ecx, msg1
	mov edx, l1
	int 80h

	mov ebx, string
	call read_string
	mov al, byte[string_length]
	mov byte[n1], al

        mov eax, 4
        mov ebx, 1
        mov ecx, msg2
        mov edx, l2
        int 80h

	mov ebx, string
	mov edx, word_addresses
	mov byte[word_count], 0
	classification:	
	cmp byte[ebx], 0h
	je end_classification
	cmp byte[ebx], ' '
	jne word_found
	inc ebx
	jmp classification

		word_found:
		mov dword[edx], ebx
		add edx, 4
		inc byte[word_count]
		call find_next_word
		jmp classification


	end_classification:
	mov al, byte[word_count]
	mov byte[n2], al

	start_lexico:
	mov eax, word_addresses
	cmp byte[word_count], 0
	je end_program

	lexico_1:
	cmp dword[eax], 0
	je next_address
	mov ebx, dword[eax]
	mov cl, byte[ebx]
	mov byte[min], cl
	mov dword[min_address], ebx
	add eax, 4
	mov dl, 1
	jmp start_comparing



				next_address:
				add eax, 4
				jmp lexico_1



	start_comparing:
	cmp dl, byte[word_count]
	je end_comparing
	cmp dword[eax], 0
	je next_address_1
	mov ebx, dword[eax]
	call compare_strings
	add eax, 4
	inc dl
	jmp start_comparing


				next_address_1:
				add eax, 4
				jmp start_comparing
	end_comparing:
	mov ebx, dword[min_address]
	call print_string
	mov dl, 0
	call remove_word
	dec byte[word_count]
	jmp start_lexico


	end_program:
        mov eax, 4
        mov ebx, 1
        mov ecx, newline
        mov edx, 1
        int 80h

	mov eax, 1
	mov ebx, 0
	int 80h

	compare_strings:
	pusha
	call find_length
	mov byte[i1], al 
	mov edx, dword[min_address]
	push ebx
	mov ebx, edx
	call find_length
	mov byte[i2], al
	pop ebx
	mov al, 0

	start_strcmp:
	cmp al, byte[i1]
	je i1_first
	cmp al, byte[i2]
	je i2_first
	mov cl, byte[ebx]
	cmp cl, byte[edx]
	ja i2_first
	cmp cl, byte[edx]
	jb i1_first
	inc ebx
	inc edx
	inc al
	jmp start_strcmp


	i2_first:
	popa
	ret


	i1_first:
	popa
	mov dword[min_address], ebx
	ret



	find_length:
	pusha
	mov byte[temp], 0

	start_find_length:
	cmp byte[ebx], ' '
	je end_find_length
	cmp byte[ebx], 0h
	je end_find_length
	inc byte[temp]
	inc ebx
	jmp start_find_length

	
	end_find_length:
	mov al, byte[temp]
	popa 
	ret
		

	remove_word:
	mov ebx, word_addresses

	start_remove_word:
	cmp dl, byte[n2]
	je end_remove_word_1
	mov eax, dword[ebx]
	cmp dword[min_address], eax
	je end_remove_word
	add ebx, 4
	jmp start_remove_word


	end_remove_word:
	mov dword[ebx], 0
	ret

	end_remove_word_1:
	ret


	find_next_word:
	inc ebx
	cmp byte[ebx], ' '
	je end_find_next_word
	cmp byte[ebx], 0h
	je end_find_next_word
	jmp find_next_word

	end_find_next_word:	
	ret


	read_string:
	pusha
	mov byte[string_length], 0

	start_read_string:
	push ebx
	mov eax, 3
	mov ebx, 0
	mov ecx, temp
	mov edx, 1
	int 80h

	pop ebx
	cmp byte[temp], 0ah
	je end_read_string
	inc byte[string_length]
	mov al, byte[temp]
	mov byte[ebx], al
	inc ebx
	jmp start_read_string


	end_read_string:
	mov byte[ebx], 0h
	popa
	ret


	print_string:
	pusha

	start_print_string:
	mov al, byte[ebx]
	mov byte[temp], al
	cmp byte[temp], 0h
	je end_print_string
	cmp byte[temp], ' '
	je end_print_string
	
	push ebx
	mov eax, 4
	mov ebx, 1
	mov ecx, temp
	mov edx, 1
	int 80h
	
	pop ebx
	inc ebx
	jmp start_print_string


	end_print_string:
	mov eax, 4
	mov ebx, 1
	mov ecx, space
	mov edx, 1
	int 80h
	popa 
	ret
