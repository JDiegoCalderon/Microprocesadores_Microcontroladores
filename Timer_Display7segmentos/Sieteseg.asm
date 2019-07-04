LIST P = 18f45K50
#include<p18f45K50.inc>
    
;CONFIG WDTEN = OFF ; Deshabilita el Watchdog
;CONFIG MCLRE = ON ; Se habilita el pin MCLEAR
;CONFIG DEBUG = OFF ; Deshabilita el modo Debug
;CONFIG LVP = OFF ; Deshabilita Low-Voltage programming
;CONFIG FOSC = INTOSCIO ; Habilita el oscilador interno
    
AUX1 EQU 0x00
AUX2 EQU 0x01
 
ORG 1000h
GOTO Start ; Goes to instruction after Start tag
ORG 1008h ; Sets next instruction in address 000008h
GOTO Inter
 
Start:
    MOVLB 0x0F
    CLRF ANSELB,1
    CLRF TRISB		; PORTB pins as outputs
    CLRF PORTB		; Clear PORTB
    MOVLW b'01010011' ; Configures OSCCON register
    MOVWF OSCCON
    MOVLW b'10000011'
    MOVWF T0CON		; Enables TMR0 with a rate 1:16
    MOVLW b'10100000'
    MOVWF INTCON		; Enables TMR0 interrupt
    
MainLoop:
    MOVF AUX1,0
    CALL Display
    MOVWF PORTB
    GOTO MainLoop
    
Display:
    MULLW 0x02
    MOVF PRODL,W
    ADDWF PCL,F
    RETLW 0x7E 
    RETLW 0x30
    RETLW 0x6D
    RETLW 0x79
    RETLW 0x33
    RETLW 0x5B
    RETLW 0x5F
    RETLW 0x70
    RETLW 0x7F
    RETLW 0x73
    
Inter:
    MOVWF AUX2 ; Saves W register value
    INCF AUX1
    MOVLW 0x0A ; Verifies AUX1 value only reaches 9
    SUBWF AUX1,W
    BTFSC STATUS,2 ; Verifies if previous operation produces 0
    CLRF AUX1
    MOVF AUX2,W ; Returns original value to W register
    BCF INTCON,2 ; Clears TMR0 interrupt flag
    RETFIE
    END