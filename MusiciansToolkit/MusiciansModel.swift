//
//  MusiciansModel.swift
//  MusiciansToolkit
//
//  Created by Mark Pizzutillo on 11/5/18.
//  Copyright © 2018 Mark Pizzutillo. All rights reserved.
//

import Foundation

struct UserDefaultsKeys {
    static let tempo = "tempo"
}

class Model {
    static let sharedInstance = Model()
    static let sharedUserDefaults = UserDefaults.standard
    
    let numberOfTools = 6
    
    let backgroundImages = ["woodBG1","woodBG2"]
    
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
        
    }
}
