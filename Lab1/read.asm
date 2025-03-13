section .bss
    num resb 16    ; Reserva espaço para armazenar da string (até 16 caracteres)

section .text
global _start

_start:
    ; SYS_READ (syscall 0) -> Lê a entrada do usuário
    mov rax, 0      ; syscall read
    mov rdi, 0      ; stdin
    mov rsi, num    ; Endereço onde armazenar a string
    mov rdx, 16     ; Máximo de 16 bytes para entrada
    syscall

    ; SYS_WRITE (syscall 1) -> Escreve a entrada na tela
    mov rax, 1      ; syscall write
    mov rdi, 1      ; stdout
    mov rsi, num    ; Endereço da string armazenado
    mov rdx, 16     ; Número máximo de caracteres a imprimir
    syscall

    ; SYS_EXIT (syscall 60) -> Finaliza o programa
    mov rax, 60
    xor rdi, rdi
    syscall
