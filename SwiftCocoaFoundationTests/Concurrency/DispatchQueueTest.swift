//
//  DispatchQueueTest.swift
//  SwiftCocoaFoundationTests
//
//  Created by JasonTai on 2019/9/5.
//  Copyright © 2019 JasonTai. All rights reserved.
//

import Foundation
import Quick
import Nimble

class DispatchQueueTest: ConcurrencySpec {
    override func spec() {
        super.spec()
        var targetResult = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        beforeEach {
            targetResult = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        }

        func constructArrayAsync(queue: DispatchQueue, callback: @escaping (Int) -> Void) {
            for i in 0..<10 {
                queue.async {
                    callback(i)
                }
            }
        }

        func constructArray(queue: DispatchQueue, callback: @escaping (Int) -> Void) {
            for i in 0..<10 {
                queue.sync {
                    callback(i)
                }
            }
        }

        describe("test serial queue") {
            it ("async") {
                var r: [Int] = []
                constructArrayAsync(queue: self.serialQueue) { r.append($0) }

                expect(r).toEventually(equal(targetResult), timeout: 2)
            }
        }

        describe("test concurrent queue") {
            it ("async") {
//                var r: [Int] = []
//                constructArrayAsync(queue: self.concurrentQueue) { r.append($0) }
//
//                expect(r).toEventuallyNot(equal(targetResult), timeout: 2)
            }

            it ("sync") {
                var r: [Int] = []
                constructArray(queue: self.concurrentQueue) { r.append($0) }

                expect(r).toEventually(equal(targetResult), timeout: 2)
            }
        }
    }
}
