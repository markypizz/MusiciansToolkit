//
//  JamSessionViewController.swift
//  MusiciansToolkit
//
//  Created by Mark Pizzutillo on 12/3/18.
//  Copyright © 2018 Mark Pizzutillo. All rights reserved.
//

import UIKit

class JamSessionViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let musicModel = Model.sharedInstance
    
    @IBOutlet weak var guitarImage: UIImageView!
    let tapRecognizer = UIGestureRecognizer()
    let stringHeight : [CGFloat] = [7.0, 6.0, 5.0, 4.0, 3.0, 3.0]
    let numberOfStrings = 6
    let stringOffsetPercentFromBottom : CGFloat = 0.0860
    let guitarBottomOffsetPercent : CGFloat = 0.1088
    let jamSessionStringOffsetPercent : CGFloat = 0.12
    
    //Percentage distances from left for fret hit detection
    //Hardcoded from photo image
    let jamSessionFretPercentages = [0.0744, 0.2436, 0.412, 0.5812, 0.7496, 0.9184, 1]
    
    var stringHitZones = [CGFloat]()
    
    var strings = [CAShapeLayer]()
    
    
    let lastPlayedNotes : [String?] = [nil,nil,nil,nil,nil,nil]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guitarImage.isUserInteractionEnabled = false
        tapRecognizer.delegate = self
        guitarImage.addGestureRecognizer(tapRecognizer)
        
        //Force landscape if in portrait
        if (UIDevice.current.orientation.isValidInterfaceOrientation
            ? UIDevice.current.orientation.isPortrait
            : UIApplication.shared.statusBarOrientation.isPortrait) {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.landscapeLeft , .landscapeRight]
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        for touch in touches {
            let location = touch.location(in: guitarImage)
            
            let percentOffset = location.x / guitarImage.frame.width
            
            //Find fret
            var fret = 0
            while (Double(percentOffset) >= jamSessionFretPercentages[fret]) {
                fret += 1
            }
            
            //Find string
            var string: Int? = nil
            var i = 0
            
            if (location.y < stringHitZones[0] || location.y > (stringHitZones[stringHitZones.count-1])) {
                
                //Out of range. Don't enter loop
                i = 6
            }
            
            while (i < 6 && string == nil) {
                if (location.y >= stringHitZones[i] && location.y <= stringHitZones[i+1]) {
                    //Desired string found
                    string = i
                }
                
                i += 1
            }
            
            
            
            //let animation = CAAnimation()
            //animation
            
            //self.string[0].add(, forKey: <#T##String?#>)
            if (string != nil) {
                playSoundForNote(string: string!, fret: fret)
                print(musicModel.guitarNotesPerString[string!][fret])
            }
            
            
        }
    }
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//
//            let location = touch.location(in: guitarImage)
//
//            let percentOffset = location.x / guitarImage.frame.width
//
//            //Find offset
//            var fret = 0
//            while (Double(percentOffset) >= musicModel.jamSessionFretPercentages[fret]) {
//                fret += 1
//            }
//
//            let string = 0
//
//            playSoundForNote(string: string, fret: fret)
//
//            print(musicModel.guitarNotesPerString[0][fret])
//        }
//    }
    
    func addStrings() {
        //Bottom 3 strings
        for i in 0..<3 {
            let string = CAShapeLayer()
            let stringBG = CAShapeLayer()
            
            stringBG.strokeColor = UIColor.black.cgColor
            stringBG.lineWidth = stringHeight[i]
            string.strokeColor = UIColor.gray.cgColor
            string.lineWidth = stringHeight[i]
            string.lineDashPattern = [NSNumber(value: Int(3-i)),1]
            
            stringBG.addSublayer(string)
            
            let stringPath = UIBezierPath()
            let stringPathBG = UIBezierPath()
            
            let beginPoint = CGPoint(x: 0.0, y: ((
                
                //Offset from bottom
                guitarImage.frame.height -
                    (guitarImage.frame.height * stringOffsetPercentFromBottom)) -
                
                //Subtracted by string seperation offset
                (CGFloat(jamSessionStringOffsetPercent * CGFloat(i+1)) * guitarImage.frame.height)))
            
            let endPoint = CGPoint(x: guitarImage.frame.width, y: ((guitarImage.frame.height - (guitarImage.frame.height * stringOffsetPercentFromBottom)) - (CGFloat(jamSessionStringOffsetPercent * CGFloat(i+1)) * guitarImage.frame.height)))
            
            stringPath.move(to: beginPoint)
            stringPathBG.move(to: beginPoint)
            stringPath.addLine(to: endPoint)
            stringPathBG.addLine(to: endPoint)
            
            string.path = stringPath.cgPath
            stringBG.path = stringPathBG.cgPath
            strings.append(stringBG)
            self.view.layer.addSublayer(stringBG)
            
        }
        
        //Top 3 strings
        for i in (0..<3).reversed() {
            let string = CAShapeLayer()
            let stringBG = CAShapeLayer()
            
            stringBG.strokeColor = UIColor.black.cgColor
            stringBG.lineWidth = stringHeight[stringHeight.count-i-1]
            string.strokeColor = UIColor.gray.cgColor
            string.lineWidth = stringHeight[stringHeight.count-i-1]
            //string.lineDashPattern = [NSNumber(value: Int(3-i)),1]
            
            stringBG.addSublayer(string)
            
            let stringPath = UIBezierPath()
            let stringPathBG = UIBezierPath()
            
            let beginPoint = CGPoint(x: 0.0, y: ((
                
                //Offset from bottom
                    (guitarImage.frame.height * stringOffsetPercentFromBottom)) +
                
                //Subtracted by string seperation offset
                (CGFloat(jamSessionStringOffsetPercent * CGFloat(i+1)) * guitarImage.frame.height)))
            
            let endPoint = CGPoint(x: guitarImage.frame.width, y: ((guitarImage.frame.height * stringOffsetPercentFromBottom)) + (CGFloat(jamSessionStringOffsetPercent * CGFloat(i+1)) * guitarImage.frame.height))
            
            stringPath.move(to: beginPoint)
            stringPathBG.move(to: beginPoint)
            stringPath.addLine(to: endPoint)
            stringPathBG.addLine(to: endPoint)
            
            string.path = stringPath.cgPath
            stringBG.path = stringPathBG.cgPath
            strings.append(stringBG)
            self.view.layer.addSublayer(stringBG)
            
        }
    }
    
    func addHitZones() {
        if !stringHitZones.isEmpty {
            stringHitZones.removeAll()
        }
        //Need to determine hit zones
        
        // Center of guitar
        stringHitZones.append(guitarImage.center.y)
        
        //Two above zones
        stringHitZones.append(guitarImage.center.y - guitarImage.frame.height * jamSessionStringOffsetPercent)
        
        stringHitZones.append(guitarImage.center.y - guitarImage.frame.height * jamSessionStringOffsetPercent * 2)
        
        //Two below zones
        stringHitZones.append(guitarImage.center.y + guitarImage.frame.height * jamSessionStringOffsetPercent)
        
        stringHitZones.append(guitarImage.center.y + guitarImage.frame.height * jamSessionStringOffsetPercent * 2)
    
        //Edges
        stringHitZones.append(guitarImage.frame.height * guitarBottomOffsetPercent)
        stringHitZones.append(guitarImage.frame.height * (1-guitarBottomOffsetPercent))
        
        stringHitZones.sort()
        
    }
    
    func playSoundForNote(string: Int, fret: Int) {
        //TODO
    }
    
    override func viewDidLayoutSubviews() {
        
        for layer in strings {
            layer.removeFromSuperlayer()
        }
        strings.removeAll()
        addStrings()
        addHitZones()
        //self.view.layer.setNeedsDisplay()
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
