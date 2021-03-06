//
//  SimpleModuleStructureTests.swift
//  SwiftyMathTests
//
//  Created by Taketo Sano on 2018/04/23.
//

import XCTest
@testable import SwiftyMath

class SimpleModuleStructureTests: XCTestCase {
    
    typealias A = AbstractBasisElement
    typealias R = 𝐙
    typealias M = FreeModule<A, R>
    typealias S = SimpleModuleStructure<A, R>

    func testFree() {
        let basis = (0 ..< 3).map{ A($0) }
        let a = M(basis: basis, components: [1, 0, 0])
        let b = M(basis: basis, components: [0, 1, 0])
        let c = M(basis: basis, components: [0, 0, 1])
        
        let str = S(generators: [a, b, c])
        
        XCTAssertEqual(str.rank, 3)
        XCTAssertEqual(str.factorize(a), [1, 0, 0])
        XCTAssertEqual(str.factorize(b), [0, 1, 0])
        XCTAssertEqual(str.factorize(c), [0, 0, 1])
    }
    
    func testFreeSub() {
        let basis = (0 ..< 3).map{ A($0) }
        let a = M(basis: basis, components: [1, 1, 0])
        let b = M(basis: basis, components: [0, 0, 1])
        
        let str = S(generators: [a, b])
        
        XCTAssertEqual(str.rank, 2)
        XCTAssertEqual(str.factorize(a), [1, 0])
        XCTAssertEqual(str.factorize(b), [0, 1])
        XCTAssertEqual(str.factorize(a + 2 * b), [1, 2])
    }
    
    func testDiagonalRelation() {
        let basis = (0 ..< 3).map{ A($0) }
        let a = M(basis: basis, components: [1, 0, 0])
        let b = M(basis: basis, components: [0, 1, 0])
        let c = M(basis: basis, components: [0, 0, 1])
        
        let matrix = Matrix<R>(rows: 3, cols: 2, grid:
            [1, 0,
             0, 2,
             0, 0]
        )
        
        let str = S(generators: [a, b, c], relationMatrix: matrix)
        
        XCTAssertEqual(str.rank, 1)
        XCTAssertEqual(str.torsionCoeffs, [2])
        
        XCTAssertEqual(str.generator(0), b)
        XCTAssertEqual(str.generator(1), c)
        
        XCTAssertEqual(str.factorize(a), [0, 0])
        XCTAssertEqual(str.factorize(b), [1, 0])
        XCTAssertEqual(str.factorize(2 * b), [0, 0])
        XCTAssertEqual(str.factorize(c), [0, 1])
        XCTAssertEqual(str.factorize(2 * c), [0, 2])
    }
    
    func testCrossRelation() {
        let basis = (0 ..< 3).map{ A($0) }
        let a = M(basis: basis, components: [1, 0, 0])
        let b = M(basis: basis, components: [0, 1, 0])
        let c = M(basis: basis, components: [0, 0, 1])

        let matrix = Matrix<R>(rows: 3, cols: 2, grid:
            [1, 1,
             1, 0,
             0, -1]
        )
        let str = S(generators: [a, b, c], relationMatrix: matrix)
        
        XCTAssertEqual(str.rank, 1)
        XCTAssertEqual(str.generator(0), a)
        
        XCTAssertEqual(str.factorize(a), [1])
        XCTAssertEqual(str.factorize(b), [-1])
        XCTAssertEqual(str.factorize(c), [1])
    }
    
    func testSubsummands() {
        let basis = (0 ..< 3).map{ A($0) }
        let matrix = Matrix<R>(rows: 3, cols: 2, grid:[2, 0, 0, 4, 0, 0])
        let str = S(generators: basis, relationMatrix: matrix)
        let sub0 = str.subSummands(0)
        let sub1 = str.subSummands(1)
        let sub2 = str.subSummands(2)

        XCTAssertEqual(sub0.generator(0), M(basis[0]))
        XCTAssertEqual(sub0.torsionCoeffs, [2])
        XCTAssertEqual(sub0.factorize(M(basis[0])), [1])
        
        XCTAssertEqual(sub1.generator(0), M(basis[1]))
        XCTAssertEqual(sub1.torsionCoeffs, [4])
        XCTAssertEqual(sub1.factorize(M(basis[1])), [1])

        XCTAssertEqual(sub2.generator(0), M(basis[2]))
        XCTAssertTrue (sub2.isFree)
        XCTAssertEqual(sub2.factorize(M(basis[2])), [1])
    }
    
    func testAbstract() {
        let str = S(rank: 1, torsions: [2, 3])
        XCTAssertEqual(str.rank, 1)
        XCTAssertEqual(str.torsionCoeffs, [2, 3])
    }
}
