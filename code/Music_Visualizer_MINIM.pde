//Import Libraries
import ddf.minim.analysis.*;
import ddf.minim.*;

//==========Initialize Minim libraries and audio constructores==========
Minim minim;
//++++++++++AudioInput++++++++++
//Minim Audio input constructor
//The AudionIn library provides a connection ot the current recording source of the computer
AudioInput in;

//++++++++++FFT (Fast Fourier Transform)++++++++++
/*
 - A Fourier Transform is an algorithm that transforms a signal in the time domain, such as a sample buffer, into a signal in the frequency domain, often called the spectrum
 - The audio buffers you want to analyze must have a length that is a power of two
 - The spectrum does not represent individual frequencies, but actually represents frequency bands centered on particular frequencies
 - To read more about FFT you can visit this link (https://code.compartmental.net/minim/javadoc/ddf/minim/analysis/FFT.html)
 - Basically I use this library to analuze an analog signal and convert it to the frequency spectrum, which can be visualized with vertical bars
 */
FFT fft;

//++++++++++BeatDetector++++++++++
/*
 - The BeatDetect class allows you to analyze an audio signal for distinc beats
 - This is done using the Beat Detection Algorithms by Fredric Patin
 - To read more about BeatDetect you can visit this link (https://code.compartmental.net/minim/beatdetect_class_beatdetect.html)
 - BeatDetect analyzes two things the frequency of energy and the level of energy
 - If there are distinct spikes in energy compared to previous ones, then it is considred a beat
 */
BeatDetect beat;

//==========Variables==========
float[] spectrum;
float decay = 0.9, heightScale;
float beatCircle_decay=0.925, beatCircle_scale;

//Gradient color variables
//color b1, b2, b3, b4;
float beatCircle_radius;

//==========Setup Function==========
void setup()
{
  fullScreen(P3D); //Use 3D graphics renderer

  /* ---------- Version 1.0 ----------
  //Define colors for vertical bar gradients
   b1 = color(5, 13, 97);
   b2 = color(217, 35, 185);
   b3 = color(241, 255, 10);
   b4 = color(255, 10, 10);
   */

  //Define radius of the BeatDetect circle
  beatCircle_radius=height/2;
  //Define a scaling value which will be used to exagerate the BeatDetect by increasing the radius of the BeatCircle
  beatCircle_scale=height/10;

  //Define a value used to scale the frequency bars so they are more visable
  heightScale=height/10;

  //Instantiate the Minim library
  minim = new Minim(this);

  // use the getLineIn method of the Minim object to get an AudioInput
  in = minim.getLineIn(Minim.STEREO, 512, 44100);
  /*
  - Specify audio type (Mono or Stero)
   - BufferSize describes the number of samples (corresponding to the amount of time) it takes for your computer to process an audio signal. The lower the buffer size the more computing power is required. In the Minim library it is measured in powers of two (32, 64, 128, 256, 512)
   - SampleRate describes how many times per second a sound is sampled. 44100Hz is the standard for most music applications
   */

  // create an FFT object that has a time-domain buffer and a sample size corresponding to the defined audio input
  // note that this needs to be a power of two
  // and that it means the size of the spectrum will be half as large.
  fft = new FFT(in.bufferSize(), in.sampleRate() );

  //Returns the size of the spectrum created by the transform (Reprseents the number of frequency bands)
  spectrum = new float[fft.specSize()];

  //Make sure the vertical lines have a stroke thickness of 5
  strokeWeight(5);

  // a beat detection object song SOUND_ENERGY mode with a sensitivity of 10 milliseconds
  beat = new BeatDetect();
}

//==========Main Function==========
void draw()
{
  background(0);
  stroke(255);

  //Draw the beat circle at the center of the window
  ellipseMode(CENTER);
  setRadialGradient(width/2, height/2, beatCircle_radius);

  //Perform a forward FFT on the samples in audio input's mix buffer & analyze it
  fft.forward(in.mix);

  //Analyze the sample input buffer every frame
  beat.detect(in.mix);

  //Shrink the beat circle radius by a factor of 'beatCircle_decay'
  beatCircle_radius*=beatCircle_decay;

  //Add 5 to the radius so it doesn't shrink to 0
  //This value is actually the minimum radius of the circle
  beatCircle_radius+=5;

  //If a beat is detected
  if (beat.isOnset()) {
    //If the circle radius is smaller than 25 than stop the logarithmic shrinking and set the radius to zero
    /*The beatCircle_radius decreases every frame by a factor of beatCircle_decay so every time we detect a beat we
     decrease the radius size logarithmically because the log input is smaller.
     We multiply by beatCircle_scale to better see the logarthmic shrinking better
     */
    beatCircle_radius=(beatCircle_radius <= 25 ? 0 : log(beatCircle_radius)) * beatCircle_scale;
  }

  //We only want to analyze the first 255 specturm bands because they are the most active
  for (int i = 0; i < 255; i++)
  {

    //Draw the bands but decay them every frame by a factor of 0.9 just so the bands aren't rapidly changing every frame
    spectrum[i] *= decay;
    spectrum[i] += fft.getBand(i); //Get the amplitude of the current frequency band

    //Set Color Gradient [setGradient(x,y, width, height, frequency band value)]
    setGradient(i*(width/100), height, width/100, -((spectrum[i] <= 0 ? 0 : log(spectrum[i])) * heightScale), spectrum[i]);
  }
}

