section .data
    text db "Hello world", 0xa, 0
    len equ $-text
    lookup db 0, 9, 1, 8, 2, 5, 3, 6, 4, 1, 5, 3, 6, 10, 7, 4, 8, 0, 9, 2, 10, 7
    len_lu equ 11

section .text
    global _start

_start:
    mov rdi, text
    mov rsi, lookup
    mov rdx, len
    mov rcx, len_lu

    call text_encryption

    call print_text
    jmp exit

text_encryption:
push rax
push r8
push r9
push rcx
push rbp
mov rbp, rsp

    mov rax, 0
    mov al, byte [rsi]
    mov r9, 0

    null_for_lu:
    mov r8, 0
    for_lu:
        inc rcx
        cmp r9, rcx
        je end_for_lu
        dec rcx

        cmp al, byte [rsi+r8*2]
        je char_per
        ret_char_per:


    inc r8
    cmp r8, rcx
    je null_for_lu
    jmp for_lu
    end_for_lu:

mov rsp, rbp
pop rbp
pop rcx
pop r9
pop r8
pop rax
ret

char_per:
push rcx
push r10
push r11
    
    mov r10b, byte [rsi+r8*2]
    mov r11b, byte [rsi+r8*2+1]
    mov cl, byte [rdi+r10]
    mov al, ah
    mov byte [rdi+r10], al
    mov ah, cl
    mov al, r11b
    inc r9

pop r11
pop r10
pop rcx
jmp ret_char_per

print_text:
push rax
push rbx
push rcx
push rdx

    mov rax, 4
    mov rbx, 1
    mov rcx, text
    mov rdx, len
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