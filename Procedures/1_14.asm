section .data
    lookup db 1, 5, 2, 4, 3, 1, 4, 2, 5, 3
    len equ 5
    yes db 'yes', 0xa, 0
    no db 'no', 0xa, 0

section .text
    global _start

_start:
    mov rdi, lookup
    mov rsi, len
    call check
    cmp rax, 0
    je print_yes

    cmp rax, -1
    je print_no

    jmp exit

check:
push rbx
push rdx
push rcx
push rbp
mov rbp, rsp

    mov rax, -1 
    mov bl, byte [rdi] ; Начальный элемент
    mov bh, byte [rdi+1] ; Текущий элемент
    cmp bl, bh
    je exit_check
    mov rdx, 2

    null_c:
    mov rcx, 0
    while:

        cmp bh, byte [rdi+2*rcx]
        je find_el
        ret_find_el:
        cmp bh, bl
        je exit_while


    inc rcx
    cmp rcx, rsi
    je null_c 
    jmp while

    exit_while:
    dec rdx
    cmp rdx, rsi
    jne exit_check
    mov rax, 0

exit_check:
mov rsp, rbp
pop rbp
pop rcx
pop rdx
pop rbx
ret

find_el:
    inc rdx
    mov bh, byte [rdi+2*rcx+1]
    jmp ret_find_el




print_yes:
    mov rax, 4
    mov rbx, 1
    mov rcx, yes
    mov rdx, 5
    int 0x80

    jmp exit

print_no:
    mov rax, 4
    mov rbx, 1
    mov rcx, no
    mov rdx, 4
    int 0x80

    jmp exit

exit:
    mov eax, 60
    xor edi, edi
    syscall
