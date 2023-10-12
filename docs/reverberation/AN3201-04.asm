; File:         AN3201-04.asm
; Description:  Example reverb program
; Authors:      Frank Thomson
; Copyright 2001 Alesis Semiconductor
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
MEM     earlyr		3321                    ; Early reflections right channel
MEM	comb1			2200
MEM	comb1a		   1
MEM	comb2			2928
MEM	comb2a		   1
MEM	comb3			2956
MEM	comb3a		   1
MEM	comb4			3744
MEM	comb4a		   1
MEM	allpassr		1201
MEM     temp               1                  ; Temp register
MEM     temp2              1                  ; Temp register
MEM     earlyl		3321                  ; Early reflections right channel
MEM	comb1l		2200
MEM	comb1la		   1
MEM	comb2l		2928
MEM	comb2la		   1
MEM	comb3l		2956
MEM	comb3la		   1
MEM	comb4l		3744
MEM	comb4la		   1
MEM	allpassl		1201
;
;NOTE: memory locations are referenced by:
;	name	Start of memory block
;	name'	End of memory block
;	name"	Middle of memory block
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;Read ADC in and write to the early reflection memory
RZP	ADCR		K=0.2
RAP	ADCL		K=.05
WAP	earlyr	K=.5
RAP	earlyr+955	K=.45    
RAP	earlyr+1055	K=.06
RAP	earlyr+1699	K=.4
RAP	earlyr+1867	K=.3
RAP	earlyr+1987	K=.3
RAP	earlyr+3055	K=.13
RAP	earlyr'	K=.12
;
; Early reflection plus dry in accumulator
;
; Comb filters
;
; Comb filter 1
WAP	temp 		K=0 	;Save accumulator
RAP 	comb1a'	k=.45	;tail * k + acc
RAP 	comb1'	k=.99
WAP 	comb1a	k=0
WZP 	temp2		k=.45
RAP 	temp		k=.99
WAP 	comb1		k=0	;write to head
; Comb filter 2
RZP 	temp		K=.99
RAP 	comb2a'	k=.49	;tail * k + acc
RAP 	comb2'	k=.99
WAP 	comb2a	k=0
WZP 	temp2		k=.42
RAP 	temp		k=.99
WAP 	comb2		k=0	;write to head
; Comb filter 3
RZP temp		K=.99
RAP 	comb3a'	k=.52	;tail * k + acc
RAP 	comb3'	k=.99
WAP 	comb3a	k=0
WZP 	temp2		k=.39
RAP 	temp		k=.99
WAP 	comb3		k=0	;write to head
; Comb filter 4
RZP 	temp		K=.99
RAP 	comb4a'	k=.54	;tail * k + acc
RAP 	comb4'	k=.99
WAP 	comb4a	k=0
WZP 	temp2		k=.38
RAP 	temp		k=.99
WAP 	comb4		k=0	;write to head
;
;Sum outputs of comb filters
;
RZP 	comb1'	k=.2
RAP 	comb2'	k=.2
RAP 	comb3'	k=.2
RAP 	comb4'	k=.2
;
; All-pass
;
WAP	temp2		k=0
RAP	allpassr'	k=.7
WZP	allpassr	k=0
RZP	temp2		k=-.7
RAP	allpassr'	k=.51
;
; Add in early reflections
;
RAP 	temp 		k=0.999
;
; Write to the output
;
WAP 	OUTR 		K=0                        ;9   Write it to the DAC
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;Read ADC in and write to the early reflection memory
RZP	ADCL		K=0.2
RAP	ADCR		K=.05
WAP	earlyl	K=.5
RAP	earlyl+955	K=.45    
RAP	earlyl+955	K=.06
RAP	earlyl+1699	K=.4
RAP	earlyl+1867	K=.3
RAP	earlyl+1987	K=.3
RAP	earlyl+3055	K=.13
RAP	earlyl'	K=.12
;
; Early reflection plus dry in accumulator
;
; Comb filters
;
; Comb filters
;
; Comb filter 1
WAP 	temp 		K=0 	;Save accumulater
RAP 	comb1la' 	k=.45	;tail * k + acc
RAP 	comb1l'	k=.99
WAP 	comb1la	k=0
WZP 	temp2		k=.45
RAP 	temp		k=.99
WAP 	comb1l	k=0	;write to head
; Comb filter 2
RZP 	temp		K=.99
RAP 	comb2la'	k=.49	;tail * k + acc
RAP 	comb2l'	k=.99
WAP 	comb2la	k=0
WZP 	temp2		k=.42
RAP 	temp		k=.99
WAP 	comb2l		k=0	;write to head
; Comb filter 3
RZP 	temp		K=.99
RAP 	comb3la'	k=.52	;tail * k + acc
RAP 	comb3l'	k=.99
WAP 	comb3la	k=0
WZP 	temp2		k=.39
RAP 	temp		k=.99
WAP 	comb3l	k=0	;write to head
; Comb filter 4
RZP 	temp		K=.99
RAP 	comb4la'	k=.54	;tail * k + acc
RAP 	comb4l'	k=.99
WAP 	comb4la	k=0
WZP 	temp2		k=.38
RAP 	temp		k=.99
WAP 	comb4l	k=0	;write to head
;
;Sum outputs of comb filters
;
RZP 	comb1l'	k=.2
RAP 	comb2l'	k=.2
RAP 	comb3l'	k=.2
RAP 	comb4l'	k=.2
;
; All-pass
;
WAP	temp2		k=0
RAP	allpassl'	k=.7
WZP	allpassl	k=0
RZP	temp2		k=-.7
RAP	allpassl'	k=.51
;
; Add in early reflections
;
RAP 	temp 		k=0.999
;
; Write to the output
;
WAP 	OUTL 		K=0                     ;9   Write it to the DAC
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Add a bunch of reads for refresh
RZP    0x00              K=0
RZP    0x40              K=0
RZP    0x80              K=0
RZP    0xc0              K=0
RZP    0x100             K=0
RZP    0x140             K=0
RZP    0x180             K=0
RZP    0x1c0             K=0
RZP    0x200             K=0
RZP    0x240             K=0
RZP    0x280             K=0
RZP    0x2c0             K=0
RZP    0x300             K=0
RZP    0x340             K=0
RZP    0x380             K=0
RZP    0x3c0             K=0
