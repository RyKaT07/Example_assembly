.cdecls C,LIST, "msp430.h"       ; Importowanie biblioteki rejestrów
    .global _start                   ; Defnicja głównej funkcji
    
    .text
_start:
    mov.w   #0400h, SP               ; Ustawienie wskaźnika na początek stosu
    mov.w   #WDTPW+WDTHOLD, &WDTCTL  ; Wyłączenie watchdoga, aby nie resetował mikrokontrolera

    ; Procesor z dostepnych dla mnie informacji nie ma wyjścia tekstowego, 
    ; więc "Hello World" przesyłam przez UART
    bis.b   #0x30, &P3SEL            ; ustawiam piny P3.4 i P3.5 jako UART
    mov.b   #0x11, &U0CTL            ; Reset + 8-bitowe sekcje danych, 1 stop bit, brak parity, UART mode
    mov.b   #0x20, &U0TCTL           ; Źródło zegara = SMCLK
    mov.b   #0x68, &U0BR0            ; Baud rate 9600 (LSB)
    mov.b   #0x00, &U0BR1            ; Baud rate 9600 (MSB)
    bic.b   #0x01, &U0CTL            ; Zwolnienie resetu USART

    ; Wysłanie "Hello, World!" przez UART
    mov.w   #hello, R12              ; Załaduj adres stringa
send_loop:
    mov.b   @R12+, R15               ; Pobierz znak z pamięci
    cmp.b   #0, R15                  ; Sprawdź znak końca (NULL)
    je      nop                      ; Jeśli koniec, zakończ
    call    #uart_putc               ; Wyślij znak
    jmp     send_loop                ; Następny znak

; Pomocniczy program wysyłający znak przez UART
uart_putc:
    bit.b   #0x02, &IFG2             ; Sprawdzenie gotowości nadajnika uart rx
    jz      uart_putc                ; Jeśli niegotowy, czekaj
    mov.b   R15, &UCA0TXBUF          ; Wysłanie znaku
    ret

    .data
hello:
    .string "Hello, World!\n"         ; Tekst do wysłania