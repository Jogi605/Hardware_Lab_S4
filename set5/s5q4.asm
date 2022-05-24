section .data
msg1:  db "Enter a string :  ", 10
size1:  equ $-msg1
msga:  db  "Largest: "
sizea:  equ $-msga
msgb:  db 10, "Smallest: "
sizeb:  equ $-msgb
newline : db 0ah

section .bss
string:  resb 50
temp:  resb 1
cnt:  resd 1
stringlen:  resd 1
max:resd 1
min:resd 1
maxindex:resb 1
minindex:resb 1


section .text
global _start
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
je endreading
inc dword[stringlen]
mov al,byte[temp]
mov byte[ebx], al
inc ebx
jmp reading


endreading:
mov byte[ebx], 0
mov ebx, string
mov dword[cnt],0
mov dword[max],0
mov dword[maxindex],0
mov dword[stringlen],0


count_maximum:
mov al, byte[ebx]
cmp al, 0
je endcounting
cmp al, 32
je inc_cnt

next:
inc ebx
inc dword[stringlen]
inc dword[cnt]
jmp count_maximum

endcounting:
mov ecx,dword[max]
cmp ecx,dword[cnt]
jb _movmax2

print:
mov eax, 4
mov ebx, 1
mov ecx, msga
mov edx, sizea
int 80h
jmp print_array

inc_cnt:
mov ecx,dword[max]
cmp ecx,dword[cnt]
jb _movmax
mov dword[cnt],-1
jmp next


_movmax:
mov ecx,dword[cnt]
mov dword[max],ecx
mov ecx,dword[stringlen]
sub ecx,dword[cnt]
mov dword[maxindex],ecx
mov dword[cnt],-1
jmp next




_movmax2:
mov ecx,dword[cnt]
mov dword[max],ecx
mov ecx,dword[stringlen]
sub ecx,dword[cnt]
mov dword[maxindex],ecx
jmp print

print_array:
mov ebx, string
printing:
mov eax,dword[maxindex]
mov al, byte[ebx+eax]
mov byte[temp],al
cmp al,32 
je counting2
cmp al,0
je counting2
push ebx
mov eax, 4
mov ebx, 1
mov ecx, temp
mov edx, 1
int 80h
pop ebx
inc dword[maxindex]
jmp printing



counting2:
mov ebx, string
mov dword[cnt],0
mov dword[min],10
mov dword[minindex],0
mov dword[stringlen],0

count_minimum:
mov al, byte[ebx]
cmp al, 0
je endcounting_min
cmp al, 32
je inc_cnt_min

next_min:
inc ebx
inc dword[stringlen]
inc dword[cnt]
jmp count_minimum

endcounting_min:
mov ecx,dword[min]
cmp ecx,dword[cnt]
ja _movmin2

print_min:
mov eax, 4
mov ebx, 1
mov ecx, msgb
mov edx, sizeb
int 80h
jmp print_array_min

inc_cnt_min:
mov ecx,dword[min]
cmp ecx,dword[cnt]
ja _movmin
mov dword[cnt],-1
jmp next_min

_movmin:
mov ecx,dword[cnt]
mov dword[min],ecx
mov ecx,dword[stringlen]
sub ecx,dword[cnt]
mov dword[minindex],ecx
mov dword[cnt],-1
jmp next_min

_movmin2:
mov ecx,dword[cnt]
mov dword[min],ecx
mov ecx,dword[stringlen]
sub ecx,dword[cnt]
mov dword[minindex],ecx
jmp print_min

print_array_min:
mov ebx, string
printing_min:
mov eax,dword[minindex]
mov al, byte[ebx+eax]
mov byte[temp],al
cmp al,32 
je exit
cmp al,0
je exit
push ebx
mov eax, 4
mov ebx, 1
mov ecx, temp
mov edx, 1
int 80h
pop ebx
inc dword[minindex]
jmp printing_min

exit:
mov eax, 4
mov ebx, 1
mov ecx, newline
mov edx, 1
int 80h
mov eax, 1
mov ebx, 0
int 80h
