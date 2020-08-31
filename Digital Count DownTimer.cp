#line 1 "C:/Users/Pitias/Desktop/PROJECTS/Digital Count Down Timer/Digital Count DownTimer.c"
#line 8 "C:/Users/Pitias/Desktop/PROJECTS/Digital Count Down Timer/Digital Count DownTimer.c"
sbit LCD_RS at RA0_bit;
sbit LCD_EN at RA1_bit;
sbit LCD_D4 at RB4_bit;
sbit LCD_D5 at RB5_bit;
sbit LCD_D6 at RB6_bit;
sbit LCD_D7 at RB7_bit;
sbit LCD_RS_Direction at TRISA0_bit;
sbit LCD_EN_Direction at TRISA1_bit;
sbit LCD_D4_Direction at TRISB4_bit;
sbit LCD_D5_Direction at TRISB5_bit;
sbit LCD_D6_Direction at TRISB6_bit;
sbit LCD_D7_Direction at TRISB7_bit;



sbit Relay at RA3_bit;
sbit SS_Select at RB0_bit;
sbit Unit_Button at RB1_bit;
sbit Ten_Button at RB2_bit;



char Message1[]="00-99 min Timer";
char Message2[]="RELAY ON";
char Message3[]="RELAY OFF";
char Message4[]="Set Time:    min";
char Message5[]="Time Left:   min";
unsigned short i, j, unit=0, ten=0, ON_OFF=0, index=0, clear, time;
char *digit = "00";

void Delay_300(){
 Delay_ms(300);
}

void Display_Digits(){
 digit[1]=unit+48;
 digit[0]=ten+48;
 Lcd_Out(2,11,digit);
}

void start_timer(unsigned short MinVal){
 unsigned short temp1, temp2;
 Relay = 0;
 ON_OFF = 1;
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,Message3);
 Lcd_Out(2,1,Message5);
 OPTION_REG = 0x80 ;
 INTCON = 0x90;
 for (i=0; i<MinVal; i++){
 temp1 = (MinVal-i)%10 ;
 temp2 = (MinVal-i)/10 ;
 Lcd_Chr(2, 12, temp2+48);
 Lcd_Chr(2, 13, temp1+48);
 j=1;
 do {
 Delay_ms(1000);
 j++;
 } while(((j<=60) && (Clear ==0)));
 if (Clear) {
 Relay = 1;
 Delay_ms(2000);
 Lcd_Out(1,1,Message2);
 INTCON = 0x00;
 goto stop;
 }
 }
 stop:
 Relay = 0;
 ON_OFF = 0;
 unit = 0;
 ten = 0;
 clear = 1;
}

void interrupt(void){
 if (INTCON.INTF == 1)
 {
 Clear = 1;
 INTCON.INTF = 0;
 }
 }

void main() {
 CMCON |= 7;
 TRISB = 0b00001111;
 TRISA = 0b11110000;
 Relay = 0;

 Lcd_Init();
 start:
 clear = 0;
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,1,Message1);
 Lcd_Out(2,1,Message4);
 Display_Digits() ;
 do {

 if(!Unit_Button){
 Delay_300();
 unit ++;
 if(unit==10) unit=0;
 Display_Digits();
 }

 if(!Ten_Button){
 Delay_300();
 ten ++;
 if(ten==10) ten=0;
 Display_Digits();
 }

 if(!SS_Select){
 Delay_300();
 time = ten*10+unit ;
 if(time > 0) start_timer(time);
 }

 if(clear){
 goto start;
 }
 } while(1);
}
