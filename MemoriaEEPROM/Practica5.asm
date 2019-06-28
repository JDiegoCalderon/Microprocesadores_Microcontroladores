LIST P = 18f45K50
#include<p18f45K50.inc>
    
;CONFIG WDTEN = OFF
;CONFIG MCLRE = ON
;CONFIG DEBUG = OFF
;CONFIG LVP = OFF
;CONFIG FOSC = INTOSCIO
    
AUX1 EQU 0x00
Delay1 EQU 0x01
Delay2 EQU 0x02
 org 1000
 
MOVLB 0x0F
CLRF ANSELB,1
CLRF ANSELA,1
CLRF TRISB ; PORTB pins as outputs
CLRF PORTB ; Clear PORTB
SETF PORTA ; PORTA as inputs
MOVLW b'01010011' ; Configures OSCCON register
MOVWF OSCCON
MOVLW 0x00
MOVWF EEADR ; Memory address to read
BCF EECON1,EEPGD ; Data memory selection
BCF EECON1,CFGS ; EEPROM access
 BSF EECON1,RD ; Reads EEPROM
MOVF EEDATA,W ; W <= Data from EEPROM
MOVWF AUX1 ; AUX1 <= W
 
loop:
BTFSC PORTA,0 ; If bit 0 = 1 resets counter
CLRF AUX1
INCF AUX1,F ; Increases counter
MOVF AUX1,w ; W <= AUX1
MOVWF PORTB ; W => PORTB.
MOVWF EEDATA ; W => EEPROM
BCF EECON1,EEPGD ; Selects EEPROM memory
BCF EECON1,CFGS ; EEPROM access
BSF EECON1,WREN ; Enables writing
MOVLW 0x55
MOVWF EECON2 ; Required instruction
MOVLW 0xAA
MOVWF EECON2 ; Required instruction
BSF EECON1,WR ; Writing starts
BCF EECON1,WREN ; Inhibits writing cycles
CALL retardo ; Calls delay subrutine
GOTO loop ; Restarts loop
    
;********* DELAY SUBRUTINE ************************
retardo:
decfsz Delay1,1
goto retardo
decfsz Delay2,1
goto retardo
return
END