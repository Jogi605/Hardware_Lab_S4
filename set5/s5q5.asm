section .data
    msg1: db "Enter the string:", 10
      l1: equ $-msg1

    zero: db '0'
     space: db " "
    newline: db 0Ah
  
   msg2: db "Enter the Word to be searched:", 10
     l2: equ $-msg2
  
   msg3: db " Enter the replacing word", 10
     l3: equ $-msg3

    msg4: db "The replaced string is:"
      l4: equ $-msg4
    
section .bss
      str: resb 100
      ser: resb 50
      rep: resb 50
        n: resw 1
        l: resw 1
        m: resw 1
      temp: resb 1
      cnt: resd 1
      i: resw 1
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

    call read_word1
    
    mov eax, 4
    mov ebx, 1
    mov ecx, msg3
    mov edx, l3
    int 80h

    call replace_string
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

read_word1:
         pusha
         mov word[l], 0
   loop1:
       mov eax, 3
       mov ebx, 0
       mov ecx, temp
       mov edx, 1
       int 80h

      cmp byte[temp], 10
      je end_read_word1

      mov ebx, ser
      movzx eax, word[l]
      mov cl, byte[temp]
      mov byte[ebx+eax], cl
      inc word[l]
      jmp loop1

  end_read_word1:

                mov ebx, ser
                movzx eax, word[l]
               mov byte[ebx+eax], 0
                popa
                ret

read_word2:
         pusha
         mov word[m], 0
   loop2:
       mov eax, 3
       mov ebx, 0
       mov ecx, temp
       mov edx, 1
       int 80h

      cmp byte[temp], 10
      je end_read_word2

      mov ebx, rep
      movzx eax, word[m]
      mov cl, byte[temp]
      mov byte[ebx+eax], cl
      inc word[m]
      jmp loop2

  end_read_word2:

                mov ebx, rep
                movzx eax, word[m]
               mov byte[ebx+eax], 0
                popa
                ret


print_string:
           pusha
           mov ebx, str
           mov word[i], 0
    printing:
            movzx eax, word[i]
            mov cl, byte[ebx+eax]
            cmp cl,0
            je end_printing
            mov byte[temp], cl
            mov eax, 4
            mov ebx ,1
            mov ecx, temp
            mov edx, 1
            int 80h
            inc word[i]
            jmp printing

end_printing:
            popa
            ret


replace_string:
          pusha
          mov word[i], 0
          mov word[j], 0
          mov word[k], 0
 traverse:
          mov ebx, str
          movzx eax, word[i]	
         mov cl, byte[ebx+eax]
         cmp cl, 0
         je end_loop
         mov ecx, ser
         movzx eax, word[j]
         cmp cl, byte[ecx+eax]
         je check_word
         inc word[i]
         jmp traverse

check_word:
         mov word[cnt], 1
         mov ecx, ser
          inc word[j]
          inc word[i]
          movzx eax, word[j]
          mov cl, byte[ecx+eax]
          cmp cl, 0
          je replace
          movzx eax, word[i]
          mov ebx, str
          cmp cl, byte[ebx+eax]
          je check_word
          inc word[i]
          mov word[j], 0
          jmp traverse
replace:
       mov ebx, str
       movzx eax, word[i]
       mov ecx, word[l]
       sub eax, ecx
       mov word[i], eax
do_replace:
       movzx eax, word[k]
       mov ecx, rep
       mov cl, byte[ecx+eax]
       cmp cl, 0
       je end_loop
       movzx eax, word[i]
       mov byte[ebx+eax], cl
       inc word[i]
       inc word[j]
       jmp do_replace
          
end_loop:
        popa
        ret
