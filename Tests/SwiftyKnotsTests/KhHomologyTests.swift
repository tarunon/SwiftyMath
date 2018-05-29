//
//  KHTests.swift
//  SwiftyKnots
//
//  Created by Taketo Sano on 2018/04/04.
//

import XCTest
import SwiftyMath
@testable import SwiftyKnots

class KhHomologyTests: XCTestCase {
    
    func test() {
        Logger.activate(.storage)
        Storage.setDir("/Users/taketo/Projects/SwiftyMath/Data/")
        
        let skip = ["K11a279", "K11a308", "K11a346", "K11a358", "K11n155", "K11n169"]
        for K in Link.list(.knot, crossing: 3 ... 11) {
            if skip.contains(K.name) {
                continue
            }
            
            let Kh = K.KhHomology(𝐙.self, useCache: true)
            XCTAssertEqual(Kh.qEulerCharacteristic, K.JonesPolynomial(normalized: false))
            
            print(K.name)
            Kh.printTable()
            print()
        }
    }
    
    func test3_1_Z() {
        let K = Knot(3, 1)
        let Kh = K.KhHomology(𝐙.self)
        
        XCTAssertEqual(Kh.qEulerCharacteristic, K.JonesPolynomial(normalized: false))
        
        XCTAssertEqual(Kh.bidegrees.count, 5)
        XCTAssertEqual(Kh[-3, -9]!.structure, [0 : 1])
        XCTAssertEqual(Kh[-2, -7]!.structure, [2 : 1])
        XCTAssertEqual(Kh[-2, -5]!.structure, [0 : 1])
        XCTAssertEqual(Kh[-0, -3]!.structure, [0 : 1])
        XCTAssertEqual(Kh[-0, -1]!.structure, [0 : 1])
    }
    
    func test4_1_Z() {
        let K = Knot(4, 1)
        let Kh = K.KhHomology(𝐙.self)
        
        XCTAssertEqual(Kh.qEulerCharacteristic, K.JonesPolynomial(normalized: false))
        
        XCTAssertEqual(Kh.bidegrees.count, 8)
        XCTAssertEqual(Kh[-2, -5]!.structure, [0 : 1])
        XCTAssertEqual(Kh[-1, -3]!.structure, [2 : 1])
        XCTAssertEqual(Kh[-1, -1]!.structure, [0 : 1])
        XCTAssertEqual(Kh[ 0, -1]!.structure, [0 : 1])
        XCTAssertEqual(Kh[ 0, -1]!.structure, [0 : 1])
        XCTAssertEqual(Kh[ 1,  1]!.structure, [0 : 1])
        XCTAssertEqual(Kh[ 2,  3]!.structure, [2 : 1])
        XCTAssertEqual(Kh[ 2,  5]!.structure, [0 : 1])
    }
    
    func test5_1_Z() {
        let K = Knot(5, 1)
        let Kh = K.KhHomology(𝐙.self)
        
        XCTAssertEqual(Kh.bidegrees.count, 8)
        XCTAssertEqual(Kh[-5, -15]!.structure, [0 : 1])
        XCTAssertEqual(Kh[-4, -13]!.structure, [2 : 1])
        XCTAssertEqual(Kh[-4, -11]!.structure, [0 : 1])
        XCTAssertEqual(Kh[-3, -11]!.structure, [0 : 1])
        XCTAssertEqual(Kh[-2,  -9]!.structure, [2 : 1])
        XCTAssertEqual(Kh[-2,  -7]!.structure, [0 : 1])
        XCTAssertEqual(Kh[ 0,  -5]!.structure, [0 : 1])
        XCTAssertEqual(Kh[ 0,  -3]!.structure, [0 : 1])

    }
}
