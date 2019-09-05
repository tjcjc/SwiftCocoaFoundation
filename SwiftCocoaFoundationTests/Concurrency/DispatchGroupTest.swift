//
//  DispatchGroupTest.swift
//  SwiftCocoaFoundationTests
//
//  Created by JasonTai on 2019/9/5.
//  Copyright © 2019 JasonTai. All rights reserved.
//

import Foundation
import Quick
import Nimble

class DispatchGroupTest: ConcurrencySpec {
    override func spec() {
        super.spec()
        var group = DispatchGroup()
        beforeEach {
            group = DispatchGroup()
        }
        describe("group") {
            testNotifyAndWait(group: group)
            testEnterAndLeave(group: group)
        }
    }

    func testNotifyAndWait(group: DispatchGroup) {
        it("notify") {
            var r = 1
            self.serialQueue.async(group: group) { r += 1 }
            self.concurrentQueue.async(group: group) { r += 1 }
            group.notify(queue: DispatchQueue.main) { r = 100 }

            expect(r).toEventually(equal(100))
        }

        it("wait") {
            var state = "begin"
            self.concurrentQueue.async(group: group) {
                ThreadUtils.sleepSecond(5)
                state = "task1 end"
            }
            self.concurrentQueue.async(group: group) {
                ThreadUtils.sleepSecond(2)
                state = "task2 end"
            }
            if group.wait(timeout: .now() + 3) == .timedOut {
                if state == "task2 end" {
                    state = "timeout"
                } else {
                    state = "timeout error"
                }
            } else {
                state = "all done"
            }
            expect(state).toEventually(equal("timeout"))
            if group.wait(timeout: .now() + 6) == .timedOut {
                if state == "task2 end" {
                    state = "timeout"
                } else {
                    state = "timeout error"
                }
            } else {
                state = "all done"
            }
            expect(state).toEventually(equal("all done"), timeout: 7)
        }
    }

    func testEnterAndLeave(group: DispatchGroup) {
        describe("enter and leave") {
            var count = 1
            var state = ""

            beforeEach {
                count = 1
                state = ""
            }

            it("without command") {
                self.concurrentQueue.async(group: group) { [weak self] in
                    count = 2
                    self?.serialQueue.async {
                        ThreadUtils.sleepSecond(2)
                        count = 1
                    }
                }
                group.notify(queue: DispatchQueue.main) {
                    state = count == 1 ? "success" : "fail"
                }
                expect(state).toEventually(equal("fail"))
            }

            it("with command") {
                self.concurrentQueue.async(group: group) { [weak self] in
                    count = 2
                    group.enter()
                    self?.concurrentQueue.async {
                        defer { group.leave() }

                        ThreadUtils.sleepSecond(2)
                        count = 1
                    }
                }
                group.notify(queue: DispatchQueue.main) {
                    state = count == 1 ? "success" : "fail"
                }
                expect(state).toEventually(equal("success"), timeout: 3)
            }
        }
    }
}
