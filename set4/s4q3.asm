section .data
      msg1: db "Enter the string1:", 10
        l1: equ $-msg1

      msg2: db "Enter the string2:", 10
        l2: equ $-msg2

     msg3: db "The concatenated string is:",
       l3: equ $-msg3

     zero: db '0'
     space: db " "
    newline: db 0Ah

section .bss
     str: resb 500
    con: resb 1000
    str2: resb 500
     n1: resw 1
     n : resw 1
     i : resw 1
     j : resw 1
     temp : resb 1
     char: resb 1
     num : resw 1
     count : resw 1
     dig : resb 1

section .text
  global _start
_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, l1
    int 80h

     call read_string1
    
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, l2
    int 80h
  
     call read_string2
      mov esi ,con
     call combine_string

    mov eax, 4
    mov ebx, 1
    mov ecx, msg3
    mov edx, l3
    int 80h

     call print_string
exit: 
     mov eax, 4
     mov ebx, 1
     mov ecx, newline
    mov edx, 1
    int 80h

   mov eax, 1
   mov ebx, 0
   int 80h


read_string1:
         pusha
        mov word[n], 0
   loop1:
       mov eax, 3
       mov ebx, 0
       mov ecx, temp
       mov edx, 1
       int 80h

      cmp byte[temp], 10
      je end_read_string1

      mov ebx, str
      movzx eax, word[n]
      mov cl, byte[temp]
      mov byte[ebx+eax], cl
      inc word[n]
      jmp loop1

  end_read_string1:
               
                mov ebx, str
         	movzx eax, word[n]
	       mov byte[ebx+eax], 0
                popa
                ret

read_string2:
         pusha
        mov word[n1], 0
   loop2:
       mov eax, 3
       mov ebx, 0
       mov ecx, temp
       mov edx, 1
       int 80h

      cmp byte[temp], 10
      je end_read_string2

      mov ebx, str2
      movzx eax, word[n1]
      mov cl, byte[temp]
      mov byte[ebx+eax], cl
      inc word[n1]
      jmp loop2

  end_read_string2:

                mov ebx, str2
                movzx eax, word[n1]
               mov byte[ebx+eax], 0
                popa
                ret



combine_string:
          pusha
         mov esi, con
         mov edi, 0
         mov word[i], 0
copy_loop1:
        mov ebx, str
        movzx  eax, word[i]
	cmp byte[ebx+eax], 0
	je end_copy_loop1
	
	mov cl,byte[ebx+eax]
	mov byte[esi+edi],cl	
	inc word[i]
        inc edi
	jmp copy_loop1	

end_copy_loop1:
          mov word[i], 0
copy_loop2:
        mov ebx, str2
        movzx  eax, word[i]
        cmp byte[ebx+eax], 0
        je end_loop

        mov cl,byte[ebx+eax]
        mov byte[esi+edi],cl
        inc word[i]
        inc edi
        jmp copy_loop2

         
end_loop:
         mov esi, con
        mov byte[esi+edi], 0
        popa
        ret

print_string:
          pusha
          mov word[i], 0
          mov ebx, con
  start_loop:
           mov ebx, con
           movzx eax, word[i]
           cmp byte[ebx+eax], 0
           je end_print_loop
           mov cl, byte[ebx+eax]
           mov byte[temp], cl
           mov eax, 4
           mov ebx, 1
           mov ecx, temp
           mov edx, 1
           int 80h
           inc word[i]
           jmp start_loop
end_print_loop:
             popa
             ret 

