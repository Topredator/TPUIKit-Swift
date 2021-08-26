//
//  Codable.swift
//  XTFoundation-Swift
//
//  Created by Topredator on 2021/8/20.
//

import Foundation


extension Encodable {
    public func encoder() -> Data? {
        let coder = JSONEncoder()
        coder.outputFormatting = .prettyPrinted
        return try? coder.encode(self)
    }
}

extension Data {
    
    /// Data -> 字典
    public func toDictionary() -> [String: Any]? {
        try? JSONSerialization.jsonObject(with: self, options: .mutableLeaves) as? [String: Any]
    }
    /// Data -> 字符串
    public func toString() -> String? {
        String(data: self, encoding: .utf8)
    }
}



extension Decodable {
    public static func jsonData(with param: Any) -> Data? {
        if !JSONSerialization.isValidJSONObject(param) { return nil }
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: []) else {
            return nil
        }
        return data
    }
    public static func decode(_ data: Data) -> Self? {
        guard let model = try? JSONDecoder().decode(Self.self, from: data) else {
            return nil
        }
        return model
    }
    /// 字典 -> model  eg: Model.decode(dic)
    /// - Parameter dictionary: datasource
    public static func decode(_ dictionary: [String: Any]) -> Self? {
        guard let data = jsonData(with: dictionary) else { return nil }
        return decode(data)
    }
    
    /// 数组 -> 模型  eg: [Model].decode(array)
    /// - Parameter array: datasources
    public static func decode(_ array: [[String: Any]]) -> Self? {
        guard let data = jsonData(with: array) else {
            return nil
        }
        return decode(data)
    }
    
}
