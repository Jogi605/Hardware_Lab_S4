section .data
      msg1: db "Enter the string:", 10
        l1: equ $-msg1

     msg2: db "The reversed string is:",
       l2: equ $-msg2

     zero: db '0'
     space: db " "
    newline: db 0Ah

section .bss
     str: resb 500
    rev: resb 500
     n1: resw 1
     n : resw 1
     i : resw 1
     j : resw 1
    str1: resb 500
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
    
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, l2
    int 80h
  
     mov ebx, str
     mov edx,str1
     call copy_string

     mov ebx, str1
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



copy_string:
          pusha
          mov edx, str1
          mov cx, word[n]
          dec cx
          mov word[i], cx
reverse_loop:
         mov cx, word[i]
        cmp cx,-1
        je end_rm_loop
        movzx eax,word[i]
	mov al,byte[ebx+eax]
        cmp al, 65
         jb next
        cmp al, 122
         ja next
        cmp al, 91
         jb copy
        cmp al, 96
         ja copy
         jmp next
next:	
	dec word[i]
	jmp reverse_loop		
	
copy:
       mov al, byte[ebx+eax]
       mov byte[edx], al
       inc edx
       dec word[i]
       jmp reverse_loop
	
end_rm_loop:
        mov byte[edx],0
	popa
	ret

print_string:
          pusha
          mov word[i], 0
          mov ebx, str1
  start_loop:
           mov ebx, str1
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
