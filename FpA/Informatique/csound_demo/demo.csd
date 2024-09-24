<CsoundSynthesizer>
<CsOptions>
-odac
-o output.wav
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1

instr 1
    ; Parameters
    iFreq = 8000     ; High frequency for the hi-hat sound
    iDecay = p4      ; Decay time (in seconds)
    iAmp = p5        ; Amplitude

    ; White noise generator
    aNoise rand iAmp

    ; High-pass filter to remove low frequencies
    aHiHat buthp aNoise, iFreq

    ; Envelope with fast attack and specified decay
    aEnv linsegr 0, 0.001, 1, iDecay, 0

    ; Apply the envelope to the hi-hat noise
    aSig = aHiHat * aEnv

    ; Output the sound to stereo
    outs aSig, aSig
endin

instr 2
    ; Parameters
    iNote = p4        ; MIDI note number
    iAmp = p5         ; Amplitude
    iDur = p3         ; Duration

    ; Convert MIDI note to frequency
    iFreq = cpsmidinn(iNote)

    ; Generate the piano sound using a sine wave oscillator with harmonic overtones
    ; Main tone
    aSig1 poscil iAmp, iFreq, 1
    ; First harmonic (octave higher)
    aSig2 poscil 0.5 * iAmp, iFreq * 2, 1
    ; Second harmonic (perfect fifth above first harmonic)
    aSig3 poscil 0.25 * iAmp, iFreq * 3, 1

    ; Sum the harmonics together
    aSig = aSig1 + aSig2 + aSig3

    ; Envelope for smooth attack and release
    aEnv linsegr 0, 0.01, 1, iDur - 0.01, 1, 0.05, 0

    ; Apply envelope to the signal
    aOut = aSig * aEnv

    ; Output to stereo
    outs aOut, aOut
endin

</CsInstruments>
<CsScore>
; Define tempo beats per minute
t 0 100
; Define a sine wave for the oscillator (table 1)
f 1 0 16384 10 1

; instr 1
i 1 0      0.1 0.05 0.2
i 1 0.25   0.1 0.05 0.2
i 1 0.75   0.1 0.05 0.2
i 1 1.5    0.1 0.05 0.2
i 1 1.75   0.1 0.05 0.2
i 1 2.25   0.1 0.05 0.2
i 1 2.75   0.1 0.05 0.2
i 1 3.0    0.1 0.05 0.2
i 1 3.5    0.1 0.05 0.2
i 1 4.0    0.1 0.05 0.2
i 1 4.5    0.1 0.05 0.2
i 1 5.0    0.1 0.05 0.2
i 1 5.5    0.1 0.05 0.2
i 1 5.75   0.1 0.05 0.2
i 1 6.0    0.1 0.05 0.2
i 1 6.5    0.1 0.05 0.2
i 1 6.75   0.1 0.05 0.2
i 1 7.0    0.1 0.05 0.2
; repeat once from 7.75s
i 1 7.75   0.1 0.05 0.2
i 1 8.0    0.1 0.05 0.2
i 1 8.5    0.1 0.05 0.2
i 1 9.25   0.1 0.05 0.2
i 1 9.5    0.1 0.05 0.2
i 1 10.0   0.1 0.05 0.2
i 1 10.5   0.1 0.05 0.2
i 1 10.75  0.1 0.05 0.2
i 1 11.25  0.1 0.05 0.2
i 1 11.75  0.1 0.05 0.2
i 1 12.25  0.1 0.05 0.2
i 1 12.75  0.1 0.05 0.2
i 1 13.25  0.1 0.05 0.2
i 1 13.5   0.1 0.05 0.2
i 1 13.75  0.1 0.05 0.2
i 1 14.25  0.1 0.05 0.2
i 1 14.5   0.1 0.05 0.2
i 1 14.75  0.1 0.05 0.2
i 1 15.0   0.1 0.05 0.2

i 1 30.25  0.1 0.05 0.2
i 1 30.5   0.1 0.05 0.2
i 1 31     0.1 0.05 0.2

