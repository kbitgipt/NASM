section .data
    msg db 'How many numbers: ',0   ; Prompt message
    len_msg equ $ - msg

section .bss
    num resd 1                     ; Variable to store the number of inputs
    numbers resb 4                ; Array to store input numbers (up to 10)
    sum resd 1                     ; Variable to store the sum

section .text
    global _start

_start:
    ; Display the prompt for the number of inputs
    mov eax, 4                      ; sys_write
    mov ebx, 1                      ; stdout
    mov ecx, msg                    ; message address
    mov edx, len_msg                ; message length
    int 0x80

    ; Read the number of inputs
    mov eax, 3                      ; sys_read
    mov ebx, 0                      ; stdin
    mov ecx, num                    ; address to store the number of inputs
    mov edx, 4                      ; read 4 bytes (int)
    int 0x80

    ; Convert the input to an integer
    mov eax, [num]
    sub eax, '0'                    ; Convert ASCII digit to integer
    mov [num], eax
    add eax, '0'
    
    ; Initialize sum to 0
    mov dword [sum], 0
    
    ; Loop input
    mov cl, [num]
input_loop:
    ; Read the next number
    mov eax, 3                      ; sys_read
    mov ebx, 0                      ; stdin
    mov ecx, numbers                ; address to store the current number
    mov edx, 4                      ; read 4 bytes (int)
    int 0x80

    ; Convert the input to an integer
    mov eax, [numbers]
    sub eax, '0'                    ; Convert ASCII digit to integer
    add [sum], eax
    add eax, '0'
    
    dec cl                         ; Decrement loop counter
    jnz input_loop

done_input:
    ; Display the sum
    mov eax, 4                      ; sys_write
    mov ebx, 1                      ; stdout
    mov ecx, sum                    ; address of the sum
    mov edx, 4                      ; 4 bytes to print (int)
    int 0x80

    ; Exit the program
    mov eax, 1                      ; sys_exit
    int 0x80