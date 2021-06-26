//
//  ViewController.swift
//  EggTimer
//
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let eggTimeDict = [
        "Soft" : 300,
        "Medium" : 420,
        "Hard": 720
    ]
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var progessBar: UIProgressView!
    
    var eggTime = 0
    var totalTime = 0
    var timer = Timer()
    var player: AVAudioPlayer?
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
    
        timer.invalidate()
        
        
        let hardnessValue = sender.currentTitle!
        
        totalTime = eggTimeDict[hardnessValue]!
        
        progessBar.progress = 0.0
        eggTime = 0
        titleLabel.text = hardnessValue
        
        startTimer()
        
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter() {
        if eggTime < totalTime {
        
            eggTime += 1
            
            let percentageProgress = Double(eggTime)/Double(totalTime)
            progessBar.progress = Float(percentageProgress)
            
        }else {
            timer.invalidate()
            
            guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }

                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                    try AVAudioSession.sharedInstance().setActive(true)

                    /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
                    player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

                    /* iOS 10 and earlier require the following line:
                    player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

                    guard let player = player else { return }

                    player.play()

                } catch let error {
                    print(error.localizedDescription)
                }
            
            titleLabel.text = "Done!"
            }
            
        }
    }
    

