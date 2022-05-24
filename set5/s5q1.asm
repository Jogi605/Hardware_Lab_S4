section .data
    msg1: db "Enter the string:", 10
      l1: equ $-msg1

    zero: db '0'
     space: db " "
    newline: db 0Ah

    msg2: db "The replaced string is:"
      l2: equ $-msg2
    
section .bss
      str: resb 100
        n: resw 1
      temp: resb 1
      cnt: resd 1
      i: resd 1
      min: resd 1
      max: resd 1

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
    call reverse_string
   
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

reverse_string:
          pusha
 traverse:
          mov ebx, str
          dec  word[n]
         movzx eax, word[n] 		
         mov cl, byte[ebx+eax]
         mov  dword[i], eax
         cmp word[n], 0
         je end_rm_loop
         cmp cl, 32
         je print_str
         jmp traverse

print_str:
         inc dword[i]
 start_printing:
              mov ebx, str
              mov eax, dword[i]
              mov cl, byte[ebx+eax]
              mov byte[temp], cl
              cmp cl, 32
              je next
              cmp cl, 0
              je next
              mov eax, 4
              mov ebx, 1
              mov ecx, temp
              mov edx, 1
              int 80h
              inc dword[i]
              jmp start_printing
next:
    mov byte[temp],' '
    mov eax, 4
    mov ebx, 1
    mov ecx, temp
    mov edx, 1
    int 80h
    jmp traverse
     
end_rm_loop:
         mov ebx, str
printing2:
       mov al, byte[ebx]
       mov byte[temp],al
       cmp al,32 
       je end_all
       cmp al, 0
       je end_all
       push ebx
       mov eax, 4
       mov ebx, 1
       mov ecx, temp
       mov edx, 1
       int 80h
       pop ebx
       inc ebx
       jmp printing2

end_all:
	popa
	ret

