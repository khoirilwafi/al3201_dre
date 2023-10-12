About V1000

- overview -

> 20-48 khz sampling
> DSP programs can be dynamically executed by rewriting the SRAM area called WCS (Writeable Control Store).
> Equipped with 32kByte SRAM, it can achieve a delay of 0.68 seconds or more for 48kHz samples.
> Equipped with 4 LFOs
> One instruction is 4 bytes and has instruction RAM for a total of 128 instructions.
> Of the 128 instructions, 4 are LFO settings and the remaining 124 are DSP instructions.


- important point -

> It seems to be basically the same as AL3201, but the difference is that it does not have an internal 3.3V regulator. so Be careful when replacing from AL3201
> It seems that the IF side is 5V tolerant on the data sheet, but caution is required because VDD is 3.3V.
> It seems that the assembler and loader were provided by wavefront (Alesis), but they are now gone.
> For read access, leave a space between A0 and D31. The period is 5 system clocks (probably 12.288MHz) or 1WordClock (probably communication clock).
> Note that the serial IF clock is driven at both edges.
> Attn needs to be entered asynchronously to the clock.
> Communication is performed in 4-byte units. Burst transfer is possible in 4-byte units for writes