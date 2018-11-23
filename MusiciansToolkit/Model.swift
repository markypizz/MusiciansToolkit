//
//  MusiciansModel.swift
//  MusiciansToolkit
//
//  Created by Mark Pizzutillo on 11/5/18.
//  Copyright © 2018 Mark Pizzutillo. All rights reserved.
//

import Foundation
import AudioKit
import CoreData

struct UserDefaultsKeys {
    static let tempoKey = "tempo"
    static let subdivisionKey = "subdivision"
}

struct noteInfo : Codable {
    var octave : Int
    var name : String
    var frequency : Double
}

typealias Notes = [noteInfo]

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
    
    let imageNames = ["tuningFork","chords","scales","metronome","recorder","jamsession"]
    let uniqueNotes = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"]
    let indexTitles = ["C","#","D","#","E","F","#","G","#","A","#","B"]
    let chordTypes = ["maj","7","maj7","min","min7"]
    let notes : Notes
    
    public init() {
        audioDevice = Audio()
        
        let mainBundle = Bundle.main
        
        let solutionURL = mainBundle.url(forResource: "NoteInfo", withExtension: "plist")
        do {
            let data = try Data(contentsOf: solutionURL!)
            let decoder = PropertyListDecoder()
            notes = try decoder.decode(Notes.self, from: data)
        } catch {
            print(error)
            notes = []
        }
    }
}
