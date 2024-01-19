section .data
    text db 'hello, my own world, hihihi', 0xa, 0
    text_len equ $-text
    lookup db 'o', 'O', 'h', 'H', 0
    lookup_len equ $-lookup

section .text
    global _start

_start:

    mov rdi, text
    mov rsi, lookup
    mov rdx, text_len
    call print_text
    call replace
    call print_text

    jmp exit

; Начало нужной процедуры
replace:
push rax ; сохраняем в стеке регистры
push rcx
push rbp
mov rbp, rsp

    mov rcx, 0
    for_text: ; начинаем идти по строке
    push rdx

        mov al, byte[rdi+rcx] ; символ на котором мы находимся

        mov rdx, 0
        start_lookup: ; начинаем идти по подстановке

            cmp al, byte [rsi+rdx] ; проверяем совпадают ли символы
            je find_symbol


        add rdx, 2 ; переходим на следующую пару подстановки
        cmp byte [rsi+rdx], 0 ; проверяем на конец подстановки
        jne start_lookup

        end_lookup:


    pop rdx
    inc rcx
    cmp rcx, rdx
    jne for_text

mov rsp, rbp
pop rbp
pop rcx
pop rax
ret


find_symbol:
    mov ah, byte [rsi+rdx+1]
    mov byte[rdi+rcx], ah ; заменяем символ
    jmp end_lookup

; Конец



print_text: ; Вывод строки
push rax
push rbx
push rcx
push rdx
push rbp
mov rbp, rsp

    mov rax, 4   ; sys_write system call number
    mov rbx, 1   ; file descriptor for stdout
    mov rcx, text ; address of the message to be printed
    mov rdx, text_len ; length of the message
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