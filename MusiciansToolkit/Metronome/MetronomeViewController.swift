//
//  MetronomeViewController.swift
//  MusiciansToolkit
//
//  Created by Mark Pizzutillo on 11/5/18.
//  Copyright © 2018 Mark Pizzutillo. All rights reserved.
//

import UIKit

class MetronomeViewController: UIViewController {
    
    let userDefaults = Model.sharedUserDefaults
    let musicModel = Model.sharedInstance

    let defaultTempo = 120
    let cornerRadius : CGFloat = 6.0
    
    var tempo : Int {
        didSet {
            tempoLabel.text = "\(tempo) BPM"
            slider.value = Float(tempo)
            tempoStepper.value = Double(tempo)
            userDefaults.set(tempo, forKey: UserDefaultsKeys.tempoKey)
            
            //Update tempo for metronome object
            musicModel.metronome.metronome.tempo = Double(tempo * (subdivision+1))
        }
    }
    
    var subdivision : Int {
        didSet {
            userDefaults.set(subdivision, forKey: UserDefaultsKeys.subdivisionKey)
            subdivisionSegmentedControl.selectedSegmentIndex = subdivision
            
            //Change metronome subdivision
            musicModel.metronome.metronome.subdivision = (subdivision+1)
            
            //Double / Triple / Quadruple tempo to match new subdivison
            musicModel.metronome.metronome.tempo = Double(tempo * (subdivision+1))
            
        }
    }
    
    @IBOutlet weak var tempoLabel: UILabel!
    
    @IBOutlet weak var tempoStepper: UIStepper!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var subdivisionSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var startButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        tempo = 120
        subdivision = 1
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Remove the white offsets
        startButton.layer.cornerRadius = cornerRadius
        
        subdivision = userDefaults.integer(forKey: UserDefaultsKeys.subdivisionKey)
        
        let savedTempo = userDefaults.integer(forKey: UserDefaultsKeys.tempoKey)
        
        if (savedTempo != 0) {
            tempo = savedTempo
        }
        
        if (musicModel.metronome.metronomeOn) {
            startButton.setTitle("Stop", for: .normal)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        tempo = Int(sender.value)
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        tempo = Int(sender.value)
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        
        if (musicModel.metronome.metronomeOn) {
            musicModel.metronome.stopMetronome()
            startButton.setTitle("Start", for: .normal)
        } else {
            musicModel.metronome.startMetronome()
            startButton.setTitle("Stop", for: .normal)
        }
    }
    
    @IBAction func subdivisionDidChange(_ sender: UISegmentedControl) {
        //Set defaults
        subdivision = Int(sender.selectedSegmentIndex)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
