section .data
    lookup db 'o', 'O', 'a', 'A', 'c', 'C', 0
    lookup_rev db 0

section .text
    global _start

_start:
    mov rcx, lookup
    ;call print_lookup 
    mov rdi, lookup
    mov rsi, lookup_rev
    call reverse
    mov rcx, lookup_rev
    call print_lookup
    jmp exit


reverse:
push rax ; сохранение в стеке используемых регистров
push rdx
push rbp
mov rbp, rsp

    mov rdx, 0
    for_l: ; начинаем двигаться по подстановке
        mov al, byte [rdi+rdx] ; берем два байта из исходной подстановки
        mov ah, byte [rdi+rdx+1]
        mov byte [rsi+rdx], ah ; отправляем их в обратную, поменяв местами
        mov byte [rsi+rdx+1], al
    add rdx, 2 ; переходим на следующие два байта
    cmp byte [rcx+rdx], 0 ; проверка конца подстановки 
    jne for_l
    mov byte [rsi+rdx], 0 ; добавляем конец для новой подстановки 

mov rsp, rbp
pop rbp
pop rdx
pop rax
ret


print_lookup:
push rbp
mov rbp, rsp

    mov rdx, 0
    for:
    inc rdx
    cmp byte [rcx+rdx], 0
    jne for

    mov rax, 4   ; sys_write system call number
    mov rbx, 1   ; file descriptor for stdout
    int 0x80



mov rsp, rbp
pop rbp
ret

exit:
    mov eax, 60
    xor edi, edi
    syscall