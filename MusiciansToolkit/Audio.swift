//
//  Audio.swift
//  MusiciansToolkit
//
//  Created by Mark Pizzutillo on 11/14/18.
//  Copyright © 2018 Mark Pizzutillo. All rights reserved.
//

import Foundation
import AudioKit

/// Creates the audio object for the tuner and
/// metronome. Mixer object allows both to
/// work independently.

class Audio {
    var tuner : Tuner?
    var metronome : Metronome?
    var mixer : AKMixer?
    
    init() {
        mixer = AKMixer()
        tuner = Tuner()
        metronome = Metronome()
        
        //Connect tuner and metronome nodes
        mixer?.connect(input: tuner?.node)
        mixer?.connect(input: metronome?.node)
        
        AudioKit.output = mixer
        AKSettings.audioInputEnabled = true
        
        do {
            // Use main speaker.
            // Sometimes would default to ear speaker
            try AKSettings.session.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
            
            //Start audio driver
            try AudioKit.start()
        } catch {
            print(error)
        }
    }
}
