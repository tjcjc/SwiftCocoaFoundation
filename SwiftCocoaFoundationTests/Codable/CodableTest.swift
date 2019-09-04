//
//  CodableTest.swift
//  SwiftCocoaFoundationTests
//
//  Created by JasonTai on 2019/9/4.
//  Copyright © 2019 JasonTai. All rights reserved.
//

import Quick
import Nimble
import Foundation

struct Coordinate: Codable {
    var latitidue: Double
    var longtitude: Double
}

struct Place: Codable {
    var coordinate: Coordinate
    var name: String
}

class CodableTest: QuickSpec {
    override func spec() {
        var coordinate: Coordinate!
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        describe("base") {
            beforeEach {
                coordinate = Coordinate(latitidue: 1.0, longtitude: 2.0)
            }

            it("No Nest") {
                let jsonData = try! encoder.encode(coordinate)
                let decodeData = try! decoder.decode(Coordinate.self, from: jsonData)
                expect(decodeData.latitidue) == coordinate.latitidue
            }

            it("Nest") {
                let place: Place = Place(coordinate: coordinate, name: "China")
                let jsonData = try! encoder.encode(place)
                let decodeData = try! decoder.decode(Place.self, from: jsonData)
                expect(decodeData.name) == place.name
                expect(decodeData.coordinate.latitidue) == coordinate.latitidue
            }
        }
    }
}
