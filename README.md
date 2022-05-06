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

### Beat Detector


