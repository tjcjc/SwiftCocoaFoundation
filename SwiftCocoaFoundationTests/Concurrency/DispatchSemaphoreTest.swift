//
//  DispatchSemaphoreTest.swift
//  SwiftCocoaFoundationTests
//
//  Created by JasonTai on 2019/9/5.
//  Copyright © 2019 JasonTai. All rights reserved.
//

import Foundation
import Quick
import Nimble

class DispatchSemaphoreTest: ConcurrencySpec {
    override func spec() {
        super.spec()
        it("semaphore") {
            var locker = DispatchSemaphore(value: 2)
            var state = ""
            var counter = 0
            for _ in 0 ..< 6 {
                self.concurrentQueue.async {
                    locker.wait()
                    counter += 1
                    defer { locker.signal() }

                    state = "task\(counter)"
                    ThreadUtils.sleepSecond(2)
                }
            }

            expect(state).toEventually(equal("task2"), timeout: 1)
            expect(state).toEventually(equal("task4"), timeout: 3)
        }
    }
}
