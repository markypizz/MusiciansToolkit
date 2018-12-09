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
    var player : AKPlayer? //Audio file player
    var notePlayer : AKPlayer? //Note player
    var noteBooster : AKBooster? //Note booster
    let microphoneInput : AKMicrophone
    let noteGain = 2.0
    
    init() {
        microphoneInput = AKMicrophone()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.audioRouteChangeListener(notification:)),
            name: NSNotification.Name.AVAudioSessionRouteChange,
            object: nil)
        
        mixer = AKMixer()
        tuner = Tuner(microphoneInput)
        metronome = Metronome()
        player = AKPlayer()
        
        //Boost note levels as the files are quiet
        notePlayer = AKPlayer()
        noteBooster = AKBooster(notePlayer)
        noteBooster?.gain = noteGain
        
        //Connect tuner and metronome nodes
        mixer?.connect(input: noteBooster)
        mixer?.connect(input: tuner?.node)
        mixer?.connect(input: metronome?.node)
        mixer?.connect(input: player)
        
        AudioKit.output = mixer
        //AKSettings.audioInputEnabled = true
        
        do {
            //Should default back to main speaker after headphone plug/unplug
            
            //Doesnt work
            
            try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
            
            //try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            
            // Use main speaker.
            // Sometimes would default to ear speaker
            
            //Does work sort of
            //try AKSettings.session.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
            
            //Start audio driver
            try AudioKit.start()
        } catch {
            print(error)
        }
    }
    
    @objc func audioRouteChangeListener(notification:NSNotification) {
        let audioRouteChangeReason = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as! UInt
        
        switch audioRouteChangeReason {
        //case AVAudioSessionRouteChangeReason.newDeviceAvailable.rawValue:
            //Headphones plugged in
        //case AVAudioSessionRouteChangeReason.oldDeviceUnavailable.rawValue:
            //Headphones removed
            //do {
                // Reset back to main speaker
                //try AKSettings.session.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
            //} catch {
            //    print(error)
            //}
            
        default:
            break
        }
    }

}
