//
//  ViewController.swift
//  Timer
//
//  Created by Fed on 11.05.2022.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var timeData = TimeData()
    var timer = Timer()
    let systemSound: SystemSoundID = 1304
    var player = AVAudioPlayer()

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var timerPicker: UIPickerView!
    @IBOutlet weak var labelTime: UILabel!
    
    
    
    var sec = 0
    var min = 0
    var hour = 0
    
    var secFormatted = 0
    var minFormatted = 0
    var hourFormated = 0
    
    var number = 1
    
    var timeRemain = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.cornerRadius = startButton.frame.width / 2
        startButton.layer.masksToBounds = true
        startButton.layer.borderWidth = 1
        startButton.layer.borderColor = UIColor.green.cgColor
        
        stopButton.layer.cornerRadius = stopButton.frame.width / 2
        stopButton.layer.masksToBounds = true
        stopButton.layer.borderWidth = 1
        stopButton.layer.borderColor = UIColor.red.cgColor
        
        timerPicker.delegate = self
        timerPicker.dataSource = self
        
        stopButton.isSelected = true
    }
    
   
    
    @IBAction func startButton(_ sender: UIButton) {
        
        stopButton.isSelected = false
        
        number = 1
        
        stopButton.setTitle("Cancel", for: .normal)
        
        countTime(min: min, sec: sec, hour: hour)
        
        timer.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [unowned self]
            timer in
            if self.timeRemain > 0 {
                hourFormated = timeRemain / 3600
                minFormatted = (timeRemain % 3600) / 60
                secFormatted = timeRemain % 60
                labelTime.text = "\(hourFormated):\(minFormatted):\(secFormatted)"
                self.timeRemain -= 1
                print(timeRemain)
            } else {
            timer.invalidate()
            stopButton.setTitle("Stop", for: .normal)
           
            print("end")
            labelTime.text = "00:00"
            playSound(soundName: systemSound)
            
            }
        })
        
    }
    
    @IBAction func stopButton(_ sender: UIButton) {
        if sender.currentTitle == "Cancel" {
            timer.invalidate()
            labelTime.text = "00:00"
            
        }
        timer.invalidate()
        number = 0
    }
    
    func countTime(min: Int, sec: Int, hour: Int) {
        
        timeRemain = min * 60 + sec + hour * 3600
    }
    
    func playSound(soundName: SystemSoundID)  {
        
            AudioServicesPlayAlertSoundWithCompletion(soundName) {
                if self.number > 0 {
                    self.playSound(soundName: soundName)
                } else {
                    return
                }
            }
    }
}

//MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 1:
            return timeData.munites.count
        case 2:
            return timeData.seconds.count
        default:
            return timeData.hours.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 1:
            return "\(timeData.munites[row]) min"
        case 2:
            return "\(timeData.seconds[row]) sec"
        default:
            return "\(timeData.hours[row]) hours"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 1:
            min = row
        case 2:
            sec = row
        default:
            hour = row
        }
    }
    
}
