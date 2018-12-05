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

class RecorderViewController : UIViewController, AVAudioPlayerDelegate {
    let musicModel = Model.sharedInstance
    
    @IBOutlet weak var newRecordingButton: UIBarButtonItem!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var recordingIcon: UIImageView!
    
    @IBOutlet weak var tableContainerView: UIView!
    
    @IBOutlet weak var outputPlot: UIView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    let gain : Float = 2.0
    
    var nodeOutputPlot : AKNodeOutputPlot
    
    //Lower level EZAudioPlot for file playback
    var fileWaveform : EZAudioPlot
    var recorder : AKNodeRecorder
    
    //Reference to instantiated table view controller
    var tableViewController : RecorderTableViewController?
    var timer : Timer?
    var seconds : Int = 0
    var interval = TimeInterval(1)
    var recordingInProgress = false
    var playing = false
    
    var pauseTime : Double?
    
    required init?(coder aDecoder: NSCoder) {
        nodeOutputPlot = AKNodeOutputPlot()
        recorder = try! AKNodeRecorder(node: musicModel.audioDevice.microphoneInput)
        fileWaveform = EZAudioPlot()
        super.init(coder: aDecoder)
        
        // A particular node can only be tapped by one other unit. So, the
        // output plot can not plot the microphone directly while recording.
        // Therefore, it was chosen to plot the tuner's microphone high-pass
        // filter, which is technically a different node.
        nodeOutputPlot.node = musicModel.audioDevice.tuner?.filter
        
        nodeOutputPlot.gain = gain
        nodeOutputPlot.plotType = .rolling
        nodeOutputPlot.shouldFill = true
        nodeOutputPlot.shouldMirror = true
        nodeOutputPlot.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        nodeOutputPlot.color = #colorLiteral(red: 1, green: 0.3098039216, blue: 0.2666666667, alpha: 1)
        nodeOutputPlot.pause()
        
        if let file = recorder.audioFile {
            musicModel.audioDevice.player?.load(audioFile: file)
        }
        
        //Fit entire plot on screen
        fileWaveform.setRollingHistoryLength(fileWaveform.maximumRollingHistoryLength())
        fileWaveform.plotType = EZPlotType.buffer
        fileWaveform.shouldFill = true
        fileWaveform.shouldMirror = true
        fileWaveform.color = UIColor.blue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.isEnabled = false
        outputPlot.addSubview(nodeOutputPlot)
        outputPlot.addSubview(fileWaveform)
        outputPlot.sendSubview(toBack: fileWaveform)
        outputPlot.sendSubview(toBack: nodeOutputPlot)
        musicModel.audioDevice.player?.completionHandler = {
            self.donePlaying()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nodeOutputPlot.frame = CGRect(x: 0.0, y: 0.0, width: outputPlot.frame.width, height: outputPlot.frame.height)
        fileWaveform.frame = CGRect(x: 0.0, y: 0.0, width: outputPlot.frame.width, height: outputPlot.frame.height)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //plotBooster.disconnectInput()
        nodeOutputPlot.node = nil //Remove reference if still existing
        if (timer != nil) {
            timer?.invalidate()
        }
        musicModel.audioDevice.player?.completionHandler = nil
        if (recorder.isRecording) {
            recorder.stop()
            do {
                try recorder.reset()
            } catch {
                print("Error resetting")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
            
        //Get reference to table view controller
        case let vc as RecorderTableViewController:
            //Share references
            self.tableViewController = vc
            vc.recorderViewController = self
        default: break
        }
    }
    
    func donePlaying() {
        playing = false
        pauseTime = 0.0
        playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
    }
    
    @IBAction func newRecordingButtonPressed(_ sender: Any) {
        tableViewController?.tableView.isUserInteractionEnabled = false
        musicModel.audioDevice.player?.stop()
        if let selectedIndex = tableViewController!.tableView.indexPathForSelectedRow{
            tableViewController!.tableView.deselectRow(at: selectedIndex, animated: true)
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: {_ in self.updateTime() })
        
        recordingInProgress = true
        
        playButton.isEnabled = true
        playButton.setImage(#imageLiteral(resourceName: "stopRed"), for: .normal)
        
        timerLabel.text? = "00:00"
        timerLabel.isHidden = false
        recordingIcon.isHidden = false
        
        newRecordingButton.isEnabled = false
        
        do {
            
            try recorder.reset()
            try recorder.record()
            //nodeOutputPlot.node =
                //AKMixer(
                //AKMixer(musicModel.audioDevice.microphoneInput)
            nodeOutputPlot.isHidden = false
            fileWaveform.isHidden = true
            nodeOutputPlot.clear()
            nodeOutputPlot.resume()
        } catch {
            print("Error starting recording")
        }
        
        
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
            newRecordingButton.isEnabled = true
            
            nodeOutputPlot.pause()
            
            let recording = recorder.audioFile!
            musicModel.audioDevice.player?.load(audioFile: recording)
            
            //Prompt for recording name
            //Recording was successful
            if let _ = musicModel.audioDevice.player?.audioFile?.duration {
                recorder.stop()
                
                //Present name alert
                let alert = UIAlertController(title: "New Recording", message: nil, preferredStyle: .alert)
                
                alert.addTextField(configurationHandler: { textField in
                    textField.placeholder = "Enter Name"
                })
                
                alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
                    var recordingName = alert.textFields?.first?.text
                    
                    //Filter out illegal characters
                    
                    
                    if (recordingName == nil || recordingName == "") {
                        //Use date & time
                        let currentDateTime = Date()
                        
                        let formatter = DateFormatter()
                        formatter.timeStyle = .short
                        formatter.dateStyle = .short //Avoids "/" character
                        
                        recordingName = formatter.string(from: currentDateTime)
                    }
                    
                    var invalidChars = CharacterSet(charactersIn: ",:/")
                    invalidChars.formUnion(.newlines)
                    invalidChars.formUnion(.illegalCharacters)
                    invalidChars.formUnion(.symbols)
                    invalidChars.formUnion(.controlCharacters)
                    
                    let finalName = recordingName!.components(separatedBy: invalidChars).joined(separator: " ").replacingOccurrences(of: " ", with: "%20")
                    
                    //Export recording to documents
                    recording.exportAsynchronously(name: "\(finalName).caf", baseDir: .documents, exportFormat: .caf) {_, error in
                        if error != nil {
                        } else {
                            self.tableViewController?.updateDocumentData()
                        }
                    }
                    //Re-enable table view
                    self.tableViewController?.tableView.isUserInteractionEnabled = true
                }))
                
                self.present(alert, animated: true)
            }
            
        } else if (playing) {
            //Pause
            pauseTime = musicModel.audioDevice.player?.currentTime
            musicModel.audioDevice.player?.pause()
            playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            playing = false
        } else {
            //Play
            musicModel.audioDevice.player?.startTime = pauseTime ?? 0.0
            musicModel.audioDevice.player?.resume()
            playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            playing = true
            
        }
    }
    
    func chooseRecording(url : URL) {
        do {
            musicModel.audioDevice.player?.stop()
            
            let avFile = try AVAudioFile(forReading: url)
            musicModel.audioDevice.player?.load(audioFile: avFile)
            
            let ezFile = EZAudioFile(url: url)
            if let data = ezFile?.getWaveformData() {
                fileWaveform.updateBuffer( data.buffers[0], withBufferSize: data.bufferSize )
                fileWaveform.redraw()
            }
            playButton.isEnabled = true
            playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            playing = false
        } catch {
            print("Error. Could not load audio file")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        //
        // Need to check for conflict with chord/scale player.
        musicModel.audioDevice.player?.setPosition(0.0)
        playButton.isEnabled = true
        playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        playing = false
    }
}
