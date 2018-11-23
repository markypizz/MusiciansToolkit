//
//  RecorderViewController.swift
//  MusiciansToolkit
//
//  Created by Mark Pizzutillo on 11/22/18.
//  Copyright © 2018 Mark Pizzutillo. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

class RecorderViewController : UIViewController {
    let musicModel = Model.sharedInstance
    
    @IBOutlet weak var newRecordingButton: UIBarButtonItem!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var recordingIcon: UIImageView!
    
    @IBOutlet weak var tableContainerView: UIView!
    
    @IBOutlet weak var outputPlot: UIView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    var nodeOutputPlot : AKNodeOutputPlot?
    var recorder : AKNodeRecorder!
    
    //Reference to instantiated table view controller
    var tableViewController : RecorderTableViewController?
    var timer : Timer?
    var seconds : Int = 0
    var interval = TimeInterval(1)
    var recordingInProgress = false
    var playing = false
    
    let gain : Float = 2.0
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        nodeOutputPlot = AKNodeOutputPlot()
        nodeOutputPlot?.node = musicModel.audioDevice.microphoneInput
        nodeOutputPlot?.gain = gain
        nodeOutputPlot?.plotType = .buffer
        nodeOutputPlot?.shouldFill = true
        nodeOutputPlot?.shouldMirror = true
        nodeOutputPlot?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        nodeOutputPlot?.color = #colorLiteral(red: 1, green: 0.3098039216, blue: 0.2666666667, alpha: 1)
        nodeOutputPlot?.pause()
        
        recorder = try? AKNodeRecorder(node: musicModel.audioDevice.microphoneInput)
        if let file = recorder.audioFile {
            musicModel.audioDevice.player?.load(audioFile: file)
        }
        //
        // !
        // Nervous about this line below. Not sure if this breaks something
        // !
        musicModel.audioDevice.player?.isLooping = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.isEnabled = false
        outputPlot.addSubview(nodeOutputPlot!)
        outputPlot.sendSubview(toBack: nodeOutputPlot!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nodeOutputPlot?.frame = CGRect(x: 0.0, y: 0.0, width: outputPlot.frame.width, height: outputPlot.frame.height)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if (timer != nil) {
            timer?.invalidate()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
            
        //Get reference to table view controller
        case let vc as RecorderTableViewController:
            self.tableViewController = vc
        default: break
            
        }
    }
    
    @IBAction func newRecordingButtonPressed(_ sender: Any) {
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: {_ in self.updateTime() })
        
        recordingInProgress = true
        
        playButton.isEnabled = true
        playButton.setImage(#imageLiteral(resourceName: "stopRed"), for: .normal)
        
        timerLabel.text? = "00:00"
        timerLabel.isHidden = false
        recordingIcon.isHidden = false
        
        do {
            try recorder.record()
        } catch {
            print(error)
        }
        //nodeOutputPlot?.resume()
    }
    
    func updateTime() {
        seconds += 1
        let mins = Int(seconds) / 60 % 60
        let secs = Int(seconds) % 60
        
        timerLabel.text? = String(format:"%02i:%02i", mins, secs)
    }
    
    @IBAction func playPauseStopPressed(_ sender: Any) {
        if (recordingInProgress) {
            //Stop and prompt for Save
            recordingInProgress = false
            timer!.invalidate()
            seconds = 0
            timerLabel.isHidden = true
            recordingIcon.isHidden = true
            playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            playButton.isEnabled = false
            
            nodeOutputPlot?.pause()
            
            let recording = recorder.audioFile!
            musicModel.audioDevice.player?.load(audioFile: recording)
            
            //Prompt for recording name
            //Recording was successful
            if let _ = musicModel.audioDevice.player?.audioFile?.duration {
                recorder.stop()
                recording.exportAsynchronously(name: "Test.caf", baseDir: .documents, exportFormat: .caf) {_, error in
                    if error != nil {
                        print("fail")
                    } else {
                        print("success")
                        self.tableViewController?.updateDocumentData()
                    }
                }
            }
            
        } else if (playing) {
            //Pause
        } else { //Paused
            //Play
        }
    }
}
