section .data
    n: dd 0
    num: dd 0
    sum: dd 0
    str_in: db "Nhap so luong so nguyen: "
    str_num: db "Nhap so nguyen thu %d: "
    str_sum: db "Tong cua n so nguyen la: "
    len_str_in: equ $-str_in
    len_str_num: equ $-str_num
    len_str_sum: equ $-str_sum

section .text
    global main

main:
    mov eax, 4
    mov ebx, 1
    mov ecx, str_in
    mov edx, len_str_in
    int 0x80

    call read_int
    mov [n], eax

    mov eax, 4
    mov ebx, 1
    mov ecx, str_num
    mov edx, len_str_num
    int 0x80

    mov ecx, [n]
    mov ebx, 0
    mov eax, 0
    jmp loop

loop:
    add eax, ebx
    inc ebx
    loop loop

    mov [sum], eax

    mov eax, 4
    mov ebx, 1
    mov ecx, str_sum
    mov edx, len_str_sum
    int 0x80

    mov eax, [sum]
    mov ebx, 1
    mov ecx, num
    mov edx, 4
    int 0x80

    mov eax, 1
    mov ebx, 0
    int 0x80

read_int:
    push ebp
    mov ebp, esp

    mov eax, 3
    mov ebx, 0
    mov ecx, num
    mov edx, 4
    int 0x80

    pop ebp
    ret