/**void setGradient (int x, int y, float w, float h, float bands)
 *
 *Parameters  :
 * x: x coordinate of the frequency band
 * y: y coordinate of the frequency band
 * width: width of the frequency band
 * height: height of the frequency band
 * bands: frequency band amplitude
 *
 *Return Value: Nothing
 *
 *Description: Setting a gradient for each individual frequency band depending on the amplitude by redrawing the entire band in segments from left to right with a gradient applied to each segment
 */
void setGradient(int x, int y, float w, float h, float bands) {
  for (int i = y; i >= y+h; i--) { //Start a counter from the top y coordinate (bottom of the band) and count until it has reached the bottom y coodinate (top of the band)
    float inter = map(i, y, y+h, 0, 255); //Re-maps the index counter from the band height range to a range between 0 and 1
    color gradientBandColor; //Define the gradient colors
    gradientBandColor = color(inter, 255-inter, 0); //If the amplitude of the band is above a certain height change the gradient. Larger amplitudes are biased towards the color red
    stroke(gradientBandColor); //Color the frequency bands with the new gradient color
    line(x+5, i, x+w, i); //Redraw each frequency band as line segements from left to right with gradients applied
  }


  /* ---------- Version 1.0 ----------
   float inter = map(i, y, y+h, 0, 1); //Re-maps the index counter from the band height range to a range between 0 and 1
   color gradientBandColor; //Define the gradient colors
   //If the amplitude of the band is above a certain height change the gradient
   if (bands*100>10000) { //Loud amplitude
   gradientBandColor = lerpColor(b3, b4, inter);
   } else if (bands*100>1000) {
   gradientBandColor = lerpColor(b2, b3, inter);
   } else if (bands*100>0) { //Quiet ampltiude
   gradientBandColor = lerpColor(b1, b2, inter);
   }else{
   gradientBandColor=lerpColor(b1, b2, inter);
   }
   stroke(gradientBandColor); //Color the frequency bands with the new gradient color
   line(x+5, i, x+w, i); //Redraw each frequency band as line segements from left to right with gradients applied
   }
   */
}

/**void setRadialGradient(int x, int y, float Circle_radius)
 *
 *Parameters  :
 * x: x coordinate of the beatCircle
 * y: y coordinate of the beatCircle
 * circleRadius: radius of the beatCircle
 
 *Return Value: Nothing
 *
 *Description: Setting a gradient for the beatCircle depending on whether a beat is by redrawing concentric circles in segments with a gradient applied to each circle
 */

void setRadialGradient(int x, int y, float circleRadius) {
  float radius = circleRadius;
  color circleGradientColor;

  //Create an index counter which counts down from the outside radius until 0
  for (float r=radius; r>0; --r) {
    float inter = map(x, y, x+r, 0, 255); //Re-maps the x-coordinate from the the range (x-coordinate to the y-coordinate + radius) to a range between 0 and 255
    circleGradientColor=color(350-inter, inter, 0); //Depending on the index counters distance from the center change the concentric circle color gradient. We start at 350 for red so we have a heavier red bias
    stroke(circleGradientColor); //Color the concentric circles with the new gradient color
    circle(x, y, r); //Redraw every concentric circle at a radius based on the counter index
  }

  /*---------- Version 1.0 ----------
   //Create an index counter which counts down from the outside radius until 0
   for (float r=radius; r>0; --r) {
   float inter = map(x, y, x+r, 0, 1); //Re-maps the x-coordinate from the the range (x-coordinate to the y-coordinate + radius) to a range between 0 and 1
   //Depending on the index counters distance from the center change the concentric circle color gradient
   if (r>height/3) {
   circleGradientColor=lerpColor(b4, b3, inter); ////Calculates a color between the two defined colors at an increment between the colors of 'inter' (Which is based on the radius of the new concentric circle)
   } else if (r>height/7) {
   circleGradientColor=lerpColor(b3, b2, inter);
   } else {
   circleGradientColor=lerpColor(b2, b1, inter);
   }
   stroke(circleGradientColor); //Color the concentric circles with the new gradient color
   circle(x, y, r); //Redraw every concentric circle at a radius based on the counter index
   }
   */
}
