section .data
newline : db 0Ah
zero : db '0'
space : db ' '
m1: db "DISSIMILIAR  ",0Ah
s1:equ $-m1
m2: db "SIMILIAR",0Ah
s2: equ $-m2 
m3: db "Enter string1:", 10
s3: equ $-s3
m4: db "Enter string2:", 10
s4: equ $-s4

section .bss
str1 : resb 500
str2 : resb 500
n1 : resw 1
n2 : resw 1
i : resw 1
j : resw 1
val : resw 1
tmp : resb 1
char: resb 1
count : resb 1

section .text
global _start

_start :

     mov eax, 4
     mov ebx, 1
     mov ecx, m3
     mov edx, s3
     int 80h

    call read1

    mov eax, 4
    mov ebx, 1
    mov ecx, m4
    mov edx, s4
    int 80h

    call read2
   
    call compare
exit :
    mov eax, 1
    mov ebx, 0
    int 80h


compare:
    pusha
    mov word[i],0
    mov word[j],0

loop:
    mov cx,word[i]
    cmp cx, word[n1]
    jnb end_loop1

    mov cx,word[j]
    cmp cx,word[n2]
    jnb end_loop2
    
    mov ebx, str1
    movzx eax, word[i]
    
    mov cl,byte[ebx+eax]
    mov byte[char],cl

    mov ebx, str2
    movzx eax, word[j]
    
    mov cl,byte[ebx+eax]
    cmp cl,byte[char]
    je continue

    cmp cl,byte[char]
    ja print2
    jmp print1

    continue:
    inc word[i]
    inc word[j]
    jmp loop
        
end_loop1:
    mov cx,word[j]
    cmp cx,word[n2]
    je print3
    jmp print2

end_loop2:
    mov cx,word[i]
    cmp cx,word[n1]
    je print3
    jmp print1

print1:
    mov word[val],0
    mov ebx, str1
    movzx eax, word[i]
    mov cx,word[ebx+eax]
    add word[val],cx
    
    mov cx,word[j]
    cmp cx,word[n2]
    jnb line1

    mov ebx, str2
    movzx eax, word[j]
    mov cx,word[ebx+eax]
    sub word[val],cx

    line1:    
    mov eax, 4
    mov ebx, 1
    mov ecx, m1
    mov edx, s1
    int 80h

    call print_num

    popa
    ret

print2:    
    mov word[val],0
    mov ebx, str2
    movzx eax, word[j]
    mov cx,word[ebx+eax]
    add word[val],cx

    mov cx,word[i]
    cmp cx,word[n1]
    jnb line2

    mov ebx, str1
    movzx eax, word[i]
    mov cx,word[ebx+eax]
    sub word[val],cx

    line2:    
    mov eax, 4
    mov ebx, 1
    mov ecx, m1
    mov edx, s1
    int 80h

    call print_num

    popa
    ret

print3:    
    mov eax, 4
    mov ebx, 1
    mov ecx, m2
    mov edx, s2
    int 80h

    popa
    ret

print_num:
        mov byte[count],0
        pusha
        extract_no:
            cmp word[val], 0
            je print_no
            inc byte[count]
            mov dx, 0
            mov ax, word[val]
            mov bx, 10
            div bx
            push dx
            mov word[val], ax
            jmp extract_no
        print_no:
            cmp byte[count], 0
            je end_print
            dec byte[count]
            pop dx
            mov byte[tmp], dl
            add byte[tmp], 30h
            mov eax, 4
            mov ebx, 1
            mov ecx, tmp
            mov edx, 1
            int 80h
            jmp print_no
        end_print:
            popa
            ret

read1 :
    pusha
    mov word[n1], 0
read_loop1 :
    mov eax, 3
    mov ebx, 0
    mov ecx, tmp
    mov edx, 1
    int 80h

    cmp byte[tmp], 10
    je end_read1

    mov ebx, str1
        movzx eax, word[n1]
    mov cl, byte[tmp]
        mov byte[ebx+eax], cl

    inc word[n1]
    jmp read_loop1

end_read1 :
    mov ebx, str1
    movzx eax, word[n1]
    mov byte[ebx+eax], 0
    popa
    ret

read2 :
    pusha
    mov word[n2], 0
read_loop2 :
    mov eax, 3
    mov ebx, 0
    mov ecx, tmp
    mov edx, 1
    int 80h

    cmp byte[tmp], 10
    je end_read2

    mov ebx, str2
        movzx eax, word[n2]
    mov cl, byte[tmp]
        mov byte[ebx+eax], cl

    inc word[n2]
    jmp read_loop2

end_read2 :
    mov ebx, str2
    movzx eax, word[n2]
    mov byte[ebx+eax], 0
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

printchar:
    pusha
    mov eax, 4
    mov ebx, 1
    mov ecx, tmp
    mov edx, 1
    int 80h
    call printnewline
    popa
    ret
