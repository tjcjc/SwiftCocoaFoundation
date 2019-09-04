//
//  EnumCodableTest.swift
//  SwiftCocoaFoundationTests
//
//  Created by JasonTai on 2019/9/5.
//  Copyright © 2019 JasonTai. All rights reserved.
//

import Foundation
import Quick
import Nimble

enum Either<A: Codable&Equatable, B: Codable&Equatable>: Codable, Equatable {
    static func == (lhs: Either<A, B>, rhs: Either<A, B>) -> Bool {
        switch (lhs, rhs) {
        case let (.left(v1), .left(v2)):
            return v1 == v2
        case let (.right(v1), .right(v2)):
            return v1 == v2
        default:
            return false
        }
    }

    case left(A)
    case right(B)

    private enum CodingKeys: CodingKey {
        case left
        case right
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .left(value):
            try container.encode(value, forKey: .left)
        case let .right(value):
            try container.encode(value, forKey: .right)
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try container.decodeIfPresent(A.self, forKey: .left) {
            self = .left(value)
        } else {
            let value = try container.decode(B.self, forKey: .right)
            self = .right(value)
        }
    }
}

class EnumCodableTest: QuickSpec {
    override func spec() {
        it ("test enum codable") {
            let array: [Either<String, Int16>] = [Either.left("Test"), Either.right(Int16(5))]
            let encoder = JSONEncoder()
            let data = try! encoder.encode(array)
            let dencodeData = try! JSONDecoder().decode([Either<String, Int16>].self, from: data)
            print(dencodeData[0])
            print(dencodeData[1])
            expect(array).to(contain(dencodeData[0], dencodeData[1]))
            expect(array) == dencodeData
        }
    }
}
