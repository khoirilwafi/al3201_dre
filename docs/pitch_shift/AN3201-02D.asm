; File: AN3201-02D.asm
; Description: Example pitch down program
; Authors: Frank Thomson
; Copyright 2001 Alesis Semiconductor
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 1 octave down
LFO0 SAW AMP=32767 FREQ=64 XFAD=1/16
;NOTE: Here we define the waveform:
; SIN, TRI (triangle), SAW (sawtooth for pitch shift)
;
;
MEM pitchmem 8200 ; Circular buffer memory
MEM temp 1 ; Temp register
MEM temp2 1 ; Temp register
;NOTE: memory locations are referenced by:
; name Start of memory block
; name' End of memory block
; name" Middle of memory block
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
RZP ADCL K=.999 ;0 Read left channel into Accumulator
;
WZP pitchmem K=.999 ;1 Write to the start of the block
; Next read from the middle of the delay memory block using the chorus instruction to add the
; sawtooth waveform to the address. The sample returned is multiplied by the 1's comp of the
; coefficient from the chorus generator block. Use the SIN output for the first sawtooth.
;
CHR0 RZP pitchmem" +SIN COMPK LATCH ;2 Read middle of memory block
;
; Read the sample before the above one and multiply it by the coefficient.
;
CHR0 RAP pitchmem"+1 +SIN ;3 Read middle -1 from memory block
;
; Save the result to a temp register.
;
WAP temp K=0 ;4 Write to DAC
;
; Now do it again using the COS output to get the other sawtooth
;
CHR0 RZP pitchmem" +COS COMPK LATCH ;5
CHR0 RAP pitchmem"+1 +COS ;6
;
; The result from the 2 instructions is in the accumulator, do a write to a temp location to bring it
; back throught the multiplier and use the 1's comp of the cross fade coefficient to multiply it
; by.
;
CHR0 WZP temp2 +COS COMPK MASKA ;7
;
; Get the first result, multiply it by the cross fade coefficient and add it.
;
CHR0 RAP temp MASKA ;8
;
WAP OUTL K=0 ;9 Write it to the DAC
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
RZP ADCL K=.999 ;10 Read left channel into Accumulator
WAP OUTR K=0 ;11 Write to DAC
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Add a bunch of reads for refresh
RZP 0x00 K=0
RZP 0x40 K=0
RZP 0x80 K=0
RZP 0xc0 K=0
RZP 0x100 K=0
RZP 0x140 K=0
RZP 0x180 K=0
RZP 0x1c0 K=0
RZP 0x200 K=0
RZP 0x240 K=0
RZP 0x280 K=0
RZP 0x2c0 K=0
RZP 0x300 K=0
RZP 0x340 K=0
RZP 0x380 K=0
RZP 0x3c0 K=0
