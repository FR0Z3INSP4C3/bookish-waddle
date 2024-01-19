section .text
    global _start

_start:
    ; первый вызов функции для сложения 1A и 2B
    mov bl, 0x7  ; байт первого числа
    mov bh, 0xB  ; байт второго числа
    call add_numbers ; вызов процедуры сложения

    ; вывод результата
    mov dl, al ; результат сложения
    add dl, '0' ; преобразование в символ
    mov [result], dl ; сохранение результата в памяти
    mov eax, 4 ; номер системного вызова для вывода на экран
    mov ebx, 1 ; файловый дескриптор (1 - стандартный вывод)
    mov ecx, result ; адрес строки для вывода
    mov edx, 1 ; длина выводимой строки (1 символ)
    int 0x80 ; выполнение системного вызова

    ; выход из программы
    mov eax, 1 ; номер системного вызова для выхода
    xor ebx, ebx ; возвращаемый код - 0
    int 0x80 ; выполнение системного вызова
add_numbers:
    mov al, bl ; копирование первого числа в al
    add al, bh ; сложение с вторым числом
    and al, 0Fh ; взятие остатка от деления на 16




ret
section .data
    result db 0 ; переменная для хранения результата