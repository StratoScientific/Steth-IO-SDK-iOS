//
//  TimeInterval+Utils.swift
//  Example
//
//  Created by alex on 8/19/23.
//  Copyright © 2023 StethIO. All rights reserved.
//

import Foundation

extension TimeInterval{
    func formatSecondsToString() -> String {
        let seconds: TimeInterval = self
        if seconds.isNaN {
            return "00:00"
        }
        let Min = Int(seconds / 60)
        let Sec = Int(seconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", Min, Sec)
    }
}
