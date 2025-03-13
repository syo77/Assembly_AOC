section .data                     
message: db  'hello, world!', 10  ; Mensagem a ser exibida seguida de uma nova linha (10 é '\n')

section .text
global _start

_start:                           
    mov     rax, 1           ; Número da syscall 'write' (escrita)
    mov     rdi, 1           ; Descritor de saída padrão (stdout)
    mov     rsi, message     ; Endereço da string a ser exibida
    mov     rdx, 14          ; Tamanho da string em bytes (13 caracteres + '\n')
    syscall                  ; Chama a syscall para escrever a mensagem

    mov     rax, 60          ; Número da syscall 'exit' (sair do programa)
    xor     rdi, rdi         ; Código de saída 0 (sucesso)
    syscall                  ; Chama a syscall para encerrar o programa