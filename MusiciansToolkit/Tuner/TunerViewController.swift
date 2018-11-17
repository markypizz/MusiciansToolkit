//
//  TunerViewController.swift
//  MusiciansToolkit
//
//  Created by Mark Pizzutillo on 11/14/18.
//  Copyright © 2018 Mark Pizzutillo. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

class TunerViewController : UIViewController {
    
    //var tuner : Tuner? = nil
    @IBOutlet weak var frequencyLabel: UILabel!
    
    @IBOutlet weak var noteNameLabel: UILabel!
    
    var updateTimer : Timer?
    let pollingRate = TimeInterval(0.1)
    //let defaultColor2 = CGColor(
    let defaultColor = UIColor(red: 0.0, green: 122.0, blue: 255.0, alpha: 1.0)
    
    @IBOutlet weak var tuningStatusLabel: UILabel!
    
    @IBOutlet weak var visualizerView: UIView!
    
    let musicModel = Model.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        musicModel.audioDevice.tuner!.tracker.start()
        
        //Setup Tuner
        updateTimer = Timer.scheduledTimer(withTimeInterval: pollingRate, repeats: true, block: { (timer) in
            self.updateDisplayFromPoll()
        })
        
        //updateTimer?.fire()
        
        setupPlot()
    }
    
    func setupPlot() { visualizerView.addSubview(musicModel.audioDevice.tuner!.bufferPlot)
        visualizerView.sendSubview(toBack: musicModel.audioDevice.tuner!.bufferPlot)
        musicModel.audioDevice.tuner!.bufferPlot.plotType = .buffer
        musicModel.audioDevice.tuner!.bufferPlot.resume()

    }
    
    func updateDisplayFromPoll() {
        frequencyLabel.text = String(Int(musicModel.audioDevice.tuner!.tracker.frequency))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //Match origin and size of visualizer view
        musicModel.audioDevice.tuner!.bufferPlot.frame.origin = CGPoint.zero
        musicModel.audioDevice.tuner!.bufferPlot.frame.size = visualizerView.frame.size

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Stop audio tracking
        musicModel.audioDevice.tuner!.tracker.stop()
        musicModel.audioDevice.tuner!.bufferPlot.pause()
    }
    
    @IBAction func plotTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            musicModel.audioDevice.tuner!.bufferPlot.plotType = .buffer
        case 1:
            musicModel.audioDevice.tuner!.bufferPlot.plotType = .rolling
        default:
            break
        }
    }
    
    @IBAction func getFreqButtonPressed(_ sender: UIButton) {
        frequencyLabel.text = String(Int(musicModel.audioDevice.tuner!.tracker.frequency))
    }
}
