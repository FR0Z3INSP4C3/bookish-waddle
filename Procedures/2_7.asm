section .bss
    result resb 20

section .data
    ;lookup db 1, 3, 2, 4, 3, 5, 4, 1, 5, 2, 0
    lookup db 1, 5, 2, 4, 3, 1, 4, 2, 5, 3, 0
    ;lookup db 2, 4, 5, 3, 3, 1, 1, 5, 4, 2, 0
    ;lookup db 1, 1, 0

    len equ 5


section .text
    global _start

_start:
    mov rdi, lookup
    mov rsi, len
    mov rdx, result
    call find_cycle

    mov rax, rdx
    call print_lu


    jmp exit

find_cycle:
push rax
push rcx
push r8
push r9
push rdi
push rdx
push rbp
mov rbp, rsp

    mov r8, 0 ; Счетчик использованных элементов в result
    mov r9, 0 ; Длина result

    mov rcx, 0 
    for:
        mov rax, rdi
        add rax, rcx ; находим "верхний" элемент подстановки
        call check_in_res
        cmp rax, -1 
        je not_cal_f_1c
        call f_1c
        not_cal_f_1c:

    add rcx, 2
    cmp r8, rsi ; если все элементы мы использовали, то заканчиваем этот кордебалет
    jne for    

mov rsp, rbp
pop rbp
pop rdx
pop rdi
pop r9
pop r8
pop rcx
pop rax
ret

check_in_res: ; функция проверки "есть ли элемент в циклах или нет"
push rbx
push rcx
    cmp r9, 0 ; если result пуст, то точно нет
    je end_check

    mov rcx, 0
    for_check:

        mov bl, byte [rax]
        cmp byte [rdx+rcx], bl
        je find_in_res ; мы его нашли, значит делаем rax = -1

    inc rcx
    cmp rcx, r9
    jne for_check

end_check:
pop rcx
pop rbx
ret

find_in_res:
    mov rax, -1
    jmp end_check

f_1c: ; функция построения цикла
push rax
push rbx
push rcx
    mov bh, byte[rax] ; первый элемент
    mov byte [rdx], bh
    inc r9
    inc r8
    inc rdx
    mov bl, byte[rax+1] ; образ первого элемента
    mov byte [rdx], bl
    inc r9
    cmp bl, bh ; если они равны, то получается длина цикла 1
    je end_f_1c
    mov ah, bh
    mov al, bl ; образы
    inc rdx

    null_for_l1:
    mov rcx, 0 ; запускаем счетчик rcx по модулю rsi
    for_l1:

        cmp byte [rdi+rcx+rcx], al ; "Мы нашли куда отправляет нас предыдущий образ?"
        je i_find
        ret_i_find:

        cmp ah, al
        je end_for_l1

    inc rcx
    cmp rcx, rsi
    je null_for_l1
    jmp for_l1
    end_for_l1:
    mov byte [rdx+1], ah ; дозаписываем первый элемент (цикл замкнулся)

end_f_1c:
pop rcx
pop rbx
pop rax
ret

i_find:
    mov al, byte [rdi+rcx+rcx+1] ; меняем образ на следующий
    mov byte [rdx], al ; записываем элемент в result
    inc rdx
    inc r8
    inc r9

    jmp ret_i_find

print_lu:
    mov rdx, 0
    for_print:

        cmp byte [rax+rdx], 0
        je end_for_print

        mov rcx, rax
        add rcx, rdx
        add byte [rcx], 0x30
        call print_symbol
        sub byte [rcx], 0x30

    inc rdx
    jmp for_print
    end_for_print:
ret

print_symbol:
push rax
push rbx
push rdx
    mov rax, 4
    mov rbx, 1
    mov rdx, 1
    int 0x80
pop rdx
pop rbx
pop rax
ret

exit:
    mov eax, 60
    xor edi, edi
    syscall