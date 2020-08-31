
_Delay_300:

;Digital Count DownTimer.c,38 :: 		void Delay_300(){
;Digital Count DownTimer.c,39 :: 		Delay_ms(300);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      134
	MOVWF      R12+0
	MOVLW      153
	MOVWF      R13+0
L_Delay_3000:
	DECFSZ     R13+0, 1
	GOTO       L_Delay_3000
	DECFSZ     R12+0, 1
	GOTO       L_Delay_3000
	DECFSZ     R11+0, 1
	GOTO       L_Delay_3000
;Digital Count DownTimer.c,40 :: 		}
L_end_Delay_300:
	RETURN
; end of _Delay_300

_Display_Digits:

;Digital Count DownTimer.c,42 :: 		void Display_Digits(){
;Digital Count DownTimer.c,43 :: 		digit[1]=unit+48;
	INCF       _digit+0, 0
	MOVWF      FSR
	MOVLW      48
	ADDWF      _unit+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      INDF+0
;Digital Count DownTimer.c,44 :: 		digit[0]=ten+48;
	MOVLW      48
	ADDWF      _ten+0, 0
	MOVWF      R0+0
	MOVF       _digit+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;Digital Count DownTimer.c,45 :: 		Lcd_Out(2,11,digit);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      11
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       _digit+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Digital Count DownTimer.c,46 :: 		}
L_end_Display_Digits:
	RETURN
; end of _Display_Digits

_start_timer:

