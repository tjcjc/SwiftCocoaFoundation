//
//  ConcurrencySpec.swift
//  SwiftCocoaFoundationTests
//
//  Created by JasonTai on 2019/9/5.
//  Copyright © 2019 JasonTai. All rights reserved.
//

import Foundation
import Quick
import Nimble

class ConcurrencySpec: QuickSpec {
    var serialQueue: DispatchQueue!
    var concurrentQueue: DispatchQueue!
    
    override func spec() {
        beforeEach {
            self.serialQueue = DispatchQueue(label: "com.benmangguo.jasontai")
            self.concurrentQueue = DispatchQueue(label: "com.benmangguo.jasontai.concurrent", attributes: .concurrent)
        }
    }
}
