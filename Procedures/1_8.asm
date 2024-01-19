section .data
    result_msg db 'Result: %d', 10, 0

section .text
    global main
    extern printf

main:
    mov dil, 123 ; первое число
    mov sil, 456 ; второе число
    call sum_digits

    mov rdi, result_msg
    mov rsi, al
    xor eax, eax
    call printf

    xor eax, eax
    ret

sum_digits:
    mov rcx, 3

    ; Суммируем цифры в каждом байте
    mov al, dil
    mov ah, sil

    xor dl, dl

    sum_loop:
        movzx ax, al
        and ax, 7 ; Оставляем только первые 3 бита
        add dl, al ; Суммируем цифры
        shl ax, 3 ; Сдвигаем число на 3 бита влево
        shr al, 3 ; Сдвигаем число на 3 бита вправо
        shr ah, 3 ; Сдвигаем число на 3 бита вправо
        loop sum_loop

    ; Сохраняем результат в AL
    mov al, dl

    ret
