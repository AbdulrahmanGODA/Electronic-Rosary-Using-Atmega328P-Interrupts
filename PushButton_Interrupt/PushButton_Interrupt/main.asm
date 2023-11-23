.Include "M328Pdef.inc"
			.Cseg
			.Org 0x0000 		;Location for reset  
			Jmp Main  

			.ORG 0x0002 		;Location for external interrupt 0  
			Jmp externalISR0  

Main:		Ldi R30,HIGH(RAMEND)  
			Out SPH,R30  
			Ldi R30,LOW(RAMEND)  
			Out SPL,R30 		;Set up the stack  

			Ldi R30,0x02 		;Make INT0 falling edge triggered  
			Sts EICRA,R30		;External Interrupt Control Register A

			Ldi R30,0x01		;Enable INT0 - 0b00000001
			Out EIMSK,R30		;External Interrupt MaSK
			Sei 				;Enable global interrupt  

			Sbi PORTD,2 		;Activated pull-up  

			Ldi R31,0xFF
			Out DDRB,R31 		;Set PortB DDR to output mode
			Out DDRC,R31 		;Set PortC DDR to output mode


SetupRegisters:
			Ldi R16,0b00000000
			Ldi R17,0b00000000

Repeat:		out PORTB,R16
			out PORTC,R17
			Jmp Repeat

externalISR0:
			Inc R16
			cpi R16,10
				BRNE Output
			cpi R17,9
				BREQ Main
			inc R17
			ldi R16,0x00
			Output:
			out PORTB,R16
			out PORTC,R17
			reti