# Uiua 0.13.0-dev.2
# [url]

S ← 2048                    # Samples per oscillator
O ← 256                     # Oscillators per table
T ← ×S O                    # Samples per table
SU ← ÷2+1                   # Signed to unsigned
US ← -1×2                   # Unsigned to signed
OU ← ÷⟜⇡S                   # Oscillator base, unsigned 0-1
OT ← ×τOU                   # Oscillator base, trigonometric 0-2π
R ← ↯¤T                     # Oscillator to table (repeat)
U ← ⍥(⊢⍉↯⊟:⟜÷2⊸⧻)           # Octave up (for playback only)
GH ← 200                    # Graph height
C ← ↥¯1↧1                   # Clamp
SW ← ⊏◿⧻,                   # Select (wrapped)
SI ← +⊙×⟜-⊃⊃(SW⌊)(SW⌈)(-⊸⌊) # Select (interpolated)
RI ← SI×⇡:÷,⧻,              # Resize (interpolated)
CS ← ∿+η                    # Cosine
NR ← ↧⊸↥                    # NaN replace
SC ← NR1÷⟜∿                 # Sinc
VB ← ÷-1⟜⇡O                 # Value base
VR ← +⊙×:-⟜:                # Value range [min, max, values]
GL ← 16                     # GIF length (frames)
R₀ ← ☇0                     # Rerank zero
R₁ ← ☇1                     # Rerank one
V! ← R₁≡^!R₀
VV! ← R₁≡^!R₀⊙R₀
A! ← R₁≡^!R₁
AA! ← R₁≡^!R₁⊙R₁
VA! ← R₁≡^!R₀⊙R₁
VAA! ← R₁≡^!R₀⊙R₁⊙⊙R₁

# Convolutions
CId ← ¤¤1 # Identity (delta) convolution

# Table values
Val ← VR⊙⊙(VB)     # Values (linear) [min, max]
ValPI ← VR⊙⊙(ⁿ:VB) # Values (power in) [min, max, base]
ValPO ← ⇌ValPI:    # Values (power out) [min, max, base]

# Helpers
RndInt ← +1⌊×⚂ # Random integer 1-N [Max]

# Operations
Sum ← °□/+⍚R₁                              # Sum [Waves/Tables]
Avg ← Sum÷⊸⧻                               # Average [Waves/Tables]
Amp ← VA!×                                 # Amplify [Amount, Wave/Table]
Max ← A!(◌⍥⟜÷≠0.↥∩/↥⟜¯.)                   # Maximize [Wave/Table]
Phs ← VA!(↻⁅×⧻,)                           # Phase shift [Amount(s), Wave/Table]
Zer ← A!(↻⊗/↧⌵..)                          # Phase shift to zero point [Wave/Table]
Bit ← VA!(US↧1÷-1:⌊×,SU:⁅ⁿ:2+1×15-:1√↧1↥0) # Bitcrush [Amount (0-1), Wave/Table]
Rev ← A!⇌                                  # Reverse [Wave/Table]
Inv ← A!¯                                  # Invert [Wave/Table]
Mir ← A!(⊂⇌.↙÷2S)                          # Mirror 1st half [Wave/Table]
Fad ← VA!(⇌⬚1×⇌:⬚1⟜×÷⧻.⇡⌊÷2×S↥0)           # Fade in & out [Amount (0-1), Wave/Table]
AM ← VAA!(×+1÷2×-1:)                       # Amplutude modulation [Amplitude(s), Modulator(s), Carrier(s)]
FM ← VAA!(SI×S+OU×)                        # Frequency modulation [Amplitude(s), Modulator(s), Carrier(s)]
Cnv ← AA!(/+×⍉◫⊙(↯♭):-1⊸+⧻,⧻⟜:)            # Convolve [Impulse(s), Wave/Table]

# Basic waveforms
Sin ← V!(∿×:OT)      # Sine wave [Harmonic]
Saw ← V!(US◿1×:OU)   # Saw wave [Harmonic]
Pul ← VV!(US≤US:Saw) # Pulse wave [Harmonic, Duty]
Sqr ← V!(Pul:0.5)    # Square wave [Harmonic]
Nsw ← (☇1US⍥(⊂⚂)S[]) # Noise wave []
Nst ← (⍥(⊂Nsw)O[])   # Noise table []

# Utility
Print ← &pf
Export ← &ap C♭
Test ← &ap U3R C♭
Graph ← ⍢⊢(=1⧻)▽=0⇡⌊÷GL O≡(⇌⬚1⊞≠⇡GH⁅×-1GH SU U2C)
Image ← &ims↯O_S SU R C♭
ImportImage ← RI O≡RI S⍜⍉≡(÷3/+↙3)◌°img&frab
ImportWave ← R₀ RI S◌◌°audio&frab
ImportTable ← ↯O_S RI T◌◌°audio&frab # Import 256-wave table
TableAverage ← R₀÷O/+↯O_S            # Table to wave [Table]
TableIndex ← R₀⊡↧-1O↥0⁅:↯O_S:        # Table to wave [Index (0-255), Table]
ImageToTable ← US
GraphConv ← Graph A!(⬚0×↯S1)

# Sample waveforms/wavetables
Wave₁ ← Avg{Sin3 Amp0.7Sin2 Sin1}
Wave₂ ← AM0.4Sin7 AM0.5Sin2 Sin1
Wave₂ ← Avg{Saw1 (Pul 2 0.2)}
Wave₄ ← Bit0.7 FM0.1Sin7 Sin1
Tbl₁ ← FM(Val 0 1) Sin2 Sin1
Tbl₂ ← Max Avg{Amp(Val 0 1)Sin2 Sin1}

Print "Tbl₁"
Test Tbl₁
Image Tbl₁
Graph Tbl₁
