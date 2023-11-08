; Created by Daniel Osah
; ISS Program at SADT, Southern Alberta Institute of Technology
; November 2023
; x86-64, NASM

; ********************************************************************************
; Functionality of the program:
; 1. Ask the user for a memory location value (0x402500)
; 2. Read(R) or Write (W) - program should force uppercase 
; 3. If R is selected:
;   a. read address 0x402500, 
;   b. print out value in address
; 4. If W is selected:
;   a. ask for address value
;   b. write address value into 0x402500

; function _storeAddress (arg0, arg2,)
; arg0 - the address value ==> rbx
; arg1 - the value to store at address ==>rcx
; run program in loop until user selects Q. - program should force uppercase again
; ********************************************************************************
global _start
   
section .data
    prompt1: db "Select one of the following options: ", 0x0A, 0x0A 0x00
        prompt1_len: equ $ - prompt1

    option: db "Option: ", 0x00
    option_len: equ $ - option

    ; WRITE
    intro1: db "You've invoked write mode. ", 0x0A, 0x0A, 0x00
        intro1_len: equ $ - intro1
    menu_item1: db "1. Press 'W' - Specify & write into address.", 0x0A, 0x00
        menu_item1_len: equ $ - menu_item1
    ; messages when user selects write
    message_w1: db "Input address (ex. 0x402500): ", 0x00
        message_len1: equ $ - message_w1
    message_w2: db "Input the value: ", 0x00 
        message_len2: equ $ - message_w2
    message_w3: db "The address value, and the value within are: ", 0x00  
        message_len3: equ $ - message_w3
    
    ; READ
    intro2: db "You've invoked read mode. ", 0x0A, 0x0A, 0x00
        intro2_len: equ $ - intro2
    menu_item2: db "2. Press 'R' - Read value at address.", 0x0A, 0x00
        menu_item2_len: equ $ - menu_item2
    ; messages when user selects read
    message_r1: db "Input address (ex. 0x402500): ", 0x00
        ; user message_len1
    message_r2: db "The value within this address is: ", 0x00
        message_len4: equ $ - message_r2

    ; QUIT
    menu_item3: db "3. Press Any Key - QUIT PROGRAM.", 0x00, 0x0A
       menu_item3_len: equ $ - menu_item3
    
    quit: db "...QUITTING...", 0x00
        quit_len: equ $ - quit


section .bss
    address: resb 0xFFFF
    value: resb 0xFFFF

    user_Input: resb 2

section .text
_start:
 .loop:
; MAIN MENU
    mov     r8, prompt1 ; "Select one of the following options: "
    mov     r9, prompt1_len
    call    _print

    mov     r8, menu_item1 ; "1. Press 'W' - Specify & write into address."
    mov     r9, menu_item1_len
    call    _print

    mov     r8, menu_item2 ; "2. Press 'R' - Read value at address."
    mov     r9, menu_item2_len
    call    _print

    mov     r8, menu_item3 ; "3. Press Any Key - QUIT PROGRAM."
    mov     r9, menu_item3_len
    call    _print

    mov     r8, option ; "Option: "
    mov     r9, option_len
    call    _print

; accept user input:
    xor     rax, rax
    xor     rdi, rdi
    mov     rsi, user_Input
    mov     rdx, 0x02
     syscall

; evaluate input
    mov     al, byte [user_Input + 0]
    and     al, 0xdf            ; negative mask to uppercase
    cmp     al, 'W'
    je      _write
    cmp     al, 'R'
    je      _read
    jmp     _exit

_print: ; print function
    mov     rax, 0x01 
    mov     rdi, 0x01
    mov     rsi, r8
    mov     rdx, r9
     syscall

    ; clear reg
    xor     r8, r8
    xor     r9, r9
     RET

_scan: ; scan for value
    ; clear reg
    xor     r8, r8
    xor     r9, r9

    xor     rax, rax
    xor     rdi, rdi
    mov     rsi, r8
    mov     rdx, 0xFFFF
     syscall
     RET

_write: 
; tell user current mode
    mov     r8, intro1 ; "You've invoked write mode. "
    mov     r9, intro1_len
    call    _print
    
    mov     r8, message_w1 ; "Input address (ex. 0x402500): "
    mov     r9, message_len1
    call    _print
    call    _scan
    mov     qword [address], r8 ; accept address from user
    
    mov     r8, message_w2 ; "Input the value: "
    mov     r9, message_len2
    call    _print
    call    _scan
    mov     qword [value], r8 ; accept value from user

    mov     r8, message_w3
    mov     r9, message_len3 ; "The address value, and the value within are: "
    call    _print
    mov     r8, address
    mov     r9, 10
    call    _print ; print address
    mov     r8, value
    mov     r9, 10
    call    _print ; print value
    
    push    value
    push    address

    jmp     _start.loop

_read:
; tell user current mode
    mov     r8, intro2 ; "You've invoked read mode. "
    mov     r9, intro2_len
    call    _print
    
    mov     r8, message_r1 ; "Input address(ex. 0x402500): "
    mov     r9, message_len1
    call    _print
    call    _scan
    mov     qword [address], r8
    
    call _readAddress

    add rsp, 0x10

    
    jmp _start.loop

_readAddress:
   push     rbp     ; save old rbp
   mov      rbp, rsp ; create new stack frame
   sub      rsp, 0x10
   pop      qword [value]
   pop      qword [address] 
   mov      r8, message_r2
   mov      r9, message_len4 ; "The value within this address is: "
   call     _print
   
    ret
    jmp _start.loop

; EXIT
_exit:
    mov     rax, 0x01 ; print instruction for user
    mov     rdi, 0x01
    mov     rsi, quit
    mov     rdx, quit_len
     syscall
    
    mov     rax, 0x3C
    mov     rdi, 0x00
    syscall

    
