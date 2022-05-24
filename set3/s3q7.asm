section .data
    newline: db 0ah
    msg1: db 'Enter size of array1:',10
    l1: equ $-msg1
    msg2: db 'Enter the numbers:',10
    l2: equ $-msg2
    msg3: db 'Enter size of array2:',10
    l3: equ $-msg3
    msg4: db 'The common elements are:',10
    l4: equ $-msg4


section .bss
    num: resw 1 
    temp:resb 1
    n1:resd 1    
    n2:resd 1
    n3:resd 1
    count:resb 1 
    array1: resw 50 
    array2: resw 50
    array3: resw 50
    
section .text
global _start:
_start:
mov ecx,msg1
mov edx,l1
call print
call read_num
mov ax,word[num]
mov word[n1],ax

mov ecx,msg2
mov edx,l2
call print
mov ebx , array1
mov ecx , 0
call read_array

mov ecx,msg3
mov edx,l3
call print
call read_num
mov ax,word[num]
mov word[n2],ax

mov ecx,msg2
mov edx,l2
call print
mov ebx , array2
mov ecx , 0
mov esi,array3
mov edi,0
call read_and_cmp_arr
mov ecx,msg4
mov edx,l4
call print
mov ebx,array3
call print_array
jmp exit
read_array:
    read_loop1:
        cmp ecx, dword [n1]
        je end_read_loop1
        call read_num
       
        mov ax, word[num]
        mov word [ebx+2*ecx] , ax
        inc ecx
        jmp read_loop1
    end_read_loop1:
ret
read_and_cmp_arr:
    read_loop2:
        cmp ecx, dword [n2]
        je end_read_loop2
        call read_num
        
        mov ax, word[num]
        mov word [ebx+2*ecx] , ax
        push ecx
        push ebx
        mov ecx,0
        mov ebx,array1
        for:
        cmp ecx,dword[n1]
        ja end_for
        cmp ax,word[ebx+2*ecx]
        jne cont_check_common
        mov word[esi+2*edi],ax
        inc edi
        jmp end_for
        cont_check_common:
        inc ecx
        jmp for
        end_for:
        pop ebx
        pop ecx
        inc ecx
        jmp read_loop2
        
    end_read_loop2:
    mov dword[n3],edi
ret

read_num:
    push eax
    push ebx
    push ecx
    mov word[num],0

    loop_read:
        mov eax, 3
        mov ebx,0
        mov ecx, temp
        mov edx, 1
        int 80h

       
        cmp byte[temp],10

        je end_read
    mov ax,word[num]
    mov bx, 10
    mul bx
    mov bl, byte[temp]
    sub bl,30h
    mov bh,0
    add ax,bx
    mov word[num],ax
    jmp loop_read
    end_read:
    pop ecx
    pop ebx
    pop eax
    ret

print_num:
    mov byte [count] , 0
    push eax
    push ebx
    extract_no:

    cmp word [num] , 0
    je print_no
    inc byte [count]

    mov dx, 0
    mov ax, word [num]

    mov bx, 10
    div bx
    push dx
    mov word [num] , ax
    jmp extract_no

    print_no :
    cmp byte[count],0
    je end_print
    dec byte [count]

    pop dx
    mov byte [temp] , dl
    add byte [temp] , 30h
    mov eax, 4
    mov ebx, 1

    mov ecx, temp
    mov edx, 1
    int 80h
    jmp print_no

    end_print :
    mov eax , 4
    mov ebx , 1
    mov ecx , newline
    mov edx, 1
    int 80h
    ; ;The memory location
    pop ebx
    pop eax
ret
print:
    mov eax,4
    mov ebx,1
    int 80h
    ret

print_array:
push eax
mov eax,0
print_loop:
cmp eax, dword [n3]
je end_print1
mov cx, word [ebx+2*eax]
mov word [num] , cx
call print_num
inc eax
jmp print_loop
end_print1:
pop eax
ret

exit:
mov eax,1
mov ebx,0
int 80h
