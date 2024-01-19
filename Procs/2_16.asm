section .text
global _start
_start:

mov rdi, 5
mov rsi, 12
call mul_bytes
call exit

exit:
mov rax, 60
syscall

mul_bytes:
push rbp
mov rbp, rsp
xor ch, ch
%rep 8
shr sil, 1
sbb al, al
and al, dil
add ch, al
shl dil, 1
%endrep
pop rbp
ret
