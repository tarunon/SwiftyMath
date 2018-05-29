//
//  KFHomologyTests.swift
//  Sample
//
//  Created by Taketo Sano on 2018/05/28.
//

import XCTest
@testable import SwiftyMath
@testable import SwiftyKnots

class KFHomologyTests: XCTestCase {
    func test() {
        let ps = Permutation.allPermutations(ofLength: 3)
        ps.forEach{ p in print(p.elements) } 
    }
}
