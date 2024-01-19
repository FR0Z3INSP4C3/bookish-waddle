section .data
    text db "Hello,fucking world", 0xa, 0

section .bss
    token resb 30

section .text
    global _start

_start:
    mov rdi, text
    mov rsi, token
    call get_tocken

    call print_text

    jmp exit

get_tocken:
push rcx
push rbp
mov rbp, rsp

    mov rcx, 0
    for:

        cmp byte [rdi+rcx], 0x20
        je end_for
        cmp byte [rdi+rcx], 0xd
        je end_for

        mov al, byte [rdi+rcx]
        mov byte [rsi+rcx], al

    inc rcx
    jmp for
    end_for:
        mov rax, rdi
        add rax, rcx
        inc rax

mov rsp, rbp
pop rbp
pop rcx
ret

print_text:
    mov rdx, 0
    for_text:
        cmp byte [rax+rdx], 0
        je end_for_text
        ;cmp byte [rax+rdx], 0xd
        ;je end_for
    inc rdx
    jmp for_text
    end_for_text:

    mov rcx, rax
    mov rax, 4
    mov rbx, 1
    int 0x80
ret

exit:
    mov eax, 60
    xor edi, edi
    syscall