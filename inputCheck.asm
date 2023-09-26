section .data
    prompt db "Enter a number (0 to stop): ", 0
    sum_msg db "Sum: ", 0

section .bss
    num resb 10    ; Reserve 10 bytes for input buffer
    sum resq 1     ; Reserve 8 bytes for the sum

section .text
    global _start

_start:
    ; Display prompt
    mov eax, 4         ; sys_write syscall
    mov ebx, 1         ; File descriptor (stdout)
    mov ecx, prompt    ; Pointer to the prompt string
    mov edx, 27        ; Length of the prompt string
    int 0x80           ; Call kernel

    ; Initialize sum to 0
    mov qword [sum], 0

input_loop:
    ; Read input
    mov eax, 3         ; sys_read syscall
    mov ebx, 0         ; File descriptor (stdin)
    mov ecx, num       ; Pointer to the input buffer
    mov edx, 10        ; Maximum number of bytes to read
    int 0x80           ; Call kernel

    ; Convert the input to an integer
    mov eax, 0         ; Clear eax for conversion
    mov ecx, num       ; Pointer to the input buffer
    call str_to_int

    ; Check if the input is 0 (to stop)
    cmp eax, 0
    je done

    ; Add the input to the sum
    add qword [sum], rax

    ; Repeat the loop
    jmp input_loop

done:
    ; Display the sum
    mov eax, 4         ; sys_write syscall
    mov ebx, 1         ; File descriptor (stdout)
    mov ecx, sum_msg   ; Pointer to the sum message string
    mov edx, 5         ; Length of the sum message string
    int 0x80           ; Call kernel

    ; Display the sum value
    mov eax, 1         ; sys_exit syscall
    mov ebx, [sum]     ; Exit code is the sum value
    int 0x80           ; Call kernel

str_to_int:
    ; Input: ecx = pointer to null-terminated string
    ; Output: eax = integer value
    xor eax, eax       ; Clear eax
    xor ebx, ebx       ; Clear ebx (used for sign)
    xor edx, edx       ; Clear edx (used for result)

.next_digit:
    movzx edi, byte [ecx] ; Load the next character into edi
    cmp edi, 0            ; Check for null terminator
    je .done
    cmp edi, 45           ; Check for minus sign '-'
    je .negative
    cmp edi, 48           ; Check for '0'
    jb .error
    cmp edi, 57           ; Check for '9'
    ja .error

    ; Convert ASCII digit to integer
    sub edi, 48            ; Convert ASCII to integer
    imul eax, eax, 10      ; Multiply current result by 10
    add eax, edi           ; Add the new digit
    inc ecx                ; Move to the next character
    jmp .next_digit

.negative:
    inc ecx          ; Move past the '-' character
    jmp .check_done

.error:
    ; Handle invalid input
    mov eax, -1
    ret

.done:
    test ebx, ebx    ; Check if it's a negative number
    jz .check_done
    neg eax          ; Negate the result for negative numbers

.check_done:
    ret
