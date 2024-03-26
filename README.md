## Sound Analysis, Synthesis and Processing - Homework 1
# Leslie speaker emulation
<br>
 The project is the implementation of a computationally efficient Leslie speaker emulation presented in [2]. The Leslie speaker is a famous amplifier and speaker for electronic instruments.  It is based on a rotating baffle chamber (”drum”) in front of the bass speaker and a rotating system of
 horns in front of the treble driver, which are responsible for the characteristic sound of this device. The  musician controls the rotation speed of the drum and horns via an external switch or pedal that alternates between a slow and fast speed setting called chorale and tremolo. As for how it works, the audio signal is
 amplified and then sent to a crossover network that splits it into two separate frequency bands (bass and
 treble), and each output is sent to a speaker. A single woofer is used for bass and a single compression
 driver is used for the treble. The sound radiated from the speakers is isolated in an enclosure, except
 for a series of outlets leading to the rotating horns or drum. An electric motor drives both the horns
 and the drum with the same power, although the horn rotates slightly faster than the drum due to its
 lighter weight. The rotation of the drum and horn is perceived by the listener as frequency and amplitude
 modulation.<br>
 An efficient digital model for the Leslie loudspeaker is described in [2] and is based on the scheme
 shown in Fig. 1. The digital structure takes as input a discrete-time audio signal x[n] sampled at a
 sampling frequency Fs and outputs a discrete-time audio signal y[n]. First, the signal passes through
 two separate filters that emulate the crossover network. The filters are characterized by the same cutoff
 frequency and divide the signal into two frequency bands, yielding two separate signal paths (bass and
 treble). The rotation of the drum and horns is modeled separately for each of the two frequency bands and
 each one comprises two blocks, i.e., a frequency modulation block and an amplitude modulation block.
 For each signal path, the modulation signals (Modulator 1 and Modulator 2 in fig. 1) are shared between
 the frequency and amplitude modulation blocks. The frequency modulation effect is implemented with a
 spectral delay filter (SDF), i.e., a chain of N all-pass filters modulated by an external signal. The outputs
 of the SDFs are then amplitude modulated with the same modulation signal. The two audio paths are
 then summed to form the output y[n].<br>
