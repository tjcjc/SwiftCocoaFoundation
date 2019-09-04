//
//  TestProtobuf.swift
//  SwiftCocoaFoundationTests
//
//  Created by JasonTai on 2019/9/4.
//  Copyright © 2019 JasonTai. All rights reserved.
//

import Foundation
import Quick
import Nimble

class TestProtobuf: QuickSpec {
    override func spec() {
        var book: BookInfo!
        describe("base model") {
            beforeEach {
                book = BookInfo.with {
                    $0.author = "author"
                    $0.id = 10
                    $0.title = "book name"
                }
            }

            it("Bookinfo") {
                let bookData: Data = try! book.serializedData()
                let decodeBook: BookInfo = try! BookInfo(serializedData: bookData)
                expect(decodeBook.author) == "author"
                expect(decodeBook.author) == "author"
            }

            it("User") {
                let user: User = User.with {
                    $0.name = "user1"
                    $0.books.append(book)
                    $0.selectedBooks["fav"] = book
                }

                let userData: Data = try! user.serializedData()
                let decodeUser: User = try! User(serializedData: userData)
                expect(decodeUser.name) == "user1"
                expect(decodeUser.books) == [book]
                expect(decodeUser.selectedBooks["fav"]) == book
            }
        }
    }
}
