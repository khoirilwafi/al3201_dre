; File: AN3201-05.asm
; Auditorium reverb

MEM FILR 2	;lopass IIR filter (-6dB 10 kHz) from right performer
MEM FILL 2	;from left performer

MEM R1B 2173	;single reflection buffer from right performer
MEM L1B 2173	;single reflection buffer from left performer

MEM RF1 1	;right front
MEM LF1 1	;left front

MEM L40 1	;left wall reflections to left ear at 40 degrees from front
MEM R40 1	;right wall reflections to right ear at 40 degrees

MEM RL1 1	;right performer reflections off left wall
MEM LR1 1	;left performer reflections off right wall

MEM LRBUF 20	;sound going from left ear to right ear
MEM RLBUF 20
MEM LEFIL 2	;IIR filter for previous
MEM REFIL 2

MEM RFIL10 2	;IIR shelving filter, -6dB above 1500 Hz; 10 degree path
MEM LFIL10 2

MEM LWFIL 2	;1st refl 630 Hz backstage-to-left filter for right performer
MEM RWFIL 2	;1st refl 630 Hz backstage-to-right filter for left performer

MEM MFIL 2	;summed signals 2nd reflection mono filter

MEM RCFIL 2	;rear-stage-wall-curtain filter, right performer, 630 Hz
MEM LCFIL 2	;rear-stage-wall-curtain filter, left performer, 630 Hz

MEM LTEMP 1
MEM RTEMP 1
MEM TEMP 1
MEM M1B 5533	;monaural reflection buffer
MEM VERBLR 2556	;side-to-side reverberation buffer
MEM VERBFB 12522	;back to front reverberation buffer
MEM REFRESH 1024	;code uses some dummy writes, does refresh at same time

;---------------------
RZP ADCR	K=.023	;right performer source times .023
RAP FILR+1	K=.5	;1 reflection filter, LF amplitude = .046 x input
WAP FILR	K=0	;blur for surface roughness, -6dB point is 10.3 kHz
WZP R1B		K=0	;start of right reflection buffer
RZP R1B+1190	K=.047	;630 Hz filter for backstage reflection through curtain
RAP RCFIL+1	K=.953	;filter's feedback term distance is +27.74'
WZP RCFIL	K=.577	;save filter output, scale for distance & relectivity
RAP R1B+52	K=-.04	;diffraction/impedance mismatch at stage edge, +1.21'
RAP R1B+213	K=.08	;reflection off clutter at right performer's feet, +5.0'
RAP ADCR	K=.055	;direct
WZP RF1		K=0	;save direct + single reflections from front (10 degree)
RZP L1B+2172	K=.047	;left performer, stage rear wall and right wall, +50.99'
RAP RWFIL+1	K=.953	;This filter is modeling the stage rear wall
WZP RWFIL	K=.373	;Save the filter output, scale for distance & reflectivity
RAP R1B+822	K=.61	;reflection off right wall, +19.3'
WZP R40		K=0	;save reflections off right wall entering right ear at 40 deg
RZP L1B+1310	K=.53	;left performer reflection off right wall, +30.76'
WZP RLBUF	K=0	;start the right ear to left ear buffer

;------ repeat the above, swapping left and right
RZP ADCL	K=.023
RAP FILL+1	K=.5
WAP FILL	K=0
WZP L1B		K=0
RZP L1B+1190	K=.047
RAP LCFIL+1	K=.953
WZP LCFIL	K=.577
RZP L1B+52	K=-.04
RAP L1B+213	K=.08
RAP ADCL	K=.055
WZP LF1		K=0
RZP R1B+2172	K=.047
RAP LWFIL+1	K=.953
WZP LWFIL	K=.373
RAP L1B+822	K=.61
WZP L40		K=0
RZP R1B+1310	K=.53
WZP LRBUF	K=0

;-------- process the rest of the right ear to left ear buffer
RZP R40		K=.27	;40 degree path
RAPC RLBUF+3	K=.27	;+50 degree path, save result in C
WZP REFRESH	K=.157	;scale product to .042=.27*.157, dummy write does refresh
RAP RLBUF+4	K=.96	;filter feedback term (LP shelf 1500 Hz, HF -12dB)
WCP RLBUF+3	K=.73	;save new feedback term; create filter output
WZP RLBUF+4	K=0	;save output at +0.08ms
RZPC RF1	K=.54	;10 degree path from right performer
WZP REFRESH+0x40 K=.078	;save .54 product as refresh, make new .042 product
RAP RFIL10+1	K=.96	;filter feedback term
WCP RFIL10	K=.46	;save new feedback term and create filter output
RAP RLBUF+16	K=.999	;add filtered 10 degree path at +0.32ms
WZP RLBUF+16	K=0	;save back into head delay line

