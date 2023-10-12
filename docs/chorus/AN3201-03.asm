;
; File:         AN320103.ASM
; Description:  Wide Stereo Chorus Example
; Authors:      Jeff Rothermel
; Copyright 2001 Alesis Semiconductor
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
LFO0	SIN	AMP=10000	FREQ=2	; f = FREQ * 0.029Hz for Fs=48kHz
LFO1	SIN	AMP=10000	FREQ=3
;
MEM	chorusmeml	8192		; 8192 big enough for full AMP LFO
MEM	chorusmemr	8192		; right chorus memory
;
;NOTE: memory locations are referenced by:
;	name	Start of memory block
;	name'	End of memory block
;	name"	Middle of memory block
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
RZP	 ADCL		K=.5		; Read left/2 into accumulator
WZP	 chorusmeml			; Write acc to start left chorus mem
RZPB	 chorusmeml+400 		; Read delayed left to B reg
;
CHR0 RZP chorusmeml"	COMPK LATCH	; Read middle of chorus memory
CHR0 RAP chorusmeml"+1			; Read middle+1 chorus memory
;
WBP	 OUTL		K=.999		; Write dry (B) + chorus (acc) to OUTL
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
RZP	 ADCR		K=.5		; Read right/2 into accumulator
WZP	 chorusmemr			; Write acc to start right chorus mem
RZPB	 chorusmemr+400 		; Read delayed right to B reg
;
CHR1 RZP chorusmemr"	COMPK LATCH	; Read middle of chorus memory
CHR1 RAP chorusmemr"+1			; Read middle+1 chorus memory
;
WBP	 OUTR		K=.999		; Write dry (B) + chorus (acc) to OUTR
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Add 16 extra reads for refresh
RZP	0x00
RZP	0x40
RZP	0x80
RZP	0xc0
RZP	0x100
RZP	0x140
RZP	0x180
RZP	0x1c0
RZP	0x200
RZP	0x240
RZP	0x280
RZP	0x2c0
RZP	0x300
RZP	0x340
RZP	0x380
RZP	0x3c0

