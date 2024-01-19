section .data
    matrix db 1, 0, 0, 0, 1, 0, 0, 0, 1
    len db 3
    next_str db 0xa, 0

section .bss
    otv resb 2

section .text
    global _start

_start:
    mov rdi, matrix
    mov al, byte[len]
    mov rsi, rax
    call get_trace


    call print_otv

    jmp exit

get_trace:
push rbx
push rcx
push rdi
push rbp
mov rbp, rsp
    mov rax, 0
    mov rbx, 0

    mov rcx, 0
    for_matrix:

        mov bl, byte[rdi+rcx]
        add rax, rbx
        add rdi, rsi

    inc rcx
    cmp rcx, rsi
    jne for_matrix
    

mov rsp, rbp
pop rbp
pop rdi
pop rcx
pop rbx
ret


print_otv:
push rax
push rbx
push rcx
push rdx
    mov byte [otv], al
    mov rax, 4
    mov rbx, 1
    mov rcx, otv
    add byte [rcx], 0x30
    mov rdx, 1
    int 0x80
    mov rax, 4
    mov rbx, 1
    mov rcx, next_str
    mov rdx, 2
    int 0x80
pop rdx
pop rcx
pop rbx
pop rax
ret

exit:
    mov eax, 60
    xor edi, edi
    syscall