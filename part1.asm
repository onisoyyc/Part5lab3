; Created by Daniel Osah
; ISS Program at SADT, Southern Alberta Institute of Technology
; October 2023
; x86-64, NASM

; *******************************
; Functionality of the program:
; Understanding opcodes and instructions
; *******************************

section .text
global _start

_start: 
    mov ax,     0xABCD
    mov rax,    0xABCD
    mov rax,    0xFFFFFFFF
    mov rax,    0xFFFFFFFFFFFFFFFF
    mov rax,    0xABCDEF0123456789