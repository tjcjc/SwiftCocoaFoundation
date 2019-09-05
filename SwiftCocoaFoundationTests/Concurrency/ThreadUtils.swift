//
//  ThreadUtils.swift
//  SwiftCocoaFoundationTests
//
//  Created by JasonTai on 2019/9/5.
//  Copyright © 2019 JasonTai. All rights reserved.
//

import Foundation

struct ThreadUtils {
    static func sleepSecond(_ second: Double) {
        Thread.sleep(until: Date().addingTimeInterval(second))
    }
}
