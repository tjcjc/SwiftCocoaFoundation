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

    private enum CodingKeys: String, CodingKey {
        case name = "nickname"
        case coordinate
    }
}

struct PlaceNoName: Codable {
    var coordinate: Coordinate?
    var name: String = "NoName"

    private enum CodingKeys: String, CodingKey {
        case coordinate
    }

    init(coordinate: Coordinate, name: String) {
        self.coordinate = coordinate
        self.name = name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.coordinate = try container.decodeIfPresent(Coordinate.self, forKey: .coordinate)
        } catch {
            self.coordinate = nil
        }
    }
}


struct NoCodableCoordinate {
    var latitidue: Double
    var longtitude: Double
}

struct PlaceWithNoCodable: Codable {
    var name: String
    var coordinate: NoCodableCoordinate

    private enum CodingKeys: CodingKey {
        case coordinate
        case name
    }

    private enum CoordinateCodingKeys: CodingKey {
        case latitude
        case longtitude
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var coordinateContainer = container.nestedContainer(keyedBy: CoordinateCodingKeys.self, forKey: .coordinate)
        try container.encode(name, forKey: .name)
        try coordinateContainer.encode(coordinate.latitidue, forKey: .latitude)
        try coordinateContainer.encode(coordinate.longtitude, forKey: .longtitude)
    }

    init(coordinate: NoCodableCoordinate, name: String) {
        self.coordinate = coordinate
        self.name = name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        let coordinateContainer = try container.nestedContainer(keyedBy: CoordinateCodingKeys.self, forKey: .coordinate)
        self.coordinate = NoCodableCoordinate(
            latitidue: try coordinateContainer.decode(Double.self, forKey: .latitude),
            longtitude: try coordinateContainer.decode(Double.self, forKey: .longtitude))
    }
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

//        public protocol Encoder {
//            /// 编码过程中到当前点的编码键路径。
//            var codingPath: [CodingKey] { get }
//            /// 用户为编码设置的上下文信息。
//            var userInfo: [CodingUserInfoKey : Any] { get }
//            /// 返回一个合适用来存放以给定键类型为键的多个值的编码容器。
//            func container<Key: CodingKey>(keyedBy type: Key.Type)
//                -> KeyedEncodingContainer<Key>
//            /// 返回一个合适用来存放多个无键值的编码容器。
//            func unkeyedContainer() -> UnkeyedEncodingContainer
//            /// 返回一个合适用来存放一个原始值的编码容器。
//            func singleValueContainer() -> SingleValueEncodingContainer
//        }
//        extension Array: Encodable where Element: Encodable {
//            public func encode(to encoder: Encoder) throws {
//                var container = encoder.unkeyedContainer()
//                for element in self {
//                    try container.encode(element)
//                }
//            }
//        }
        describe("container") {
            it("Keyed container") {
            }

            it("Unkeyed container") {
            }

            it("single value container") {

            }
        }

        describe("Coding Keys") {
            it("change key in json") {
                let place: Place = Place(coordinate: coordinate, name: "China")
                let jsonData = try! encoder.encode(place)
                let jsonStr: String! = String(data: jsonData, encoding: .utf8)
                expect(jsonStr).to(contain("nickname"))
                expect(jsonStr).to(contain("coordinate"))
            }

            it("use default name") {
                let place: PlaceNoName = PlaceNoName(coordinate: coordinate, name: "China")
                let jsonData = try! encoder.encode(place)
                let jsonStr: String! = String(data: jsonData, encoding: .utf8)
                expect(jsonStr.range(of: "name")).to(beNil())
                expect(jsonStr).to(contain("coordinate"))

                let decodeData: PlaceNoName = try! decoder.decode(PlaceNoName.self, from: jsonData)
                expect(decodeData.name) == "NoName"
            }

            it("lost key") {
                let inputData: Data! = "{}".data(using: .utf8)
                let decodeData: PlaceNoName = try! decoder.decode(PlaceNoName.self, from: inputData)
                expect(decodeData.name) == "NoName"
                expect(decodeData.coordinate).to(beNil())
            }
        }

        it("with not codable variable") {
            let coordinate = NoCodableCoordinate(latitidue: 1.0, longtitude: 2.0)
            let place: PlaceWithNoCodable = PlaceWithNoCodable(coordinate: coordinate, name: "China")
            let jsonData = try! encoder.encode(place)
            let jsonStr: String! = String(data: jsonData, encoding: .utf8)

            expect(jsonStr).to(contain("coordinate"))
            expect(jsonStr).to(contain("name"))
        }
    }
}
