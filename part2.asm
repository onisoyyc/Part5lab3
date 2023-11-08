; Created by Daniel Osah
; ISS Program at SADT, Southern Alberta Institute of Technology
; October 2023
; x86-64, NASM

; *******************************
; Functionality of the program:
; Demonstrate intake of user input
; and manipulation of said input to
; display back to the user
; 
; 1.promt user
; 2. read user input
; 3. display user input back to them
; 4.Make user input camel case, where each 1st letter of a word will be capitalized
;   a. First address will automatically be capitalized
;   b. use index to iterate throught the string
; 5. When null terminator is reached, print user's capitialized string
; 6. Terminate program
; *******************************
global _start

section .data
    prompt0: db "Enter sentence: ", 0x00
        len0: equ $ - prompt0
    prompt1: db "You Entered: ", 0x00 ; return the sentence the user entered
        len1: equ $ - prompt1
    prompt2: db "Sentence with Camel Case: " ; return the sentence with camel case to user
        len2: equ $ - prompt2

        ; first few attempts didn't work so lets use test string
    ; test_string: db "Manipulate this string into Camel Case wIth cODe", 0x0A, 0x00
  
section .bss
    buffer: resb 0x64               ; reserve 100 bytes for string
   
section .text
_start:

; first prompt
        mov     rax, 0x01
        mov     rdi, 0x01
        mov     rsi, prompt0
        mov     rdx, len0
         syscall

; take user input
        xor     rax, rax
        xor     rdi, rdi
        mov     rsi, buffer
        mov     rdx, 0x64
        syscall
   
; print user input without camel case
        mov     rax, 0x01
        mov     rdi, 0x01
        mov     rsi, prompt1
        mov     rdx, len1
        syscall

        mov     rax, 0x01
        mov     rdi, 0x01
        mov     rsi, buffer
        mov     rdx, 0x64
        syscall

        xor rax, rax
        xor rdi, rdi
        xor rsi, rsi
        xor rdx, rdx

_FirstChar:                     ; take input and capitalize first letter
    mov     rbx, 0x00
    mov     al, [buffer + rbx]
    and     al, 0xdf            ; force uppercase

    xor     rax, rax
    inc     rbx
_camelCase:

    ; if after space (0x20), then force uppercase
    .loop:
        mov     al, [buffer + rbx]
        cmp     al, 0x00        ; check for NULL terminator
        je      _printCamelCase
        cmp     al, 0x20        ; check for space
        je      _forceUppercase
    ; if not after space (0x20), then force lowercase
        mov     al, [buffer + rbx]
        or      al, 0x20        ; force lowercase
        mov     byte [buffer + rbx], al
        inc     rbx
        jmp     .loop

_forceUppercase:
    inc     rbx
    mov     al, [buffer + rbx]
    and     al, 0xdf            ; negative mask to uppercase
    mov     byte [buffer + rbx], al
    inc     rbx
    jmp     _camelCase.loop

_printCamelCase:                ; print camel case buffer
        mov     rax, 0x01
        mov     rdi, 0x01
        mov     rsi, prompt2
        mov     rdx, len2
        syscall

        mov     rax, 0x01
        mov     rdi, 0x01
        mov     rsi, buffer
        mov     rdx, 0x64
        syscall

_exit:
    mov     rax, 0x3C
    mov     rdi, 0x00
    syscall