; instr 2
i 2 0    0.5 72 0.5 ; C4
i 2 0    0.5 55 0.5 ; G2
; 0.25s stop
i 2 0.75 0.5 67 0.5 ; G3
i 2 0.75 0.5 52 0.5 ; E2
; 0.25s stop
i 2 1.5  0.5 64 0.5 ; E3
i 2 1.5  0.5 48 0.5 ; C2
; 0.25s stop
i 2 1.75 0.5 69 0.5 ; A3
i 2 1.75 0.5 53 0.5 ; F2
i 2 2.25 0.5 71 0.5 ; B3
i 2 2.25 0.5 55 0.5 ; G2
i 2 2.75 0.25 70 0.5 ; Bb3
i 2 2.75 0.25 56 0.5 ; Gb3
i 2 3.0  0.5 69 0.5 ; A3
i 2 3.0  0.5 53 0.5 ; F2
i 2 3.5  0.5 67 0.5 ; G3
i 2 3.5  0.5 52 0.5 ; E2
i 2 4.0  0.5 76 0.5 ; E4
i 2 4.0  0.5 60 0.5 ; C3
i 2 4.5  0.5 79 0.5 ; G4
i 2 4.5  0.5 64 0.5 ; E3
i 2 5.0  0.5 81 0.5 ; A4
i 2 5.0  0.5 65 0.5 ; F3
i 2 5.5  0.3 77 0.5 ; F4
i 2 5.5  0.3 62 0.5 ; D3
i 2 5.75 0.3 79 0.5 ; G4
i 2 5.75 0.3 64 0.5 ; E3
; 0.25s stop
i 2 6.0  0.5 76 0.5 ; E4
i 2 6.0  0.5 60 0.5 ; C3
i 2 6.5  0.25 72 0.5 ; C4
i 2 6.5  0.25 57 0.5 ; A2
i 2 6.75 0.25 74 0.5 ; D4
i 2 6.75 0.25 59 0.5 ; B2
i 2 7.0  0.5 71 0.5 ; B3
i 2 7.0  0.5 55 0.5 ; G2
; 0.25s stop
; repeat from 7.75s
i 2 7.75   0.5 72 0.5  ; C4
i 2 7.75   0.5 55 0.5  ; G2
i 2 8.5    0.5 67 0.5  ; G3
i 2 8.5    0.5 52 0.5  ; E2
i 2 9.25   0.5 64 0.5  ; E3
i 2 9.25   0.5 48 0.5  ; C2
i 2 9.5    0.5 69 0.5  ; A3
i 2 9.5    0.5 53 0.5  ; F2
i 2 10.0   0.5 71 0.5  ; B3
i 2 10.0   0.5 55 0.5  ; G2
i 2 10.5   0.25 70 0.5 ; Bb3
i 2 10.5   0.25 56 0.5 ; Gb3
i 2 10.75  0.5 69 0.5  ; A3
i 2 10.75  0.5 53 0.5  ; F2
i 2 11.25  0.5 67 0.5  ; G3
i 2 11.25  0.5 52 0.5  ; E2
i 2 11.75  0.5 76 0.5  ; E4
i 2 11.75  0.5 60 0.5  ; C3
i 2 12.25  0.5 79 0.5  ; G4
i 2 12.25  0.5 64 0.5  ; E3
i 2 12.75  0.5 81 0.5  ; A4
i 2 12.75  0.5 65 0.5  ; F3
i 2 13.25  0.3 77 0.5  ; F4
i 2 13.25  0.3 62 0.5  ; D3
i 2 13.5   0.3 79 0.5  ; G4
i 2 13.5   0.3 64 0.5  ; E3
i 2 14.0   0.5 76 0.5  ; E4
i 2 14.0   0.5 60 0.5  ; C3
i 2 14.5   0.25 72 0.5 ; C4
i 2 14.5   0.25 57 0.5 ; A2
i 2 14.75  0.25 74 0.5 ; D4
i 2 14.75  0.25 59 0.5 ; B2
i 2 15.0   0.5 71 0.5  ; B3
i 2 15.0   0.5 55 0.5  ; G2
; 0.25s stop
;;
; 0.5s stop
i 2 16     0.25 79 0.5 ; G4
i 2 16.25  0.25 78 0.5 ; F#4
i 2 16.5   0.25 77 0.5 ; F4
i 2 16.75  0.5  75 0.5 ; D#4
i 2 17.25  0.25 76 0.5 ; E4
; 0.25s stop
i 2 17.75  0.25 68 0.5 ; G#3
i 2 18     0.25 69 0.5 ;A3
i 2 18.25  0.25 72 0.5 ;C4
; 0.25s stop
i 2 18.75  0.25 69 0.5 ; A3
i 2 19     0.25 72 0.5 ; C4
i 2 19.25  0.25 74 0.5 ;D4
; 0.5s stop
i 2 20     0.25 79 0.5; G4
i 2 20.25  0.25 78 0.5; F#4
i 2 20.5   0.25 77 0.5;F4
i 2 20.75  0.5 74 0.5;D4
i 2 21.25  0.25 76 0.5;E4
; 0.25s stop
i 2 21.75  0.5 67 0.5;G3 C5
i 2 21.75  0.5 84 0.5
i 2 22.25  0.25 67 0.5;G3 C5
i 2 22.25  0.25 84 0.5
i 2 22.5   0.5 67 0.5;G3 C5
i 2 22.5   0.5 84 0.5
;0.5s stop
;0.5s stop
i 2 24     0.25 79 0.5; G4
i 2 24.25  0.25 78 0.5;f#4
i 2 24.5   0.25 77 0.5;f4
i 2 24.75  0.5 75 0.5;D#4
i 2 25.25  0.25 76 0.5;E4
;0.25s stop
i 2 25.75  0.25 68 0.5;g#3
i 2 26     0.25 69 0.5;a3
i 2 26.25  0.25 72 0.5;c4
;0.25s stop
i 2 26.75  0.25 69 0.5;a3
i 2 27     0.25 72 0.5;c4
i 2 27.25  0.25 74 0.5;d4
;0.5s
i 2 28     0.5 75 0.5;Eb4
;0.25s
i 2 28.75  0.5 73 0.5;Db4
;0.25s
i 2 29.5   0.5 72 0.5;c4
;1.5s
;;
i 2 15.5   0.5 48 0.5 ; C2
;0.25s stop
i 2 16.25  0.25 55 0.5;G2
;0.5s stop
i 2 17     0.5 60 0.5;C3
i 2 17.5   0.5 53 0.5;f2
;0.25s stop
i 2 18.25  0.25 60 0.5;c3
i 2 18.5   0.5 60 0.5;c3
i 2 19     0.5 53 0.5;f2
i 2 19.5   0.5 48 0.5;c2
;0.25s stop
i 2 20.25  0.25 53 0.5;f2
;0.5s stop
i 2 21     0.25 53 0.5;f2
i 2 21.25  0.25 60 0.5;c3
;1.5s stop 
i 2 23     0.5 53 0.5;f2

i 2 23.5   0.5 48 0.5;c2
;0.25s stop
i 2 24.25  0.25 53 0.5;f2
;0.5s stop
i 2 25     0.5 60 0.5;c3

i 2 25.5   0.5 55 0.5;g2
;0.25
i 2 26.25  0.25 60 0.5;c3
i 2 26.5   0.5 60 0.5;c3
i 2 27     0.5 55 0.5;g2

i 2 27.5   0.5 48 0.5;c2
i 2 28     0.5 51 0.5;Eb2
;0.25
i 2 28.75  0.5 51 0.5;eb2
;0.25
i 2 29.5   0.5 60 0.5 ;c3
;0.25
i 2 30.25  0.25 53 0.5;f2
i 2 30.5   0.5 53 0.5;f2
i 2 31     0.5 48 0.5;c2

e
</CsScore>
</CsoundSynthesizer>




<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>551</x>
 <y>215</y>
 <width>320</width>
 <height>240</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="background">
  <r>240</r>
  <g>240</g>
  <b>240</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
