//
//  TomatoesTimer.swift
//  tomatoes-ios
//
//  Created by Giorgia Marenda on 1/22/17.
//  Copyright © 2017 Giorgia Marenda. All rights reserved.
//

import Foundation

enum TomatoType: UInt {
    case work = 25
    case shorBreak = 5
    case longBreak = 15
    
    var seconds: UInt {
        return rawValue * 60
    }
}

class TomatoesTimer {

    static var instance = TomatoesTimer()
    
    fileprivate var timer: Timer?
    var onTick: ((UInt, UInt) -> ())?
    var secondsCounter: UInt = 0
    
    func start(_ duration: UInt, completion: (() -> ())?) {
        secondsCounter = duration
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.secondsCounter = self.secondsCounter - 1
            let remainingMinutes = (self.secondsCounter % 3600) / 60
            let remainigSeconds = (self.secondsCounter % 3600) % 60
            self.onTick?(remainingMinutes, remainigSeconds)
            if self.secondsCounter <= 0 {
                timer.invalidate()
                completion?()
            }
        })
    }
}
