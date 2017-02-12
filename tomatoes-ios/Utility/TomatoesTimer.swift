//
//  TomatoesTimer.swift
//  tomatoes-ios
//
//  Created by Giorgia Marenda on 1/22/17.
//  Copyright © 2017 Giorgia Marenda. All rights reserved.
//

import Foundation

enum TomatoType: TimeInterval {
    case work = 25
    case shortBreak = 5
    case longBreak = 15
    
    var seconds: TimeInterval {
        return rawValue * 60
    }
    var notificationTitle: String {
        switch self {
        case .work: return "Good job! It's time to take a break."
        default: return "Let's get back to work."
        }
    }
}

class TomatoesTimer {

    static var instance = TomatoesTimer()
    
    fileprivate var timer: Timer?
    var onTick: ((UInt, UInt) -> ())?
    var onFire: (() -> ())?
    var secondsCounter: TimeInterval = 0
    
    func start(_ duration: TimeInterval, completion: (() -> ())?) {
        secondsCounter = duration
        onFire = completion
        
        DispatchQueue.global().async {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TomatoesTimer.instance.timerFired), userInfo: nil, repeats: true)
            if let timer = self.timer {
                RunLoop.current.add(timer, forMode: .commonModes)
                RunLoop.current.run()
            }
        }
    }
    
    @objc func timerFired() {
        DispatchQueue.main.async {
            print("\(self.secondsCounter)")
            self.secondsCounter = self.secondsCounter - 1
            let remainingMinutes = (UInt(self.secondsCounter) % 3600) / 60
            let remainigSeconds = (UInt(self.secondsCounter) % 3600) % 60
            self.onTick?(remainingMinutes, remainigSeconds)
            if self.secondsCounter <= 0 {
                self.timer?.invalidate()
                self.onFire?()
            }
        }
    }
    
    func stop() {
        secondsCounter = 0
        timer?.invalidate()
        timer = nil
    }
}
