//
//  JonesPolynomial.swift
//  SwiftyKnots
//
//  Created by Taketo Sano on 2018/04/04.
//

import Foundation
import SwiftyMath

public struct KauffmanBracket_A: Indeterminate {
    public static let symbol = "A"
}

public typealias KauffmanBracketPolynomial = LaurentPolynomial<𝐙, KauffmanBracket_A>

public extension Link {
    
    // a polynomial in 𝐙[A, 1/A]
    public var KauffmanBracket: KauffmanBracketPolynomial {
        return KauffmanBracket(normalized: false)
    }
    
    public func KauffmanBracket(normalized b: Bool) -> KauffmanBracketPolynomial {
        let A = KauffmanBracketPolynomial.indeterminate
        let B = -A.pow(2) - A.pow(-2)
        
        return allStates.sum { s -> KauffmanBracketPolynomial in
            let L = self.spliced(by: s)
            let n = L.components.count
            return A.pow(s.count0 - s.count1) * B.pow(b ? n - 1 : n)
        }
    }
}
