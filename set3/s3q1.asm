section .data
msg1: db "Enter the size of array:",10
   l1: equ $-msg1
msg2: db "Enter the elements:",10
   l2: equ $-msg2
msg3: db "Total even numbers sum is:"
   l3: equ $-msg3
msg4: db "Total odd numbers sum is:"
   l4: equ $-msg4
tab: db 9
newline: db 10

section .bss
jr: resd 1
jp: resd 1
temp: resd 1
counter: resd 1
zero: resd 1
n: resd 1
arr: resd 100
i: resd 1
ans1: resd 1
ans2: resd 1
var: resd 1

section .text
global _start:
_start:

   mov eax, 4
   mov ebx, 1
   mov ecx, msg1
   mov edx, l1
   int 80h

call read_num
mov eax,dword[jr]
mov dword[n],eax


   mov eax, 4
   mov ebx, 1
   mov ecx, msg2
   mov edx, l2
   int 80h

mov ebx,arr
mov eax,0
call read_array

mov dword[i],0
mov dword[ans1],0
mov dword[ans2],0
mov dword[var],0
loop:
mov ebx,arr
mov ecx,dword[i]
cmp ecx,dword[n]
je print_newline

mov eax,dword[ebx+(4*ecx)]
mov dword[var],eax

mov eax,dword[var]
mov ebx,2
mov edx,0
div ebx
cmp edx,0
je print1
mov eax, dword[var]
add dword[ans2], eax
inc dword[i]
jmp loop

print1:
mov eax, dword[var]
add dword[ans1], eax
inc dword[i]
jmp loop


print_newline:
  mov eax, 4
  mov ebx, 1
  mov ecx, msg3
  mov edx, l3
  int 80h

  mov eax, dword[ans1]
  mov dword[jp], eax
  call print_num

   mov eax, 4
   mov ebx, 1
   mov ecx, msg4
   mov edx, l4
   int 80h

   mov eax, dword[ans2]
   mov dword[jp], eax
   call print_num
end:
mov eax,1
mov ebx,0
int 80h

read_array:

pusha
read_loop:
cmp eax,dword[n]
je end_read_array
call read_num
mov ecx,dword[jr]
mov dword[ebx+(4*eax)],ecx
inc eax
jmp read_loop

end_read_array:

popa
ret

print_array:

mov ebx,arr
mov eax,0

pusha
print_loop:
cmp eax,dword[n]
je end_print_array
mov ecx,dword[ebx+(4*eax)]
mov dword[jp],ecx
call print_num
inc eax
jmp print_loop

end_print_array:

popa
ret

read_num:

pusha
mov dword[jr],0
reading:
   mov eax,3
   mov ebx,0
   mov ecx,temp
   mov edx,1
   int 80h

   cmp dword[temp],10
   je end_read
sub dword[temp],30h
mov eax,dword[jr]
mov edx,0
mov ebx,10
mul ebx
add eax,dword[temp]
mov dword[jr],eax
jmp reading

end_read:

popa
ret

print_num:

pusha
mov dword[counter],0
cmp dword[jp],0
jne extracting
mov dword[zero],30h
mov eax,4
mov ebx,1
mov ecx,zero
mov edx,1
int 80h
jmp end_print

extracting:

cmp dword[jp],0
je printing
mov eax,dword[jp]
mov edx,0
mov ebx,10
div ebx
push edx
mov dword[jp],eax
inc dword[counter]
jmp extracting

printing:

cmp dword[counter],0
je end_print
pop edx
add edx,30h
mov dword[temp],edx
mov eax,4
mov ebx,1
mov ecx,temp
mov edx,1
int 80h
dec dword[counter]
jmp printing

end_print:
mov eax,4
mov ebx,1
mov ecx,newline
mov edx,1
int 80h
popa
ret		           
