//
//  TimerBrain.swift
//  Timer
//
//  Created by Fed on 11.05.2022.
//

import Foundation
import AVFoundation

struct TimerBrain {
   
    var secFormatted = 0
    var minFormatted = 0
    var hourFormated = 0
    
    
    
    mutating func countTime(timeLeft: TimeModel) -> Int {
        return timeLeft.hour * 3600 + timeLeft.min * 60 + timeLeft.sec
    }
    
    mutating func formateTime(forFormat: Int) {
        hourFormated = forFormat / 3600
        minFormatted = (forFormat % 3600) / 60
        secFormatted = forFormat % 60
    }
    
}
