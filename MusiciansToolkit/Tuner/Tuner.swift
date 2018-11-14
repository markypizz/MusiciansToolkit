//
//  Tuner.swift
//  MusiciansToolkit
//
//  Created by Mark Pizzutillo on 11/13/18.
//  Copyright © 2018 Mark Pizzutillo. All rights reserved.
//

import Foundation
import AudioKit


class Tuner {
    
    let minFrequency = 30
    let maxFrequency = 2500
    
    let microphoneInput : AKMicrophone
    let tracker : AKFrequencyTracker
    let booster : AKBooster             //Audio mixer
    //let test = EZAudioPlayer()
    
    init() {
        microphoneInput = AKMicrophone()
        
        tracker = AKFrequencyTracker(microphoneInput, hopSize: minFrequency, peakCount: maxFrequency)
        
        //Scilence tracker. Will only monitor, not output
        booster = AKBooster(tracker, gain: 0)
        AudioKit.output = booster
        
        
        //Crash on the audiokit start
        
        //do {
            //Will this work if the metronome is already on?
        //    try AudioKit.start()
        //} catch {
        //    print(error)
        //}
        
    }
}
