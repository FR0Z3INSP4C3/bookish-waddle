section .data
perm db "13456"
n db 6
k db 5

section .text
global _start
_start:
mov rdi, perm
mov rsi, [n]
mov rdx, [k]
call next_permutation; rdi - new permutation address, rax - return code 
mov rsi, perm
mov rax, 1
mov rdi, 1
mov rdx, [k]
syscall
call exit

next_permutation:
push rbp
mov rbp, rsp
push rbx
push rcx
mov  cl, sil ; now n in cl
mov ch, dl ; now k in ch
push rdx
xor rbx, rbx ; rbx is b
push r8

xor r8, r8
xor rdx, rdx
mov dl, ch
mov r8, rdx
dec r8

.check:
xor rdx, rdx
mov dl, byte[rdi+r8] ; current symbol
sub dl, 0x30
xor rax, rax

mov al, cl ; now rax is n
sub rax, rbx ; rax = n-b
cmp rdx, rax ; cmp with n-b
jl .continue

push rax
xor rax, rax
mov al, ch
dec al 
cmp rbx, rax ; b = k-1 ?
pop rax
je .last
inc rbx
dec r8
jmp .check

.continue:
xor rax,rax
mov al, byte[rdi+r8]
inc al
mov byte[rdi+r8], al
sub rax, 0x30
mov r9, rax
xor rax,rax
.ch_previous:
inc r8
xor rdx, rdx
mov dl, ch
cmp r8, rdx
je .end
push rdx
mov al, byte[rdi+r8]
xor rdx, rdx
mov dl, cl 
sub rax, rdx
add rax, rbx 
add rax, r9 
mov byte[rdi+r8],al
pop rdx
jmp .ch_previous

.last:
mov rax, -1
.end:
pop r8
pop rdx
pop rcx
pop rbx
pop rbp
ret

exit:
mov rax, 60
syscall

