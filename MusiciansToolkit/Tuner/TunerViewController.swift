//
//  TunerViewController.swift
//  MusiciansToolkit
//
//  Created by Mark Pizzutillo on 11/14/18.
//  Copyright © 2018 Mark Pizzutillo. All rights reserved.
//

import UIKit
import AudioKit

class TunerViewController : UIViewController {
    
    //var tuner : Tuner? = nil
    
    @IBOutlet weak var frequencyLabel: UILabel!
    
    let musicModel = Model.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tuner.tracker.start()
        
        //Turn of metronome if on
        //if (musicModel.metronome != nil) {
        //    musicModel.metronome = nil
            
            //Remove tuner if exists
        //    AudioKit.disconnectAllInputs()
            
            //Stop audio driver
            //do {
            //    try AudioKit.stop()
            //} catch {
            //    print("Error")
            //    print(error)
            //}
        //}
        
        //do {
        //    try AudioKit.stop()
        //} catch {
        //    print("Error")
        //    print(error)
        //}
        musicModel.audioDevice.tuner!.tracker.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Stop AudioKit
        //do {
        //    try AudioKit.stop()
        //} catch {
        //    print("Error")
        //    print(error)
        //}
    }
    @IBAction func getFreqButtonPressed(_ sender: UIButton) {
        frequencyLabel.text = String(Int(musicModel.audioDevice.tuner!.tracker.frequency))
    }
}
