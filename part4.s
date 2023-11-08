; Created by Daniel Osah
; ISS Program at SADT, Southern Alberta Institute of Technology
; October 2023
; x86-64, NASM

; *******************************
; Functionality of the program:
; Lab 3 Part 4 - loop, lea, basic call example
; Program Loops through text and finds
; character difined on line 16
; then prints the offset to that character
; *******************************

section .text
global _start

_start:

    mov rbx, 0x00   ; loop counter
    .loop:
        lea rcx, [text + rbx]
        mov al, byte [rcx]
        cmp al, 0x00
        jz _exit    ; jmp near if 0 
                    ; terminate at the
                    ; end of message
        cmp al, '.' ; character to be found
        jz _found
        inc rbx
        jmp .loop

_found: 
     call _hex_to_ascii
    mov [msg_offset], ebx
    mov r8, message_prompt
    mov r9, message_prompt_len
     call _print

    mov r8, msg_offset
    mov r9, 0x01
     call _print
    
    jmp _exit

_hex_to_ascii:
    ; only works with single hex digit, but can easily
    ; expanded for every digit in register
    ; there are better algos to address ascii bias

    add rbx, 0x30
    cmp rbx, 0x39
    jle .end
    add rbx, 0x7
    .end:
     ret

_print:
    ; requires buffer in r8, len in r9
    mov rax, 0x01       ; write syscall
    mov rdi, 0x01       ; STDOUT
    mov rsi, r8
    mov rdx, r9
     syscall
     ret

_exit:
    mov rax, 0x3c
    mov rdi, 0x01
     syscall

section .data
    message_prompt: db "Found at this offset: ", 0x00
    message_prompt_len: equ $ - message_prompt
    text: db "0 - term. msg.", 0x00
    ; text length not needed

section .bss
    msg_offset: resb 1


