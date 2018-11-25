//
//  Tuner.swift
//  MusiciansToolkit
//
//  Created by Mark Pizzutillo on 11/13/18.
//  Copyright © 2018 Mark Pizzutillo. All rights reserved.
//

import Foundation
import AudioKit
import AudioKitUI

class Tuner {
    
    let minFrequency = 30
    let maxFrequency = 2500
    var gain : Float = 2.0
    
    
    let filter : AKHighPassFilter
    let tracker : AKFrequencyTracker
    let silence : AKBooster             //Audio mixer
    let node : AKNode
    
    //Plot initialization moved here, instead
    //of the ViewController. iOS 12 AK bug caused
    //occasional crash with making more than one
    //plot that was monitoring the same node
    let bufferPlot : AKNodeOutputPlot
    
    init(_ mic:AKMicrophone) {
        
        filter = AKHighPassFilter(mic, cutoffFrequency: 200, resonance: 0)
        tracker = AKFrequencyTracker(filter)
        silence = AKBooster(tracker, gain: 0)
        
        node = silence
        
        bufferPlot = AKNodeOutputPlot()
        //bufferPlot.node = mic
        bufferPlot.gain = gain
        bufferPlot.plotType = .buffer
        bufferPlot.shouldFill = false
        bufferPlot.shouldMirror = true
        bufferPlot.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        bufferPlot.color = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        
        //Don't run until window launch
        bufferPlot.pause()
    }
}
