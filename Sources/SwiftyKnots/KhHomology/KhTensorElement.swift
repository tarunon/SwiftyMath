//
//  KHBasis.swift
//  SwiftyKnots
//
//  Created by Taketo Sano on 2018/04/04.
//

import Foundation
import SwiftyMath

public struct KhTensorElement: BasisElementType, Comparable, Codable {
    public let state: KauffmanState
    internal let factors: [KhBasisElement]
    
    public static func generateBasis(state: KauffmanState, power n: Int) -> [KhTensorElement] {
        return (0 ..< n).reduce([[]]) { (res, _) -> [[KhBasisElement]] in
            res.flatMap{ factors -> [[KhBasisElement]] in
                [factors + [.I], factors + [.X]]
            }
            }
            .map{ factors in KhTensorElement.init(state: state, factors: factors) }
            .sorted()
    }
    
    internal init(state: KauffmanState, factors: [KhBasisElement]) {
        self.state = state
        self.factors = factors
    }
    
    public var degree: Int {
        return factors.sum{ e in e.degree } + state.degree
    }
    
    internal func product<R: Ring>(_ μ: KhBasisElement.Product<R>, _ from: (Int, Int), _ to: Int, _ toState: KauffmanState) -> FreeModule<KhTensorElement, R> {
        let (i1, i2) = from
        let (e1, e2) = (factors[i1], factors[i2])
        
        return μ(e1, e2).sum { (e, a) in
            var toFactors = factors
            toFactors.remove(at: i2)
            toFactors.remove(at: i1)
            toFactors.insert(e, at: to)
            return FreeModule( KhTensorElement(state: toState, factors: toFactors), a )
        }
    }
    
    internal func coproduct<R: Ring>(_ Δ: KhBasisElement.Coproduct<R>, _ from: Int, _ to: (Int, Int), _ toState: KauffmanState) -> FreeModule<KhTensorElement, R> {
        let (j1, j2) = to
        let e = factors[from]
        
        return Δ(e).sum { (e1, e2, a) -> FreeModule<KhTensorElement, R> in
            var toFactors = factors
            toFactors.remove(at: from)
            toFactors.insert(e1, at: j1)
            toFactors.insert(e2, at: j2)
            return FreeModule( KhTensorElement(state: toState, factors: toFactors), a )
        }
    }
    
    public func stateModified(_ i: Int, _ bit: KauffmanState.Bit?) -> KhTensorElement {
        var s = state
        if let bit = bit {
            s[i] = bit
        } else {
            s.unset(i)
        }
        return KhTensorElement(state: s, factors: factors)
    }
    
    public static func ==(b1: KhTensorElement, b2: KhTensorElement) -> Bool {
        return b1.state == b2.state && b1.factors == b2.factors
    }
    
    public static func <(b1: KhTensorElement, b2: KhTensorElement) -> Bool {
        return (b1.state < b2.state)
            || (b1.state == b2.state && b1.factors.lexicographicallyPrecedes(b2.factors) )
    }
    
    public var hashValue: Int {
        return factors.reduce(0) { (res, e) in
            res &<< 2 | (e == .I ? 2 : 1)
        }
    }
    
    public var description: String {
        return factors.map{ "\($0)" }.joined(separator: "⊗") + Format.sub(state.description)
    }
}
