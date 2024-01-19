section .data
    lookup1 db 'a', 'A', 'b', 'B', 'c', 'C', 0
    lookup2 db 'A', 'a', 'B', 'b', 'C', 'c', 0
    lookup3 db 0

section .text
    global _start

_start:
    mov rdi, lookup1
    mov rsi, lookup2
    mov rcx, lookup3
    call mult_lu
    call print_lookup

    jmp exit

mult_lu:
push rax
push rdx
push rbp
mov rbp, rsp

    mov rdx, 0
    for_l1:

        mov al, byte [rdi+rdx]
        mov byte [rcx+rdx], al
        mov al, byte [rdi+rdx+1]
        call get_img
        mov byte [rcx+rdx+1], ah

    add rdx, 2
    cmp byte [rdi+rdx], 0
    jne for_l1


mov rsp, rbp
pop rbp
pop rdx
pop rax
ret

get_img:
push rdx
push rbp
mov rbp, rsp

    mov rdx, 0
    for_l2:

        mov ah, byte [rsi+rdx]
        cmp ah, al
        je end_l2
        ;call print_lookup

    add rdx, 2
    cmp byte [rsi+rdx], 0
    jne for_l2
    end_l2:
        mov ah, byte [rsi+rdx+1]

mov rsp, rbp
pop rbp
pop rdx
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