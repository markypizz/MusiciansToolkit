Musician's Toolkit
===

Musician's Toolkit began as the final project for the iOS development course I took at Penn State. Since then I have removed some features, added others, and worked to clean it up into something I am proud to present.

This app makes use of the [AudioKit](https://github.com/AudioKit/AudioKit) framework and its powerful tools including Fourier Transform and accurate metronome (compared to NSTimer).

## Features

* Tuner - Fully functional tuner with visual "sliding" indicator and audio buffer plot. Includes frequency and octave information.
* Metronome - Simple metronome that can be divided into quarter, eighth, eighth triplet, and sixteenth notes
* Audio Recorder - Stores recordings into system memory to be played back later. Also uses visual audio waveforms.
* Jam Session - Garageband-style on-screen monophonic playable guitar with subtle animations.
* Chords and Scales Libraries - Libraries of guitar chord and scale audio clips and tableature. These will be removed in later updates.
* Lessons - Links to YouTube guitar lessons that I personally recommmend. Likely will also be removed

I am always looking for more features to add as I convert this app from more of a guitarist's app to a more general musician's app. Use the issues page to add suggestions!

## Build Instructions
Clone the repository, run 
```
$pod install
```
Open the project in XCode using the .xcworkspace file, and enjoy!

## Copyright
I do not endorse the selling (free or paid)/distributing/etc. for the original content in this app (which does not include AudioKit, see the AudioKit license on their github page). I claim all rights to my original code.
