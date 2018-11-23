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
    
    @IBOutlet weak var pitchView: UIView!
    
    @IBOutlet weak var frequencyLabel: UILabel!
    
    @IBOutlet weak var noteNameLabel: UILabel!
    
    @IBOutlet weak var tuningStatusLabel: UILabel!
    
    @IBOutlet weak var octaveLabel: UILabel!
    
    @IBOutlet weak var visualizerView: UIView!
    
    @IBOutlet weak var hzLabel: UILabel!
    
    @IBOutlet weak var octaveTextLabel: UILabel!
    
    @IBOutlet weak var sharpFlatLabel: UILabel!
    
    
    let musicModel = Model.sharedInstance
    let pollingRate = TimeInterval(0.15)
    let ampThreshold = 0.013
    
    let lowFrequencyShelf = 2.0
    let highFrequencyShelf = 30.0
    let notesPerOctave = 12
    let noteFrequencyDistanceExponent : Double = 1/12
    
    var updateTimer : Timer?
    var pitchPercentageView : UIView?
    let pitchPercentageViewAnimationTime = 0.1
    var pitchPercentage = 0.0 {
        didSet {
            
            //Might need more time
            UIView.animate(withDuration: pitchPercentageViewAnimationTime) {
                self.pitchPercentageView?.frame.size.width = CGFloat(self.pitchPercentage) * self.pitchView.frame.width
            }
            if (pitchPercentage > 0.45 && pitchPercentage < 0.55) {
                UIView.animate(withDuration: pitchPercentageViewAnimationTime) {
                    self.pitchPercentageView?.backgroundColor = #colorLiteral(red: 0.2352941176, green: 1, blue: 0.3333333333, alpha: 1)
                }
                sharpFlatLabel.text = "In Tune!"
            } else {
                UIView.animate(withDuration: pitchPercentageViewAnimationTime) {
                    self.pitchPercentageView?.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                }
                
                if (pitchPercentage < 0.5) {
                    sharpFlatLabel.text = "Flat"
                } else {
                    sharpFlatLabel.text = "Sharp"
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteNameLabel.text = ""
        hzLabel.isHidden = true
        frequencyLabel.isHidden = true
        octaveLabel.isHidden = true
        octaveTextLabel.isHidden = true
        sharpFlatLabel.isHidden = true
        musicModel.audioDevice.tuner!.tracker.start()
        
        //Setup Tuner
        updateTimer = Timer.scheduledTimer(withTimeInterval: pollingRate, repeats: true, block: { (timer) in
            self.updateDisplayFromPoll()
        })
        
        //Create view
        pitchPercentageView = UIView(frame: CGRect.zero)
        pitchPercentageView?.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.5568627451, blue: 1, alpha: 1)
        pitchView.addSubview(pitchPercentageView!)
        pitchView.sendSubview(toBack: pitchPercentageView!)
        
        //Ensure correct microphone input (fixes noise bug)
        if let inputs = AudioKit.inputDevices {
            do {
                try AudioKit.setInputDevice(inputs[0])
                try musicModel.audioDevice.microphoneInput.setDevice(inputs[0])
            } catch {
                print(error)
            }
        }
        
        setupPlot()
    }
    
    func setupPlot() {
        visualizerView.addSubview(musicModel.audioDevice.tuner!.bufferPlot)
        visualizerView.sendSubview(toBack: musicModel.audioDevice.tuner!.bufferPlot)
        musicModel.audioDevice.tuner!.bufferPlot.plotType = .buffer
        musicModel.audioDevice.tuner!.bufferPlot.resume()
        musicModel.audioDevice.tuner!.bufferPlot.clear()
    }
    
    func updateDisplayFromPoll() {
        let frequency = musicModel.audioDevice.tuner!.tracker.frequency
        
        frequencyLabel.text = String(Int(frequency))
        let amplitude = musicModel.audioDevice.tuner!.tracker.amplitude
        
        if (amplitude > ampThreshold) {
            //Find note and deviation
            //If frequency is within the detectable range
            if ((frequency < musicModel.notes[musicModel.notes.count-1].frequency + highFrequencyShelf) && (frequency > musicModel.notes[0].frequency - lowFrequencyShelf)) {
                var noteFound = false
                var previousIndex = 0
                var index = 1
                var finalIndex = 0
                
                var currentFrequency = musicModel.notes[index].frequency
                var previousDeviation = 999999.0 //arbitrary large value
                var currentDeviation = frequency - musicModel.notes[index].frequency
                
                //Incremental movement up
                
                //Previous deviation was closer to the exact value
                if (abs(previousDeviation) < abs(currentDeviation)) {
                    finalIndex = index
                    noteFound = true
                }
                
                while (!noteFound) {
                    //If current frequency is twice as large, double the choice
                    if (frequency > 2*currentFrequency) {
                        //Add 12 to index
                        previousIndex = index
                        index = index + notesPerOctave
                        currentFrequency = musicModel.notes[index].frequency
                    } else {
                        //Increment counters
                        index += 1
                        previousIndex += 1
                    }
                    
                    previousDeviation = currentDeviation
                    
                    //Avoid edge
                    if (index == musicModel.notes.count) {
                        currentDeviation = 9999
                    } else {
                        currentDeviation = frequency - musicModel.notes[index].frequency
                    }
                    
                    if (abs(previousDeviation) < abs(currentDeviation)) {
                        finalIndex = index-1
                        noteFound = true
                    }
                }
                
                //Note was found
                //Find note bounds
                //Also need to check lower bound
                if (finalIndex != musicModel.notes.count-2) {
                    
                    //Multiply by 1/24th to get exact center between notes
                    let leftFreq = musicModel.notes[finalIndex-1].frequency * pow(2,noteFrequencyDistanceExponent / 2.0)
                    
                    let rightFreq = musicModel.notes[finalIndex].frequency * pow(2,noteFrequencyDistanceExponent / 2.0)
                    
                    //Find percentage between the two
                    let leftDist = frequency - leftFreq
                    let rightDist = rightFreq - frequency
                    
                    //subtract off 1% due to slight error in the linear approximation of the exponential relationship between pitches
                    pitchPercentage = (leftDist / (leftDist + rightDist)) - 0.01
                    noteNameLabel.text = musicModel.notes[finalIndex].name
                    octaveLabel.text = String(musicModel.notes[finalIndex].octave)
                    
                    hzLabel.isHidden = false
                    frequencyLabel.isHidden = false
                    octaveTextLabel.isHidden = false
                    noteNameLabel.isHidden = false
                    octaveLabel.isHidden = false
                    sharpFlatLabel.isHidden = false
                }
            }
        } else {
            //Clear Display
            noteNameLabel.text = ""
            hzLabel.isHidden = true
            frequencyLabel.isHidden = true
            octaveLabel.isHidden = true
            octaveTextLabel.isHidden = true
            sharpFlatLabel.isHidden = true
            pitchPercentage = 0.0
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //Match origin and size of visualizer view
        musicModel.audioDevice.tuner!.bufferPlot.frame.origin = CGPoint.zero
        musicModel.audioDevice.tuner!.bufferPlot.frame.size = visualizerView.frame.size
        
        pitchPercentageView?.frame.origin = CGPoint.zero
        pitchPercentageView?.frame.size = CGSize(width: pitchView.frame.width * CGFloat(pitchPercentage), height: pitchView.frame.height)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //Stop audio tracking
        musicModel.audioDevice.tuner!.tracker.stop()
        musicModel.audioDevice.tuner!.bufferPlot.pause()
        //AKSettings.defaultToSpeaker = true
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
}
