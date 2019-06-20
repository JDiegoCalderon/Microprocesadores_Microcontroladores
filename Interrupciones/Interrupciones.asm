LIST P = 18f45K50
#include<p18f45k50.inc>
    
CONFIG WDTEN = OFF ; Disables Watchdog
CONFIG MCLRE = ON ; Enables MCLEAR
CONFIG DEBUG = OFF ; Disables Debug mode
CONFIG LVP = OFF ; Disables Low-Voltage programming
CONFIG FOSC = INTOSCIO ; Enables internal oscillator
    
AUX1 EQU 0x00 ; Reserves register 0
AUX2 EQU 0x01 ; Reserves register 1
Delay1 EQU 0x02 ; Reserves register 2
Delay2 EQU 0x03 ; Reserves register 3
 
org 0 ; Sets first instruction in address 00

ORG 00000h
GOTO Start	; Goes to instruction after Start tag
ORG 00008h	; Loads the following instruction at address 000008h
GOTO InterH
ORG 00018h	; Loads the following instruction at address 000018h
GOTO InterL
 
Start:
    MOVLB 0x0F
    CLRF ANSELA,1
    CLRF ANSELB,1
    CLRF ANSELD,1
    CLRF TRISA	    ; PORT D as outputs  
    CLRF TRISD	    ; PORT A as outputs
    SETF TRISB	    ; PORT B as inputs
    MOVLW b'11010000'
    MOVWF INTCON    ; Enables external interrupt RB0
    BSF RCON,IPEN   ; Enables interrupt priority levels
    MOVLW b'00001000'
    MOVWF INTCON3   ; Enables external interrupt RB1, low priority
    MOVLW b'01100011'   ; Configures OSCCON register
    MOVWF OSCCON
    CLRF PORTD	    ; Clears PORT D outputs
    CLRF PORTA	    ; Clears PORT A outputs
    
MainLoop:
    BTG PORTA,RA0 ;Toggle PORT A PIN 0 (2)
    CALL Delay
    GOTO MainLoop
Delay:
    DECFSZ Delay1,1 ;Decrements Delay1 by 1, skip next instruction if Delay1 is 0
    GOTO Delay
    DECFSZ Delay2,1
    GOTO Delay
    RETURN
    
InterL:
    MOVLW 0X0A
    MOVWF AUX1 ; Loads AUX1 with amount of flashes for PORTD
Ciclo1:
    SETF PORTD ; Sets PORT D outputs
    CALL Delay
    CLRF PORTD ; Clears PORT D outputs
    CALL Delay
    DECFSZ AUX1
    GOTO Ciclo1
    BCF INTCON3,0 ; Clears external interrupt flag
    RETFIE
InterH:
    MOVLW 0X0A
    MOVWF AUX2 ; Loads AUX2 with amount of flashes of PORTD
    MOVLW 0x0F
    MOVWF PORTD ; Sets half the outputs of PORT D
Ciclo2:
    CALL Delay
    SWAPF PORTD ; Swaps PORT D outputs
    CALL Delay
    DECFSZ AUX2
    GOTO Ciclo2
    BCF INTCON,1 ; Clears external interrupt flag
    RETFIE
    END