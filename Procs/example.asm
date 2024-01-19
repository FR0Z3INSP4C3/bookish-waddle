section .data
stroka db "hello!"

section .text
global _start
_start:

mov rdi, stroka
call hash ; in rax there will be HASH
call exit

exit:
mov rax, 60
syscall

hash: 
push rbp 
mov rbp, rsp  
push rcx 
push rdx 
push r8 
push r9 
  
xor rax, rax  
xor rcx, rcx  
xor rdx, rdx  
xor r8, r8 
xor r9, r9 
  
.for_loop:  ;главный цикл 
cmp rcx, 8 
je .end 
mov r8, 8 
sub r8, rcx 
mov rdx, 2 
  
.powloop:  ;2^(8-i)  
cmp r8, 1 
je .retpow 
mov rax, 2 
mul rdx 
mov rdx, rax 
dec r8 
jmp .powloop 
  
.retpow:   ;считаем a_i*2^(8-i) 
xor rax, rax  
mov al, byte[rdi + rcx]  
mul rdx  
add r9, rax 
inc rcx   
jmp .for_loop 
  
.end: 
mov rax, r9  
pop r9 
pop r8 
pop rdx 
pop rcx 
pop rbp 
ret 
