//
//  NameSpace.swift
//  TPFoundation-Swift
//
//  Created by Topredator on 2021/8/26.
//

public protocol TypeWrapper {
    associatedtype TargetType
    var base: TargetType { get }
    init(_ base: TargetType)
}

public struct NameSpace<Base>: TypeWrapper {
    public var base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

/// 命名空间协议
public protocol NameSpaceWrappable {
    associatedtype TargetType
    var tp: TargetType { get set }
    static var tp: TargetType.Type { get set }
}

extension NameSpaceWrappable {
    public var tp: NameSpace<Self> {
        get { NameSpace<Self>(self) }
        set {}
    }
    public static var tp: NameSpace<Self>.Type {
        get { NameSpace<Self>.self }
        set {}
    }
}
