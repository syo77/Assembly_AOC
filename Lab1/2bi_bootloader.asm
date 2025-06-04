[BITS 16]
[ORG 0x0600] ; Endereço onde o bootloader carregará este programa

start:
    mov si, msg_menu
    call print_string

    call read_char
    cmp al, '1'
    je soma
    cmp al, '2'
    je subtrai
    cmp al, '3'
    je multiplica
    cmp al, '4'
    je divide
    jmp start  ; opção inválida, reinicia

soma:
    call ler_dois_numeros
    add bx, dx
    jmp mostrar_resultado

subtrai:
    call ler_dois_numeros
    sub bx, dx
    jmp mostrar_resultado

multiplica:
    call ler_dois_numeros
    mov ax, bx
    mul dx       ; ax = bx * dx
    mov bx, ax
    jmp mostrar_resultado

divide:
    call ler_dois_numeros
    cmp dx, 0
    je erro_div_zero
    mov ax, bx
    xor dx, dx
    div dx       ; ax = bx / dx
    mov bx, ax
    jmp mostrar_resultado

erro_div_zero:
    mov si, msg_erro
    call print_string
    jmp start

ler_dois_numeros:
    mov si, msg_num1
    call print_string
    call read_number
    mov bx, ax

    mov si, msg_num2
    call print_string
    call read_number
    mov dx, ax
    ret

mostrar_resultado:
    mov si, msg_result
    call print_string

    mov ax, bx
    call print_number

    call new_line
    jmp start

; -------------------
; Funções auxiliares
; -------------------

print_string:
    mov ah, 0x0E
.print_char:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .print_char
.done:
    ret

read_char:
    mov ah, 0x00
    int 0x16
    mov ah, 0x0E
    int 0x10  ; ecoa
    ret

read_number:
    xor ax, ax
    xor bx, bx
.next_digit:
    call read_char
    cmp al, 13       ; ENTER
    je .done
    sub al, '0'
    cmp al, 9
    ja .next_digit
    mov cx, 10
    mul cx           ; ax *= 10
    add ax, bx
    mov bx, ax
    jmp .next_digit
.done:
    ret

print_number:
    mov cx, 0
    mov dx, 0
    mov bx, 10
    cmp ax, 0
    jne .convert
    mov al, '0'
    call print_char
    ret
.convert:
    push ax
.next:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz .next
.print:
    pop dx
    add dl, '0'
    mov ah, 0x0E
    mov al, dl
    int 0x10
    loop .print
    ret

print_char:
    mov ah, 0x0E
    int 0x10
    ret

new_line:
    mov al, 13
    call print_char
    mov al, 10
    call print_char
    ret

; -------------------
; Mensagens
; -------------------

msg_menu db 13,10, "Calculadora", 13,10
         db "1 - Soma", 13,10
         db "2 - Subtracao", 13,10
         db "3 - Multiplicacao", 13,10
         db "4 - Divisao", 13,10
         db "Escolha uma opcao: ", 0

msg_num1 db 13,10, "Digite o primeiro numero: ", 0
msg_num2 db 13,10, "Digite o segundo numero: ", 0
msg_result db 13,10, "Resultado: ", 0
msg_erro db 13,10, "Erro: Divisao por zero!", 0
