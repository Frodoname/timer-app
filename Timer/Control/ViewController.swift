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
    var timeModel = TimeModel()
    var timerBrain = TimerBrain()
    var timer = Timer()
    
    var timeLeft = 0
    var alarmIsPlaying = false
    let alarmSound: SystemSoundID = 1304
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var timerPicker: UIPickerView!
    @IBOutlet weak var labelTime: UILabel!
    
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
        stopButton.isEnabled = false
        
        timerPicker.delegate = self
        timerPicker.dataSource = self
        
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        if sender.currentTitle == "Pause" {
            timer.invalidate()
            startButton.setTitle("Resume", for: .normal)
        } else if sender.currentTitle == "Resume" {
            forTimerGo()
            startButton.setTitle("Pause", for: .normal)
        } else {
            startButton.isEnabled = true
            stopButton.isEnabled = true
            alarmIsPlaying = true
            stopButton.setTitle("Cancel", for: .normal)
            timeLeft = self.timerBrain.countTime(timeLeft: self.timeModel)
            timer.invalidate()
            forTimerGo()
        }
    }
    
    @IBAction func stopButton(_ sender: UIButton) {
        if sender.currentTitle == "Cancel" {
            stopButton.isEnabled = false
            startButton.setTitle("Start", for: .normal)
            startButton.layer.backgroundColor = UIColor.black.cgColor
            startButton.layer.borderColor = UIColor.green.cgColor
            timer.invalidate()
            labelTime.text = "00:00:00"
            
        } else if sender.currentTitle == "Stop" {
            stopButton.isEnabled = false
            startButton.isEnabled = true
            
            alarmIsPlaying = false
            
        }
            timer.invalidate()
    }
    //MARK: - TimerFunc
    
    func forTimerGo() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [unowned self]
            timer in
            if timeLeft > 0 {
                startButton.setTitle("Pause", for: .normal)
                startButton.layer.backgroundColor = UIColor(red: 255.0/255.0, green: 167.0/255.0, blue: 34.0/255.0, alpha: 0.2).cgColor
                timerBrain.formateTime(forFormat: timeLeft)
                labelTime.text = String(format: "%02i:%02i:%02i", timerBrain.hourFormated, timerBrain.minFormatted, timerBrain.secFormatted)
                timeLeft -= 1
            } else {
                timer.invalidate()
                stopButton.setTitle("Stop", for: .normal)
                startButton.setTitle("Start", for: .normal)
                startButton.layer.backgroundColor = UIColor.black.cgColor
                startButton.layer.borderColor = UIColor.green.cgColor
                labelTime.text = "00:00:00"
                playAlarm()
                startButton.isEnabled = false
            }
        })
        
    }
    
//MARK: - playSoundFunc
    
    func playAlarm() {
        AudioServicesPlayAlertSoundWithCompletion(alarmSound) {
            if self.alarmIsPlaying == true  {
                self.playAlarm()
                } else  {
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
            return timeData.minutes.count
        case 2:
            return timeData.seconds.count
        default:
            return timeData.hours.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 1:
            return "\(timeData.minutes[row]) min"
        case 2:
            return "\(timeData.seconds[row]) sec"
        default:
            return "\(timeData.hours[row]) hours"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 1:
            timeModel.min = row
        case 2:
            timeModel.sec = row
        default:
            timeModel.hour = row
        }
        
    }
}


