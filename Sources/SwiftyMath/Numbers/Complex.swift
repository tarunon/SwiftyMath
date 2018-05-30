//
//  Complex.swift
//  SwiftyMath
//
//  Created by Taketo Sano on 2018/03/16.
//  Copyright © 2018年 Taketo Sano. All rights reserved.
//

protocol A{}
struct S<X> {}

extension S: A where X == Int {}
extension S: A where X == String {}

import Foundation

public typealias ComplexNumber = Complex<𝐑>
public typealias 𝐂 = ComplexNumber

public struct Complex<R: Ring>: Ring {
    private let x: R
    private let y: R
    
    public init(from x: 𝐙) {
        self.init(R(from: x))
    }
    
    public init(_ x: R) {
        self.init(x, .zero)
    }
    
    public init(_ x: R, _ y: R) {
        self.x = x
        self.y = y
    }
    
    public static var imaginaryUnit: Complex<R> {
        return Complex(.zero, .identity)
    }
    
    public var realPart: R {
        return x
    }
    
    public var imaginaryPart: R {
        return y
    }
    
    public var conjugate: Complex<R> {
        return Complex(x, -y)
    }

    public var inverse: Complex? {
        let r2 = x * x + y * y
        if let inv = r2.inverse {
            return Complex(x * inv, -y * inv)
        } else {
            return nil
        }
    }
    
    public static func ==(lhs: Complex<R>, rhs: Complex<R>) -> Bool {
        return (lhs.x == rhs.x) && (lhs.y == rhs.y)
    }
    
    public static func +(a: Complex<R>, b: Complex<R>) -> Complex<R> {
        return Complex(a.x + b.x, a.y + b.y)
    }
    
    public static prefix func -(a: Complex<R>) -> Complex<R> {
        return Complex(-a.x, -a.y)
    }
    
    public static func *(a: Complex<R>, b: Complex<R>) -> Complex<R> {
        return Complex(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x)
    }
    
    public var hashValue: Int {
        let p = 104743
        return (x.hashValue % p) &+ (y.hashValue % p) * p
    }
    
    public var description: String {
        return (x != .zero && y != .zero) ? "\(x) + \(y)i" :
                         (y == .identity) ? "i" :
                             (y != .zero) ? "\(y)i"
                                          : "\(x)"
    }
    
    public static var symbol: String {
        if R.self == 𝐑.self {
            return "𝐂"
        } else {
            return "\(R.symbol)[i]"
        }
    }
}

extension Complex: EuclideanRing, Field, NormedSpace where R == 𝐑 {
    public init(from r: 𝐐) {
        self.init(r)
    }
    
    public init(_ x: 𝐙) {
        self.init(𝐑(x), 0)
    }
    
    public init(_ x: 𝐐) {
        self.init(𝐑(x), 0)
    }
    
    public init(r: 𝐑, θ: 𝐑) {
        self.init(r * cos(θ), r * sin(θ))
    }
    
    public var abs: 𝐑 {
        return √(x * x + y * y)
    }
    
    public var norm: 𝐑 {
        return abs
    }
    
    public var arg: 𝐑 {
        let r = self.norm
        if(r == 0) {
            return 0
        }
        
        let t = acos(x / r)
        return (y >= 0) ? t : 2 * π - t
    }
}

public typealias GaussInt = Complex<𝐙>

extension Complex: EuclideanRing where R == 𝐙 { // 👈
    public func eucDiv(by b: Complex<R>) -> (q: Complex<R>, r: Complex<R>) {
        fatalError()
    }
    
    public var eucDegree: Int {
        fatalError()
    }
}

extension Complex: ExpressibleByIntegerLiteral where R: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = R.IntegerLiteralType
    public init(integerLiteral n: R.IntegerLiteralType) {
        self.init(R(integerLiteral: n))
    }
}

extension Complex: ExpressibleByFloatLiteral where R: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = R.FloatLiteralType
    public init(floatLiteral x: R.FloatLiteralType) {
        self.init(R(floatLiteral: x))
    }
}
