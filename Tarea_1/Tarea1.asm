LIST P = 18f45k50
#include<p18f45k50.inc>

CONFIG WDTEN = OFF	;Deshabilita el Watchdog
CONFIG MCLRE = ON	;Se habilita el pin MCLEAR
CONFIG DEBUG = OFF	;Deshabilita el modo Debug
CONFIG LVP = OFF	;Deshabilita Low-Voltage programming
CONFIG FOSC = INTOSCIO	;Habilita el oscilador interno

org 0; 

Aux1	EQU 0x00	;Reserva 1 byte
Aux2	EQU 0x01	;Reserva 1 byte


Star:
    MOVLB	0x0F
    CLRF	ANSELD, 1
    CLRF	PORTD	    ;Limpia las salidas de puerto D
    CLRF	TRISD	    ;Define pines de puerto D como salidas
    CLRF	Aux1	    ;Limpia variable Aux1
    CLRF	Aux2	    ;Limpia variable Aux2
    MOVLW	b'00110011' ;Se define la frecuencia 
    MOVWF	OSCCON		
    MOVLW	b'00011000' ;Se comienza en en RD3 Y RD4
    MOVWF	PORTD
    
MainLoop:
    BSF PORTD, 3	    ;Pone en 1 el bit 3
    BSF PORTD, 4	    ;Pone en 1 el bit 4 
    ;BCF PORTD, 0	    ;Pone en 0 el bit 0
    ;BCF PORTD, 7	    ;Pone en 0 el bit 7
    CALL Retardo	    ;Ejecuta la subrutina Retardo.....Aqui sigue despues de subrutina
    BCF PORTD, 3	    ;Pone el bit 3 en 0
    BCF PORTD, 4	    ;Pone el bit 4 en 0
    BSF PORTD, 2	    ;Pone el bit 2 en 1
    BSF PORTD, 5	    ;Pone el bit 5 en 1
    CALL Retardo	    ;Ejecuta la subrutina Retardo.....Aqui sigue despues de subrutina
    BCF PORTD, 2	    ;Pone el bit 2 en 0
    BCF PORTD, 5	    ;Pone el bit 5 en 0
    BSF PORTD, 1	    ;Pone el bit 6 en 1
    BSF PORTD, 6	    ;Pone en 1 el bit 1 
    CALL Retardo	    ;Ejecuta la subrutina Retardo.....Aqui sigue despues de subrutina
    BCF PORTD, 6	    ;Pone en 0 el bit 6
    BCF PORTD, 1	    ;Pone en 0 el bit 1
    BSF PORTD, 0	    ;Pone en 1 el bit 0
    BSF PORTD, 7	    ;Pone en 1 el bit 7 
    CALL Retardo	    ;Ejecuta la subrutina Retardo.....Aqui sigue despues de subrutina
    BCF PORTD, 0	    ;Pone en 0 el bit 0	
    BCF PORTD, 7	    ;Pone en 0 el bit 7
    BSF PORTD, 1	    ;Pone en 1 el bit 1
    BSF PORTD, 6	    ;Pone en 1 el bit 6
    CALL Retardo	    ;Ejecuta la subrutina Retardo.....Aqui sigue despues de subrutina
    BCF PORTD, 1	    ;Pone en 0 el bit 1
    BCF PORTD, 6	    ;Pone en 0 el bit 6	
    BSF PORTD, 2	    ;Pone en 1 el bit 2
    BSF PORTD, 5	    ;Pone en 1 el bit 5
			    ;El programa regresa al Bit 3 y 4 
    ;CALL Retardo
    ;GOTO        MainLoop        ;baja aqui si el bit 7 vale 0

;    RLNCF       PORTD, f	;Toggle PORT DPIN 1(20)
;    CALL        Retardo         
;    BTFSS	PORTD, 7        ;detecta el bit si ya llego al nivel 7
;    GOTO        MainLoop        ;baja aqui si el bit 7 vale 0

    
;SecondaryLoop:
;    RRNCF       PORTD, f
;    CALL        Retardo
;    BTFSS       PORTD, 0
;    GOTO        SecondaryLoop
;    GOTO	MainLoop
;    
 
Retardo:
    MOVLW	0x00    ;Carga un numero en el acumulador 
    MOVWF	Aux2	;aux se carga con un valor diferente al inicial
Retardo2:
    DECFSZ	Aux1, 1	;Decrementa Aux1 en 1, salta siguiente instruccion si Aux1 es 0
    GOTO	Retardo2;el programa continua en Retardo2
    DECFSZ	Aux2, 1
    GOTO	Retardo2
    Return
    END