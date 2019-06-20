LIST P = 18f45k50
#include<p18f45k50.inc>

CONFIG WDTEN = OFF	;Deshabilita el Watchdog
CONFIG MCLRE = ON	;Se habilita el pin MCLEAR
CONFIG DEBUG = OFF	;Deshabilita el modo Debug
CONFIG LVP = OFF	;Deshabilita Low-Voltage programming
CONFIG FOSC = INTOSCIO	;Habilita el oscilador interno

org 0                   ;Comienza en la linea 0 

Aux1	EQU 0x00	;Reserva 1 byte
Aux2	EQU 0x01	;Reserva 1 byte
	
Start:
    MOVLB	0x0F        
    CLRF	ANSELD, 1
    CLRF	PORTD	    ;Limpia las salidas de puerto D
    CLRF	TRISD	    ;Define pines de puerto D como salidas
    CLRF	Aux1	    ;Limpia variable Aux1
    CLRF	Aux2	    ;Limpia variable Aux2
    MOVLW	b'00110011' ;Configura registro OSCCON
    MOVWF	OSCCON

MainLoop:
    BTG		PORTD, RD1 ;toggles PORTD PIN 1(20)
Retardo:
    DECFSZ	Aux1,1	    ;Decrementa Aux1 en 1, salta siguiente instruccion si Aux1 es 0
    GOTO	Retardo	    ;el programa continua en Retardo
    DECFSZ      Aux2,1	    ;Decrementa Aux2 en 1, salta siguiente instruccion si Aux1 es 0
    GOTO	Retardo     ;el programa continua en Retardo
    GOTO	MainLoop
    END