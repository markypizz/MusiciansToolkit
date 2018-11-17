//
//  Metronome.swift
//  MusiciansToolkit
//
//  Created by Mark Pizzutillo on 11/10/18.
//  Copyright © 2018 Mark Pizzutillo. All rights reserved.
//

import Foundation
import AudioKit

class Metronome {
    //var metronome : Timer?
    
    //120 BPM
    var audioPlayer : AVAudioPlayer?
    let metronome : AKMetronome
    
    let downbeatToneFrequency : Double = 2000.0
    let upbeatToneFrequency : Double = 1000.0
    
    var metronomeOn = false
    var node : AKNode
    
    init() {

        metronome = AKMetronome()
        
        metronome.frequency1 = downbeatToneFrequency
        metronome.frequency2 = upbeatToneFrequency
        
        node = metronome
    }
    
    func startMetronome() {
        metronome.reset()
        metronome.restart()
        metronomeOn = true
    }
    
    func stopMetronome() {
        metronome.stop()
        metronome.reset()
        metronomeOn = false
    }
    
    func tempoToTimeInterval(_ tempo : Int) -> TimeInterval {
        
        let interval:TimeInterval = 60.0 / Double(tempo)
        return interval
    }
}