;Digital Count DownTimer.c,48 :: 		void start_timer(unsigned short MinVal){
;Digital Count DownTimer.c,50 :: 		Relay = 0;
	BCF        RA3_bit+0, BitPos(RA3_bit+0)
;Digital Count DownTimer.c,51 :: 		ON_OFF = 1;
	MOVLW      1
	MOVWF      _ON_OFF+0
;Digital Count DownTimer.c,52 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Digital Count DownTimer.c,53 :: 		Lcd_Out(1,1,Message3);                    //Relay off
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _Message3+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Digital Count DownTimer.c,54 :: 		Lcd_Out(2,1,Message5);                    //time left
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _Message5+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Digital Count DownTimer.c,55 :: 		OPTION_REG = 0x80 ;
	MOVLW      128
	MOVWF      OPTION_REG+0
;Digital Count DownTimer.c,56 :: 		INTCON = 0x90;
	MOVLW      144
	MOVWF      INTCON+0
;Digital Count DownTimer.c,57 :: 		for (i=0; i<MinVal; i++){
	CLRF       _i+0
L_start_timer1:
	MOVF       FARG_start_timer_MinVal+0, 0
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_start_timer2
;Digital Count DownTimer.c,58 :: 		temp1 = (MinVal-i)%10 ;
	MOVF       _i+0, 0
	SUBWF      FARG_start_timer_MinVal+0, 0
	MOVWF      FLOC__start_timer+0
	CLRF       FLOC__start_timer+1
	BTFSS      STATUS+0, 0
	DECF       FLOC__start_timer+1, 1
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FLOC__start_timer+0, 0
	MOVWF      R0+0
	MOVF       FLOC__start_timer+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      start_timer_temp1_L0+0
;Digital Count DownTimer.c,59 :: 		temp2 = (MinVal-i)/10 ;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FLOC__start_timer+0, 0
	MOVWF      R0+0
	MOVF       FLOC__start_timer+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
;Digital Count DownTimer.c,60 :: 		Lcd_Chr(2, 12, temp2+48);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Digital Count DownTimer.c,61 :: 		Lcd_Chr(2, 13, temp1+48);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      start_timer_temp1_L0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Digital Count DownTimer.c,62 :: 		j=1;
	MOVLW      1
	MOVWF      _j+0
;Digital Count DownTimer.c,63 :: 		do {
L_start_timer4:
;Digital Count DownTimer.c,64 :: 		Delay_ms(1000);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_start_timer7:
	DECFSZ     R13+0, 1
	GOTO       L_start_timer7
	DECFSZ     R12+0, 1
	GOTO       L_start_timer7
	DECFSZ     R11+0, 1
	GOTO       L_start_timer7
	NOP
	NOP
;Digital Count DownTimer.c,65 :: 		j++;
	INCF       _j+0, 1
;Digital Count DownTimer.c,66 :: 		} while(((j<=60) && (Clear ==0)));
	MOVF       _j+0, 0
	SUBLW      60
	BTFSS      STATUS+0, 0
	GOTO       L__start_timer23
	MOVF       _clear+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__start_timer23
	GOTO       L_start_timer4
L__start_timer23:
;Digital Count DownTimer.c,67 :: 		if (Clear) {
	MOVF       _clear+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_start_timer10
;Digital Count DownTimer.c,68 :: 		Relay = 1;
	BSF        RA3_bit+0, BitPos(RA3_bit+0)
;Digital Count DownTimer.c,69 :: 		Delay_ms(2000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_start_timer11:
	DECFSZ     R13+0, 1
	GOTO       L_start_timer11
	DECFSZ     R12+0, 1
	GOTO       L_start_timer11
	DECFSZ     R11+0, 1
	GOTO       L_start_timer11
	NOP
	NOP
;Digital Count DownTimer.c,70 :: 		Lcd_Out(1,1,Message2);               //Relay ON
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _Message2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Digital Count DownTimer.c,71 :: 		INTCON = 0x00;
	CLRF       INTCON+0
;Digital Count DownTimer.c,72 :: 		goto stop;
	GOTO       ___start_timer_stop
;Digital Count DownTimer.c,73 :: 		}
L_start_timer10:
;Digital Count DownTimer.c,57 :: 		for (i=0; i<MinVal; i++){
	INCF       _i+0, 1
;Digital Count DownTimer.c,74 :: 		}
	GOTO       L_start_timer1
L_start_timer2:
;Digital Count DownTimer.c,75 :: 		stop:
___start_timer_stop:
;Digital Count DownTimer.c,76 :: 		Relay = 0;
	BCF        RA3_bit+0, BitPos(RA3_bit+0)
;Digital Count DownTimer.c,77 :: 		ON_OFF = 0;
	CLRF       _ON_OFF+0
;Digital Count DownTimer.c,78 :: 		unit = 0;
	CLRF       _unit+0
;Digital Count DownTimer.c,79 :: 		ten = 0;
	CLRF       _ten+0
;Digital Count DownTimer.c,80 :: 		clear = 1;
	MOVLW      1
	MOVWF      _clear+0
;Digital Count DownTimer.c,81 :: 		}
L_end_start_timer:
	RETURN
; end of _start_timer

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Digital Count DownTimer.c,83 :: 		void interrupt(void){
;Digital Count DownTimer.c,84 :: 		if (INTCON.INTF == 1)   // Check if INTF flag is set
	BTFSS      INTCON+0, 1
	GOTO       L_interrupt12
;Digital Count DownTimer.c,86 :: 		Clear = 1;
	MOVLW      1
	MOVWF      _clear+0
;Digital Count DownTimer.c,87 :: 		INTCON.INTF = 0;       // Clear interrupt flag before exiting ISR
	BCF        INTCON+0, 1
;Digital Count DownTimer.c,88 :: 		}
L_interrupt12:
;Digital Count DownTimer.c,89 :: 		}
L_end_interrupt:
L__interrupt28:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;Digital Count DownTimer.c,91 :: 		void main() {
;Digital Count DownTimer.c,92 :: 		CMCON  |= 7;                       // Disable Comparators
	MOVLW      7
	IORWF      CMCON+0, 1
;Digital Count DownTimer.c,93 :: 		TRISB = 0b00001111;
	MOVLW      15
	MOVWF      TRISB+0
;Digital Count DownTimer.c,94 :: 		TRISA = 0b11110000;
	MOVLW      240
	MOVWF      TRISA+0
;Digital Count DownTimer.c,95 :: 		Relay = 0;
	BCF        RA3_bit+0, BitPos(RA3_bit+0)
;Digital Count DownTimer.c,97 :: 		Lcd_Init();                        // Initialize LCD
	CALL       _Lcd_Init+0
;Digital Count DownTimer.c,98 :: 		start:
___main_start:
;Digital Count DownTimer.c,99 :: 		clear = 0;
	CLRF       _clear+0
;Digital Count DownTimer.c,100 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Digital Count DownTimer.c,101 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Digital Count DownTimer.c,102 :: 		Lcd_Out(1,1,Message1);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _Message1+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Digital Count DownTimer.c,103 :: 		Lcd_Out(2,1,Message4);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _Message4+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Digital Count DownTimer.c,104 :: 		Display_Digits()  ;
	CALL       _Display_Digits+0
;Digital Count DownTimer.c,105 :: 		do {
L_main13:
;Digital Count DownTimer.c,107 :: 		if(!Unit_Button){
	BTFSC      RB1_bit+0, BitPos(RB1_bit+0)
	GOTO       L_main16
;Digital Count DownTimer.c,108 :: 		Delay_300();
	CALL       _Delay_300+0
;Digital Count DownTimer.c,109 :: 		unit ++;
	INCF       _unit+0, 1
;Digital Count DownTimer.c,110 :: 		if(unit==10) unit=0;
	MOVF       _unit+0, 0
	XORLW      10
	BTFSS      STATUS+0, 2
	GOTO       L_main17
	CLRF       _unit+0
L_main17:
;Digital Count DownTimer.c,111 :: 		Display_Digits();
	CALL       _Display_Digits+0
;Digital Count DownTimer.c,112 :: 		} // If !Unit_Button
L_main16:
;Digital Count DownTimer.c,114 :: 		if(!Ten_Button){
	BTFSC      RB2_bit+0, BitPos(RB2_bit+0)
	GOTO       L_main18
;Digital Count DownTimer.c,115 :: 		Delay_300();
	CALL       _Delay_300+0
;Digital Count DownTimer.c,116 :: 		ten ++;
	INCF       _ten+0, 1
;Digital Count DownTimer.c,117 :: 		if(ten==10) ten=0;
	MOVF       _ten+0, 0
	XORLW      10
	BTFSS      STATUS+0, 2
	GOTO       L_main19
	CLRF       _ten+0
L_main19:
;Digital Count DownTimer.c,118 :: 		Display_Digits();
	CALL       _Display_Digits+0
;Digital Count DownTimer.c,119 :: 		} // If !Ten_Button
L_main18:
;Digital Count DownTimer.c,121 :: 		if(!SS_Select){
	BTFSC      RB0_bit+0, BitPos(RB0_bit+0)
	GOTO       L_main20
;Digital Count DownTimer.c,122 :: 		Delay_300();
	CALL       _Delay_300+0
;Digital Count DownTimer.c,123 :: 		time = ten*10+unit ;
	MOVF       _ten+0, 0
	MOVWF      R0+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVF       _unit+0, 0
	ADDWF      R0+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      _time+0
;Digital Count DownTimer.c,124 :: 		if(time > 0) start_timer(time);
	MOVF       R1+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_main21
	MOVF       _time+0, 0
	MOVWF      FARG_start_timer_MinVal+0
	CALL       _start_timer+0
L_main21:
;Digital Count DownTimer.c,125 :: 		} // If !SS_Select
L_main20:
;Digital Count DownTimer.c,127 :: 		if(clear){
	MOVF       _clear+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main22
;Digital Count DownTimer.c,128 :: 		goto start;
	GOTO       ___main_start
;Digital Count DownTimer.c,129 :: 		}
L_main22:
;Digital Count DownTimer.c,130 :: 		} while(1);
	GOTO       L_main13
;Digital Count DownTimer.c,131 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
