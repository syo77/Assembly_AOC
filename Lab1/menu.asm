section .data
    menu_msg db "Escolha a operacao:", 10
             db "1 - Soma", 10
             db "2 - Subtracao", 10
             db "Opcao: ", 0
    num1_msg db "Digite o primeiro numero: ", 0
    num2_msg db "Digite o segundo numero: ", 0
    result_msg db "Resultado: ", 0
    newline db 10, 0
    ten dq 10  ; Constante usada para divisão por 10
    clear_screen db 27, "[2J", 27, "[H", 0  ; Sequência ANSI para limpar a tela

section .bss
    opt resb 2       ; Armazena a opção do usuário
    num1 resb 16        ; Armazena o primeiro número (string)
    num2 resb 16        ; Armazena o segundo número (string)
    result_str resb 16  ; Buffer para armazenar o número convertido em string

section .text
global _start

; --------------------------------------------------------
; Função print_string (Exibe uma string até encontrar o código 0)
; --------------------------------------------------------
print_string:
    push rsi            ; Salva o ponteiro original da string
    xor rdx, rdx        ; Zera rdx (contador de tamanho)

.loop:
    mov al, [rsi + rdx] ; Carrega um byte da string
    test al, al         ; Verifica se é '\0' (terminador nulo)
    jz .done            ; Se for '\0', sai do loop
    inc rdx             ; Incrementa o contador
    jmp .loop           ; Continua no loop

.done:
    mov rax, 1          ; syscall write
    mov rdi, 1          ; stdout
    pop rsi             ; Recupera o endereço original da string
    syscall             ; Chama syscall para exibir a string
    ret

; --------------------------------------------------------
; Função read_string (Lê uma string do usuário)
; --------------------------------------------------------
read_string:
    mov rax, 0          ; syscall read
    mov rdi, 0          ; stdin
    mov rdx, 16         ; Lê até 16 bytes
    syscall
    ret

; --------------------------------------------------------
; Função str_to_int (Converte uma string numérica em um inteiro)
; --------------------------------------------------------
str_to_int:
    xor rax, rax        ; Zera rax para armazenar o número convertido
    xor rcx, rcx        ; Zera rcx (contador de posição na string)

.loop:
    movzx rdx, byte [rsi + rcx]  ; Carrega o próximo caractere da string
    test rdx, rdx                ; Verifica se é o final da string ('\0')
    jz .done
    cmp rdx, 10                  ; Verifica se é uma quebra de linha '\n'
    je .done
    sub rdx, '0'                 ; Converte caractere ASCII para número (0-9)
    imul rax, rax, 10            ; Multiplica rax por 10 (deslocamento decimal)
    add rax, rdx                 ; Adiciona o dígito convertido
    inc rcx                      ; Avança para o próximo caractere
    jmp .loop

.done:
    ret                          ; Retorna com o número inteiro armazenado em rax

; --------------------------------------------------------
; Função int_to_str (Converte um inteiro em string)
; --------------------------------------------------------
int_to_str:
    mov rsi, result_str   ; Ponteiro para o buffer de saída
    add rsi, 15           ; Move para o final do buffer (números são escritos de trás para frente)
    mov byte [rsi], 0     ; Adiciona terminador nulo '\0'
    dec rsi

    test rax, rax         ; Verifica se rax é zero
    jnz .loop
    mov byte [rsi], '0'   ; Se rax for zero, escreve '0' na string
    ret

.loop:
    xor rdx, rdx          ; Limpa rdx para evitar sobras na divisão
    div qword [ten]       ; Divide rax por 10 (rdx = rax % 10, rax = rax / 10)
    add dl, '0'           ; Converte o número para ASCII
    mov [rsi], dl         ; Armazena o caractere na string
    dec rsi               ; Move para o próximo caractere
    test rax, rax         ; Se rax ainda não for zero, continuar
    jnz .loop

    inc rsi               ; Ajusta ponteiro para o início da string convertida
    ret                   ; Retorna com rsi apontando para o resultado

; --------------------------------------------------------
; Função exit (Finaliza o programa)
; --------------------------------------------------------
exit:
    mov rsi, clear_screen
    call print_string
    mov rax, 60  ; syscall exit
    syscall
    ret

; --------------------------------------------------------
; Início do programa
; --------------------------------------------------------
_start:
    mov rsi, menu_msg
    call print_string

    mov rsi, opt
    call read_string
    mov al, byte [opt]  
    cmp al, '1'
    je soma
    cmp al, '2'
    je subtracao

    call exit  ; Se a opção for inválida, sai do programa

ler_numeros:
    mov rsi, num1_msg
    call print_string

    mov rsi, num1
    call read_string
    mov rsi, num1        ; Converte num1 para inteiro
    call str_to_int      
    mov rbx, rax         ; Armazena o valor de num1 em rbx

    mov rsi, num2_msg
    call print_string

    mov rsi, num2
    call read_string
    mov rsi, num2        ; Converte num2 para inteiro
    call str_to_int      
    mov rcx, rax         ; Armazena o valor de num2 em rcx
    ret

soma:
    call ler_numeros    
    add rbx, rcx   ; rbx = num1 + num2
    jmp resultado

subtracao:
    call ler_numeros
    sub rbx, rcx   ; rbx = num1 - num2
    jmp resultado

resultado:

    mov rsi, result_msg
    call print_string
    
    mov rax, rbx
    call int_to_str
    call print_string

    call read_string
    mov rsi, clear_screen
    call print_string

    jmp _start  ; Reinicia o programa
