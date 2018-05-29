//
//  KnotFloearHomology.swift
//  Sample
//
//  Created by Taketo Sano on 2018/05/28.
//

import Foundation
import SwiftyMath
import SwiftyHomology

public struct GridDiagram {
    public typealias Point = (Int, Int)
    
    public let Os: [Point]
    public let Xs: [Point]
    
    public init(_ Os: [Point], _ Xs: [Point]) {
        assert(Os.count == Xs.count)
        
        assert(Os.map{ (i, _) in i }.isUnique)
        assert(Os.map{ (_, j) in j }.isUnique)
        assert(Xs.map{ (i, _) in i }.isUnique)
        assert(Xs.map{ (_, j) in j }.isUnique)
        
        assert(Os.forAll{ (i, j) in !i.isEven && !j.isEven } )
        assert(Xs.forAll{ (i, j) in !i.isEven && !j.isEven } )

        let n = Os.count
        
        assert(Os.forAll{ (i, _) in (0 ..< 2 * n).contains(i) })
        assert(Os.forAll{ (_, j) in (0 ..< 2 * n).contains(j) })
        assert(Xs.forAll{ (i, _) in (0 ..< 2 * n).contains(i) })
        assert(Xs.forAll{ (_, j) in (0 ..< 2 * n).contains(j) })

        self.Os = Os
        self.Xs = Xs
    }
    
    public var size: Int {
        return Os.count
    }
    
    public var generators: [[Point]] {
        let n = size
        return Permutation
            .allPermutations(ofLength: n)
            .map{ p  in (0 ..< n).map{ i in (2 * i, 2 * p[i]) } }
    }
    
    public func I(_ A: [Point], _ B: [Point]) -> Int {
        return A.allCombinations(with: B).count{ (a, b) in
            a.0 < b.0 && a.1 < b.1
        }
    }
    
    public func J(_ A: [Point], _ B: [Point]) -> Int {
        return (I(A, B) + I(B, A)) / 2
    }

    // the Maslov grading
    public func M(_ x: [Point]) -> Int {
        return J(x, x) - 2 * J(x, Os) + J(Os, Os) + 1
    }
    
    // the Alexander grading
    public func A(_ x: [Point]) -> Int {
        return ( 2 * J(x, Xs) - 2 * J(x, Os) - J(Xs, Xs) + J(Os, Os) - (size - 1) ) / 2
    }
    
    public struct U: Indeterminate {
        public static let symbol = "U"
        public static let degree = -2
    }
    
    public func d(_ x: [Point]) -> Polynomial<𝐙₂, U> {
        
    }
}
