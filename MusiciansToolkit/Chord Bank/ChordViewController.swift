//
//  ChordViewController.swift
//  MusiciansToolkit
//
//  Created by Mark Pizzutillo on 11/20/18.
//  Copyright © 2018 Mark Pizzutillo. All rights reserved.
//

import UIKit
import AudioKit

class ChordViewController : UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var playChordButton: UIButton!
    
    let musicModel = Model.sharedInstance
    let cornerRadius : CGFloat = 3.0
    var name : String?
    var audioFile : AKAudioFile?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = UIImage(named: name!) {
            imageView.image = image
        }
        self.title = name
        playChordButton.layer.cornerRadius = cornerRadius
    }
    
    @IBAction func playChordButtonPressed(_ sender: UIButton) {
        if (musicModel.audioDevice.player?.isPlaying ?? false) {
            musicModel.audioDevice.player?.stop()
        }
        if (name != nil) {
            do {
                try audioFile = AKAudioFile(readFileName: "\(name!).wav")
                musicModel.audioDevice.player?.load(audioFile: audioFile!)
                musicModel.audioDevice.player?.play()
            } catch {
                print(error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //Prevent image stretching
        if ((imageView.image?.size.height)! > imageView.frame.size.height) {
            imageView.contentMode = .scaleAspectFit
        } else {
            imageView.contentMode = .center
        }
    }
    
    func configure(chordName: String) {
        name = chordName
    }
}
