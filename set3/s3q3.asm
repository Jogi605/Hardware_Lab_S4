section .data
     msg1: db "Enter size of array:",10
       l1: equ $-msg1

     msg4: db "Enter the elements:",10
        l4: equ $-msg4

    msg2: db "The sum is:",10
       l2: equ $-msg2
 
     msg3: db "The average is:", 10
        l3: equ $-msg3

     newline: db 0Ah
          nl: equ $-newline

       space: db ' '
          sl: equ $-space

section .bss
    arr: resd 100
     jr: resd 1
     jp: resd 1
   temp: resd 1
 counter: resd 1
     avg: resd 1
     sum: resd 1
       a: resd 1

section .text
     global _start:
_start:
      mov eax, 4
      mov ebx, 1
      mov ecx, msg1
      mov edx, l1
      int 80h

   call read_num
       mov eax, dword[jr]
       mov dword[a], eax

      mov eax, 4
      mov ebx, 1
      mov ecx, msg4
      mov edx, l4
      int 80h

      mov ebx, arr
      mov eax, 0

    call read_array
    call sum_array
   
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, l2
    int 80h

     mov eax,dword[sum]
     mov dword[jp], eax
     call print_num

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, nl
    int 80h

    mov ebx, arr
    mov eax, 0

    mov eax, 4
    mov ebx, 1
    mov ecx, msg3
    mov edx, l3
    int 80h
 
    mov edx, 0
    mov eax, dword[sum]
    mov ebx, dword[a]
    div ebx
    mov dword[avg],eax
    mov dword[jp],eax
    call print_num

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, nl
    int 80h
  
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
			mov edx, sl
			int 80h
		
			mov eax, dword[temp]
			mov ebx, arr

			inc eax
			jmp printarr
		
		end_print_array:
				popa
				ret		

sum_array:
  pusha
    mov ebx, arr
    mov eax, 0
    mov dword[sum],0
   
    loop_for:
         cmp eax, dword[a]
         je end_sum_array
         mov ecx, dword[ebx+4*eax]
         add dword[sum],ecx
         inc eax
         jmp loop_for
 
   end_sum_array:       
       mov eax, dword[sum]
       mov dword[sum],eax
       popa
       ret
        
