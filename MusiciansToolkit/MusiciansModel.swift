//
//  MusiciansModel.swift
//  MusiciansToolkit
//
//  Created by Mark Pizzutillo on 11/5/18.
//  Copyright © 2018 Mark Pizzutillo. All rights reserved.
//

import Foundation
import AudioKit

struct UserDefaultsKeys {
    static let tempoKey = "tempo"
    static let subdivisionKey = "subdivision"
}

class Model {
    static let sharedInstance = Model()
    static let sharedUserDefaults = UserDefaults.standard
    
    let audioDevice : Audio
    
    let numberOfTools = 6
    
    let backgroundImages = ["woodBG1","woodBG2","woodBG3","woodBG4"]
    
    let toolNames =
    ["Tuner",
     "Chords",
     "Scales",
     "Metronome",
     "Recorder",
     "Jam Session"]
    
    let segueNames = ["tunerSegue","chordSegue","scaleSegue","metSegue","recordSegue","jamSegue"]
    
    let imageNames = ["tuningFork","woodBG1","woodBG1","woodBG1","woodBG1","woodBG1"]
    
    public init() {
        audioDevice = Audio()
    }
}
