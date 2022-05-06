# Audio_Visualizer 🎵🎛️
Audio visualizer using the Processing graphics library &amp; Minim audio library

<p> 
    <img align='Right' src="https://github.com/Raziz1/Audio_Visualizer/blob/main/images/Visualizer_Logo.png? raw=true" >
</p> 

## Libraries 📚
* [Processing](https://processing.org/)
* [Minim](https://code.compartmental.net/tools/minim/)

## Overview
The following project is a music visualizer which utilizes the Processing (graphics library for Java) library and Minim (Audio processing) library. This project uses your devices microphone as an audio input source and analyzes the incoming frequencies. This project displays frequency bands and a beat circle with a gradient color. The gradient color on the frequency bands is dependent on the amplitude. The higher the amplitude the more red is colored into the gradient. For the beat circle, every time a beat is detected the circle expands and is colored with a gradient which is dependent on the radius of the circle. (See the code for a more detailed explanation)

## Versions 🧾

<p> 
    <img width=250 align='Right' src="https://github.com/Raziz1/Audio_Visualizer/blob/main/images/Visualizer_Version1.png? raw=true" >
</p> 

### Version 1
* Version 1 uses 4 colors and calculates a linear interpolation between all 4 colors and colors different sections of the frequency bands and beat circle with this gradient

</br>
</br>
 
<p> 
    <img width=250 align='Right' src="https://github.com/Raziz1/Audio_Visualizer/blob/main/images/Visualizer_Version2.png? raw=true" >
</p>  
 
### Version 2
* Version 2 simply creates a color gradient dependent on the amplitude of the frequency band and the radius of the beat circle


## Audio Background 📖🎹
### FFT (Fast Fourier Transform)
* A Fourier Transform is an algorithm that transforms a signal in the time domain, such as a sample buffer, into a signal in the frequency domain, often called the spectrum
* The audio buffers you want to analyze must have a length that is a power of two
* The spectrum does not represent individual frequencies, but actually represents frequency bands centered on particular frequencies
* To read more about FFT you can visit this link (https://code.compartmental.net/minim/javadoc/ddf/minim/analysis/FFT.html)
* Basically I use this library to analuze an analog signal and convert it to the frequency spectrum which can be visualized with vertical bars

### Beat Detector
* The BeatDetect class allows you to analyze an audio signal for distinc beats
* This is done using the Beat Detection Algorithms by Fredric Patin
* To read more about BeatDetect you can visit this link (https://code.compartmental.net/minim/beatdetect_class_beatdetect.html)
* BeatDetect analyzes two things the freuquency of energy and the level of energy
* If there are distinct spikes in energy compared to previous ones then it is considred a beat

