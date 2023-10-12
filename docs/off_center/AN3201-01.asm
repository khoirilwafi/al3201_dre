;Application Note AN3201-01: Off-center 45 rpm record
;		By Chris Maple

LFO0 SIN AMP=17219 FREQ=26	;LEFT, 45.46 RPM
LFO1 SIN AMP=17213 FREQ=26	;RIGHT

MEM BUFL 17		;left channel input-FIR buffer
MEM SWMEML 4400		;left channel sweep memory
MEM BUFR 17
MEM SWMEMR 4400

RZP ADCL K=127		;read left channel input
WZP BUFL K=1		;write input to FIR buffer, first FIR coefficient
RAP BUFL+1 K=-2		;second FIR stage
RAP BUFL+2 K=2
RAP BUFL+3 K=-1
RAP BUFL+4 K=-3
RAP BUFL+5 K=10
RAP BUFL+6 K=-18
RAP BUFL+7 K=25
RAP BUFL+8 K=100
RAP BUFL+9 K=25
RAP BUFL+10 K=-18
RAP BUFL+11 K=10
RAP BUFL+12 K=-3
RAP BUFL+13 K=-1
RAP BUFL+14 K=2
RAP BUFL+15 K=-2
RAP BUFL+16 K=1
WZP SWMEML K=0		;save FIR output to beginning of sweep memory
CHR0 RZP SWMEML" +SIN LATCH COMPK	;get data at swept memory address, scale
CHR0 RAP SWMEML"+1 +SIN			;add (1-scale)x(data) at next address
WAP OUTL K=0		;write result to left output

RZP ADCR K=127		;read right channel input
WZP BUFR K=1		;write input to FIR buffer, first FIR coefficient
RAP BUFR+1 K=-2		;second FIR stage
RAP BUFR+2 K=2
RAP BUFR+3 K=-1
RAP BUFR+4 K=-3
RAP BUFR+5 K=10
RAP BUFR+6 K=-18
RAP BUFR+7 K=25
RAP BUFR+8 K=100
RAP BUFR+9 K=25
RAP BUFR+10 K=-18
RAP BUFR+11 K=10
RAP BUFR+12 K=-3
RAP BUFR+13 K=-1
RAP BUFR+14 K=2
RAP BUFR+15 K=-2
RAP BUFR+16 K=1
WZP SWMEMR K=0		;save FIR output to beginning of sweep memory
CHR1 RZP SWMEMR" LATCH +SIN COMPK	;get data at swept memory address, scale
CHR1 RAP SWMEMR"+1 +SIN			;add (1-scale)x(data) at next address
WAP OUTR K=0		;write result to right output

RZP BUFR+0x40 K=0	;refresh
RZP BUFR+0x80 K=0	;refresh
RZP BUFR+0xC0 K=0	;refresh
RZP BUFR+0x100 K=0	;refresh
RZP BUFR+0x140 K=0	;refresh
RZP BUFR+0x180 K=0	;refresh
RZP BUFR+0x1C0 K=0	;refresh
RZP BUFR+0x200 K=0	;refresh
RZP BUFR+0x240 K=0	;refresh
RZP BUFR+0x280 K=0	;refresh
RZP BUFR+0x2C0 K=0	;refresh
RZP BUFR+0x300 K=0	;refresh
RZP BUFR+0x340 K=0	;refresh
RZP BUFR+0x380 K=0	;refresh
RZP BUFR+0x3C0 K=0	;last refresh, END OF PROGRAM