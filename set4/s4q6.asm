section .data
string_len: db 0
msg1: db "Enter a string : "
size1: equ $-msg1
msg_a: db 10 , "Count of vowels : "
size_a: equ $-msg_a

section .bss
string: resb 50
temp: resb 1
count: resb 1
a_cnt: resw 1

section .data
global _start:
_start:

mov eax, 4
mov ebx, 1
mov ecx, msg1
mov edx, size1
int 80h

mov ebx, string

reading:
push ebx
mov eax, 3
mov ebx, 0
mov ecx, temp
mov edx, 1
int 80h
pop ebx
cmp byte[temp], 10
je end_reading
inc byte[string_len]
mov al,byte[temp]
mov byte[ebx], al
inc ebx
jmp reading

end_reading:
mov byte[ebx], 0
mov ebx, string

counting:
mov al, byte[ebx]
cmp al, 0
je end_counting
cmp al, 'a'
je inc_a
cmp al, 'e'
je inc_a
cmp al, 'i'
je inc_a
cmp al, 'o'
je inc_a
cmp al, 'u'
je inc_a
cmp al, 'A'
je inc_a
cmp al, 'E'
je inc_a
cmp al, 'I'
je inc_a
cmp al, 'O'
je inc_a
cmp al, 'U'
je inc_a

next:
inc ebx
jmp counting
end_counting:

mov eax, 4
mov ebx, 1
mov ecx, msg_a
mov edx, size_a
int 80h
print_num:
        mov byte[count],0
        pusha
        extract_no:
            cmp word[a_cnt], 0
            je print_no
            inc byte[count]
            mov dx, 0
            mov ax, word[a_cnt]
            mov bx, 10
            div bx
            push dx
            mov word[a_cnt], ax
            jmp extract_no
        print_no:
            cmp byte[count], 0
            je end_print
            dec byte[count]
            pop dx
            mov byte[temp], dl
            add byte[temp], 30h
            mov eax, 4
            mov ebx, 1
            mov ecx, temp
            mov edx, 1
            int 80h
            jmp print_no
        end_print:
            popa
exit:
mov eax, 1
mov ebx, 0
int 80h

inc_a:
inc byte[a_cnt]
jmp next
