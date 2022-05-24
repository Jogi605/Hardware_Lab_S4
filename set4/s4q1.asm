section .data
      msg1: db "Enter the string:", 10
        l1: equ $-msg1

     msg2: db "It is palindrome", 10
       l2: equ $-msg2

     msg3: db "It is not a palindrome", 10
       l3: equ $-msg3

     zero: db '0'
     space: db " "
    newline: db 0Ah

section .bss
     str: resb 500
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

     call read_string
     call palindrome
exit: 
   mov eax, 1
   mov ebx, 0
   int 80h


read_string:
         pusha
        mov word[n], 0
   loop:
       mov eax, 3
       mov ebx, 0
       mov ecx, temp
       mov edx, 1
       int 80h

      cmp byte[temp], 10
      je end_read_string

      mov ebx, str
      movzx eax, word[n]
      mov cl, byte[temp]
      mov byte[ebx+eax], cl
      inc word[n]
      jmp loop

  end_read_string:
               
                mov ebx, str
         	movzx eax, word[n]
	       mov byte[ebx+eax], 0
                popa
                ret

palindrome:
          pusha
          mov word[i], 0
          mov cx, word[n]
          dec cx
          mov word[j], cx
           
    p_loop:
         mov cx, word[i]
         cmp cx, word[j]
         jnb end_p_loop
        
        mov ebx, str
        movzx eax, word[i]
        mov cl, byte[ebx+eax]
        mov byte[char], cl
     
        movzx eax, word[j]
        mov cl, byte[ebx+eax]
    
       cmp  cl, byte[char]
       je forward
       mov eax, 4
       mov ebx, 1
       mov ecx, msg3
       mov edx, l3
       int 80h
       popa
       ret

 forward:
        inc word[i]
        dec word[j]
        jmp p_loop

end_p_loop:
          mov eax, 4
          mov ebx, 1
          mov ecx, msg2
          mov edx, l2
          int 80h
         popa
         ret




