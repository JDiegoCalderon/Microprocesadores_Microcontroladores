LIST P = 18f45k50
#include<p18f45k50.inc>
    
CONFIG WDTEN = OFF	;Deshabilita el Watchdog
CONFIG MCLRE = ON	;Se habilita el pin MCLEAR
CONFIG DEBUG = OFF	;Deshabilita el modo Debug
CONFIG LVP = OFF	;Deshabilita Low-Voltage programming
CONFIG FOSC = INTOSCIO	;Habilita el oscilador interno
    
org 0; 
;org 1000
    
Start:

    CLRF PORTB
    CLRF TRISB
    SETF TRISA
    BSF ANSELA,0
    MOVLW b'01010011'        ;Reloj interno a 4 MHz
    MOVWF OSCCON
    MOVLW b'00000001'        ;Se selecciona el canal A0 y se enciende el convertidor
    MOVWF ADCON0 
    MOVLW b'00000000'        ;Se define Vref-,Vref+
    MOVWF ADCON1
    MOVLW b'00100100'        ;Se define	ACQT=8TAD y TAD de lmicroS
    MOVWF ADCON2             ;Justificado a la izquierda
    
MainLoop:
    BSF ADCON0,1	    ;Inicia conversion
conv:
    BTFSC ADCON0,1         ;Comprueba que el bit GO/DONE sea cero
    GOTO conv              ;Ciclo para verificar bit 1 de ADCON0
    
    MOVFF ADRESH, PORTB    ;Mueve adresh al puerto B
    GOTO MainLoop          ;Salta a la instruccion precedida por la etiqueta incio
    END                    ;Directiva que indica el final del programa 