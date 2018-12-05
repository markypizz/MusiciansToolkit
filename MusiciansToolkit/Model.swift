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

struct lessonInfo {
    var title : String
    var url : String
    var author : String
    var imageName : String
}

typealias Notes = [noteInfo]

class Model {
    static let sharedInstance = Model()
    static let sharedUserDefaults = UserDefaults.standard
    
    let audioDevice : Audio
    
    let backgroundImages = ["woodBG1","woodBG2","woodBG3","woodBG4"]
    
    let toolNames =
    ["Tuner",
     "Chords",
     "Scales",
     "Metronome",
     "Recorder",
     "Jam Session",
     "Lessons"]
    
    let segueNames = ["tunerSegue","chordSegue","scaleSegue","metSegue","recordSegue","jamSegue","lessonSegue"]
    
    let imageNames = ["tuningFork","chords","scales","metronome","recorder","jamsession","lessons"]
    let uniqueNotes = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"]
    let indexTitles = ["C","#","D","#","E","F","#","G","#","A","#","B"]
    let chordTypes = ["maj","7","maj7","min","min7"]
    
    let lessonSections = ["Beginner","Intermediate","Advanced"]
    let lessons : [[lessonInfo]] = [
        
        //Beginner
        [lessonInfo(title: "Strumming Patterns", url: "https://www.youtube.com/watch?v=ely9LaJJJr4", author: "Marty Music", imageName: "strumming")],
        
        //Intermediate
        [lessonInfo(title: "Bending", url: "https://www.youtube.com/watch?v=aSUvcux5sDM", author: "GuitarLessons365", imageName: "bending")],
        
        //Advanced
        [lessonInfo(title: "Pinch Harmonics", url: "https://www.youtube.com/watch?v=5I5O8P-r5Rk", author: "JustinGuitar", imageName: "pinchharmonics")]
    ]
    let notes : Notes
    
    let guitarNotesPerString = [
        /* E */                 ["E4","F4","F#4","G4","G#4","A4","A#4"],
        /* B */                 ["B3","C4","C#4","D4","D#4","E4","F4" ],
        /* G */                 ["G3","G#3","A3","A#3","B3","C4","C#4"],
        /* D */                 ["D3","D#3","E3","F3","F#3","G3","G#3"],
        /* A */                 ["A2","A#2","B2","C3","C#3","D3","D#3"],
        /* E */                 ["E2","F2","F#2","G2","G#2","A2","A#2"]]
    
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