;-------- left ear to right ear buffer
RZP L40		K=.27
RAPC LRBUF+3	K=.27
WZP REFRESH+0x80 K=.157
RAP LRBUF+4	K=.96
WCP LRBUF+3	K=.73
WZP LRBUF+4	K=0
RZPC LF1	K=.54
WZP REFRESH+0xC0 K=.078
RAP LFIL10+1	K=.96
WCP LFIL10	K=.46
RAP LRBUF+16	K=.999
WZP LRBUF+16	K=0

;------- All other reflections are considered to be neither from the left nor from the
;------- right, and are treated as monaural. The mono reflections start at 88.98', or
;------- 30.22' more than the direct path. Sum of left and right, times .7; later
;------- coefficients are x1.43
RZP R1B+710	K=.7	;right channel +30.22' mark
RAP L1B+710	K=.7	;left channel
WZP M1B		K=.755	;start the mono buffer and scale the ceiling reflection
RAPC M1B+5078	K=.258	;208.21', 119.23' into mono delay, off auditorium back wall

;The remaining reflections are double reflections and need to be blurred.
RZP M1B+330	K=.272	;7.75' into mono delay, stage floor and auditorium ceiling
RAP M1B+5344	K=.07	;+125.48' delay, same side wall as performer & aud. back wall
RAP M1B+5532	K=.07	;+129.91' delay, opposite side wall & auditorium back wall
RAP MFIL+1	K=.7	;4.8kHz filter feedback term
WCPC MFIL	K=.999	;save previous result in filter, add C, put sum in C

;--------
; sum all right ear audio except reverberant field
RCP RF1		K=.999	;right performer front reflections and direct
RAP R40		K=.999	;40 degree inputs
RAP RLBUF	K=.999	;50 degree input
RAP LRBUF'	K=.999	;right ear audio delayed relative to left ear
WZP RTEMP	K=0	;Save sum.
; sum all left ear audio except reverberant field
RCP LF1		K=.999
RAP L40		K=.999
RAP LRBUF	K=.999
RAP RLBUF'	K=.999	;sum of left-ear non-reverberant audio
WZP LTEMP	K=.999

;--------
; Do the auditorium reverberant modes. Since the listener is assumed to be exactly
; centered in the 60' width, the width may be considered as 30' with one perfectly
; reflecting wall. The length of the auditorium is considered to be evenly split between
; a section 128' long from the front to the back, and another section 147' long from the
; back of the auditorium to the rear of the stage. The floor-to-ceiling reverberant mode
; is assumed not to exist, as the seats and audience would absorb all reflections
; directed at the floor.
;------------ side-to-side reverberation
RAP RTEMP	K=.999	;add left and right temps as source for reverberant fields
WZP TEMP	K=.246	;save, start lopass with gain = .82, F6db = 4.8k
RAP VERBLR'	K=.246	;other input to lopass is end of 60' delay
RAP VERBLR+1	K=.7	;this is the filter's feedback term
WZP VERBLR	K=0	;save the filter output at the side reverb input
;------------ front-to-back reverberation
RZP VERBFB'	K=.2	;One input for the backward-travelling delay is buffer end.
RAP TEMP	K=.2	;The other is TEMP. Same filter type as previous, this is for
RAP VERBFB+1	K=.7	;the reflection from the back of the auditorium.
WZP VERBFB	K=0	;Save the filtered audio as the beginning of the delay buffer
RZP VERBFB+10903 K=.2	;Sound has passed listener going forward. This 3.0kHz
RAP VERBFB+10904 K=.8	;filter serves as the input to reflections off both the
WZPC VERBFB+10903 K=.45	;auditorium front wall (K=.45) and the backstage wall.
RZP VERBFB'-2	K=.047	;backstage wall with curtain needs 630 Hz filter
RAP VERBFB'-1	K=.953
WCP REFRESH+0x100 K=.42	;scale filter out, + front wall refl in C. Write is dummy
WAP VERBFB'-2	K=0	;Save the split delay sum, the backward-travelling wave.
RAP VERBFB+6389 K=.999	;Add the forward-travelling wave as it passes the listener.
RAPC VERBLR'	K=.999	;Add the side-to-side reverberation, save total reverb in C.
RCP RTEMP	K=.999	;Add reverb to non-reverberant right
WAP OUTR	K=0	;Total right ear output
RCP LTEMP	K=.999
WAP OUTL	K=0	;Total left ear output

;------------ refresh
RZP REFRESH+0x140
RZP REFRESH+0x180
RZP REFRESH+0x1C0
RZP REFRESH+0x200
RZP REFRESH+0x240
RZP REFRESH+0x280
RZP REFRESH+0x2C0
RZP REFRESH+0x300
RZP REFRESH+0x340
RZP REFRESH+0x380
RZP REFRESH+0x3C0
