section .data
    arr db 0, 0, 1, 2, 0, 1, 1, 2, 4
    len equ 9
    next_str db 0xa

section .bss
    arr_res resb 10

section .text
    global _start

_start:
    mov rdi, arr
    mov rsi, arr_res
    mov rdx, len

    call num_arr
    call print_arr

    jmp exit

num_arr:
push r8
push rcx
push rax
push rbp
mov rbp, rsp

    mov r8, 0
    mov rcx, 0
    for_arr:
        mov rax, rdi
        add rax, rcx
        call check_in_past
        cmp rax, -1
        jne write_num
        ret_write_num:

    inc rcx
    cmp rcx, rdx
    jne for_arr

mov rsp, rbp
pop rbp
pop rax
pop rcx
pop r8
ret

write_num:
push rax
push rcx

    mov al, byte [rax]
    mov rcx, 0
    for_write:

        cmp al, byte [rdi+rcx]
        je write
        ret_write:

    inc rcx
    cmp rcx, rdx
    jne for_write

pop rcx
pop rax
jmp ret_write_num

write:
    mov byte [rsi+rcx], r8b
    inc r8
    ;call print_arr
jmp ret_write

check_in_past:
push rdx
push rbx

    cmp rcx, 0
    je end_check

    mov rdx, 0
    for_check:
        mov bl, byte [rdi+rdx]
        cmp bl, byte[rax]
        je check_find

    inc rdx
    cmp rcx, rdx
    jne for_check

    end_check:

pop rbx
pop rdx
ret

check_find:
    mov rax, -1
    jmp end_check

print_arr:
push rax
push rbx
push rcx
push rdx
push rbp
mov rbp, rsp

    mov rcx, 0
    for:
        mov rax, rcx
        push rcx
            mov rcx, arr_res
            add rcx, rax
            add byte [rcx], 0x30
            mov rax, 4
            mov rbx, 1
            mov rdx, 1
            int 0x80
            sub byte [rcx], 0x30
        pop rcx

    inc rcx
    cmp rcx, len
    jne for

    mov rax, 4
    mov rbx, 1
    mov rcx, next_str
    mov rdx, 1
    int 0x80

mov rsp, rbp
pop rbp
pop rdx
pop rcx
pop rbx
pop rax
ret

exit:
    mov eax, 60
    xor edi, edi
    syscall