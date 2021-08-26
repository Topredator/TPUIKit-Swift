//
//  Then.swift
//  XTFoundation-Swift
//
//  Created by Topredator on 2021/8/17.
//

import Foundation

public protocol Then {}

extension Then where Self: Any {
    @inlinable
    public func with(_ closure: (inout Self) throws -> Void) rethrows -> Self {
        var copy = self
        try closure(&copy)
        return copy
    }
    @inlinable
    public  func `do`(_ closure: (Self) throws -> Void) rethrows {
        try closure(self)
    }
    
    @inlinable
    public mutating func to(_ closure: (inout Self) throws -> Void) rethrows {
        try closure(&self)
    }
    
}

extension Then where Self: AnyObject {
    @inlinable
    public func then(_ closure: (Self) throws -> Void) rethrows -> Self {
        try closure(self)
        return self
    }
}

extension NSObject: Then {}

#if !os(Linux)
  extension CGPoint: Then {}
  extension CGRect: Then {}
  extension CGSize: Then {}
  extension CGVector: Then {}
#endif

extension Array: Then {}
extension Dictionary: Then {}
extension Set: Then {}

#if os(iOS) || os(tvOS)
  extension UIEdgeInsets: Then {}
  extension UIOffset: Then {}
  extension UIRectEdge: Then {}
#endif
