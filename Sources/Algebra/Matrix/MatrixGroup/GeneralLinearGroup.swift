//
//  GL.swift
//  SwiftyAlgebra
//
//  Created by Taketo Sano on 2018/03/16.
//  Copyright © 2018年 Taketo Sano. All rights reserved.
//

import Foundation

public struct GeneralLinearGroup<n: _Int, K: Field>: MatrixGroup {
    public typealias Size = n
    public typealias CoeffField = K
    
    private let g: Matrix<n, n, K>
    public init(_ g: Matrix<n, n, K>) { self.g = g }
    public var asMatrix: Matrix<n, n, K> {  return g }
    
    public static var symbol: String  {
        return "GL(\(n.intValue), \(K.symbol))"
    }
}

public struct SpecialLinearGroup<n: _Int, K: Field>: MatrixSubgroup {
    public typealias Super = GeneralLinearGroup<n, K>
    
    private let g: Matrix<n, n, K>
    public init(_ g: Matrix<n, n, K>) { self.g = g }
    public var asMatrix: Matrix<n, n, K> { return g }
    public var asSuper: Super { return Super(asMatrix) }
    
    public static func contains(_ g: GeneralLinearGroup<n, K>) -> Bool {
        return g.determinant == .identity
    }
}