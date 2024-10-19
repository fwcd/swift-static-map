import Foundation
import Geodesy
import Utils

/// A vector in tile coordinates.
struct TileVec<Element> {
    /// The x coordinate of a tile.
    var x: Element
    /// The y coordinate of a tile.
    var y: Element

    /// Applies the given transformation elementwise.
    func map<T>(_ f: (Element) throws -> T) rethrows -> TileVec<T> {
        try .init(x: f(x), y: f(y))
    }

    /// Applies the given binary operation elementwise.
    func zip<T>(_ rhs: Self, with f: (Element, Element) throws -> T) rethrows -> TileVec<T> {
        try .init(x: f(x, rhs.x), y: f(y, rhs.y))
    }
}

extension TileVec where Element == Int {
    init(rounding vec: TileVec<Double>, _ rule: FloatingPointRoundingRule) {
        self.init(
            x: Int(vec.x.rounded(rule)),
            y: Int(vec.y.rounded(rule))
        )
    }
}

extension TileVec where Element == Double {
    init(_ vec: TileVec<Int>) {
        self.init(
            x: Double(vec.x),
            y: Double(vec.y)
        )
    }

    func rounded(_ rule: FloatingPointRoundingRule) -> TileVec<Int> {
        TileVec<Int>(rounding: self, rule)
    }
}

extension TileVec: Equatable where Element: Equatable {}
extension TileVec: Hashable where Element: Hashable {}

extension TileVec: Addable where Element: Addable {
    static func +(lhs: Self, rhs: Self) -> Self {
        lhs.zip(rhs, with: +)
    }

    static func +=(lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
}

extension TileVec: Subtractable where Element: Subtractable {
    static func -(lhs: Self, rhs: Self) -> Self {
        lhs.zip(rhs, with: -)
    }

    static func -=(lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
}

extension TileVec: Multipliable where Element: Multipliable {
    static func *(lhs: Self, rhs: Self) -> Self {
        lhs.zip(rhs, with: *)
    }

    static func *(lhs: Self, rhs: Element) -> Self {
        lhs.map { $0 * rhs }
    }

    static func *(lhs: Element, rhs: Self) -> Self {
        rhs.map { lhs * $0 }
    }

    static func *=(lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }

    static func *=(lhs: inout Self, rhs: Element) {
        lhs = lhs * rhs
    }
}

extension TileVec: Divisible where Element: Divisible {
    static func /(lhs: Self, rhs: Self) -> Self {
        lhs.zip(rhs, with: /)
    }

    static func /(lhs: Self, rhs: Element) -> Self {
        lhs.map { $0 / rhs }
    }

    static func /=(lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }

    static func /=(lhs: inout Self, rhs: Element) {
        lhs = lhs / rhs
    }
}

extension TileVec: Sendable where Element: Sendable {}
