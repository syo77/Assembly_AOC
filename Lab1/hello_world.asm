global _start

section .data                     
message: db 'hello, world!', 10  ; Mensagem a ser exibida seguida de uma nova linha (10 é '\n')

section .text 
_start:                           
    mov     rax, 1          ; O número da chamada de sistema (syscall) deve ser armazenado em rax
    mov     rdi, 1          ; Argumento #1 em rdi: onde escrever (descritor de arquivo)?
    mov     rsi, message    ; Argumento #2 em rsi: onde a string começa?
    mov     rdx, 14         ; Argumento #3 em rdx: quantos bytes escrever?
    syscall                 ; Esta instrução invoca uma chamada de sistema (syscall)
