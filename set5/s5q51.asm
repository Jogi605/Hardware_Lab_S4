section .data
msg1: db "Enter the string:", 10
  l1: equ $-msg1
msg2: db "Enter the word to search:", 10
  l2: equ $-msg2
msg3: db "Enter the new word:", 10
  l3: equ $-msg3
msg4: db "The new String is:"
  l4: equ $-msg4
spacee: db " "
newline: db 0Ah


section .bss
strg: resb 50
strg1: resb 50
strg2: resb 50
stack: resb 1000
dig1: resw 1
n1: resw 1
n2: resw 1
n3: resw 1
t: resw 1
num: resw 1
temp: resb 1
ignore: resb 1
count: resw 1
flag: resb 1
strlen: resw 1
enter: resb 1
present: resw 1
letter: resb 1
check: resw 1

section .text
global _start:
_start:
 
mov eax, 4
mov ebx, 1
mov ecx, msg1
mov edx, l1
int 80h

  mov ebx, strg
  call get_string
  mov ax, word[strlen]
  mov word[n1],ax

 mov eax, 4
 mov ebx, 1
 mov ecx, msg2
 mov edx, l2
 int 80h

 mov ebx, strg1
 call get_string
 mov ax, word[strlen]
 mov word[n2],ax

 mov eax, 4
 mov ebx, 1
 mov ecx, msg3
 mov edx, l3
 int 80h

  mov ebx, strg2
  call get_string

  mov eax, stack
  mov ebx, strg
  mov word[count], 0
  call extract_word
  mov ax, word[count]
  mov word[n3], ax

  mov eax, 4
  mov ebx, 1
  mov ecx, msg4
  mov edx, l4
  int 80h

  mov ebx, stack
  mov eax, strg1

for:
    pusha
    mov cx, word[n2]
    mov word[num], cx
    call strcmp
    popa
    cmp word[check], 1
    je exchange
    run:
    add ebx, 50
    dec word[n3]
    cmp word[n3], 0
    jne for

pusha
mov ebx, stack
mov ax, word[count]
mov word[num], ax
call put_words
popa


exit:
mov eax, 1
mov ebx, 0
int 80h


exchange:
pusha
mov eax, strg2
call strcpy
popa
jmp run


extract_word:
push eax
words:
	mov cl, byte[ebx]
	mov byte[eax], cl
	inc eax
	inc ebx
	dec word[n1]
	cmp byte[ebx], ' '
	je space
	cmp byte[ebx], 0
	je end
	jmp words
space:
	mov byte[eax], 0
	pop eax
	add eax, 50
	push eax
	inc ebx
	inc word[count]
	jmp words
end:
	mov byte[eax], 0
	inc word[count]
	pop eax
	ret

strcpy:
copy:
	mov cl, byte[eax]
	cmp cl, 0
	je endcpy
	mov byte[ebx], cl
	inc eax
	inc ebx
	jmp copy
	endcpy:
		mov byte[ebx], 0
		ret

strcmp:
compare:
    mov cl, byte[eax]
    cmp byte[ebx], cl
    jne not
    inc eax
    inc ebx
    dec word[num]
    cmp word[num], 0
    jne compare
    yes:
        mov word[check], 1
        ret
    not:
        mov word[check], 0
        ret

get_string:
mov byte[strlen], 0
repeat:
push ebx
mov eax, 3
mov ebx, 0
mov ecx, temp
mov edx, 1
int 80h
pop ebx
cmp byte[temp], 10
je stop
mov al, byte[temp]
mov byte[ebx], al
inc ebx
inc word[strlen]
jmp repeat
stop:
mov byte[ebx], 0
ret

put_string:
repeat1:
mov al, byte[ebx]
mov byte[temp], al
cmp byte[temp], 0
je sto
push ebx
mov eax, 4
mov ebx, 1
mov ecx, temp
mov edx, 1
int 80h
pop ebx
inc ebx
jmp repeat1
sto:
ret

put_words:
put:
    pusha
    call put_string
    popa
	pusha
    mov eax, 4
    mov ebx, 1
    mov ecx, spacee
    mov edx, 1
    int 80h
	popa
    add ebx, 50
    dec word[num]
    cmp word[num], 0
    jne put

    end_put:
    call ent
    ret

ent:
pusha
mov byte[enter], 10
mov eax, 4
mov ebx, 1
mov ecx, enter
mov edx, 1
int 80h
popa
ret

