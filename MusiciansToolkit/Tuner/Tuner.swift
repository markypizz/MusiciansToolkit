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
    let filter : AKHighPassFilter
    let tracker : AKFrequencyTracker
    let silence : AKBooster             //Audio mixer
    let node : AKNode
    //let test = EZAudioPlayer()
    
    init() {
        microphoneInput = AKMicrophone()
        
        filter = AKHighPassFilter(microphoneInput, cutoffFrequency: 200, resonance: 0)
        tracker = AKFrequencyTracker(filter)
        silence = AKBooster(tracker, gain: 0)
        
        node = silence
    }
}
