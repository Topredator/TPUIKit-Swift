//
//  CommonUD.swift
//  XTFoundation-Swift
//
//  Created by Topredator on 2020/6/3.
//

/// 通用userDefault 工具类
public class CommonUD: NSObject {
    public override init() {
        super.init()
    }
    
    /// 删除操作
    /// - Parameter key: 对应的key
    public static func remove(key: String?) {
        if key == nil { return }
        UserDefaults.standard.removeObject(forKey: key!)
    }
    
    /// 存储字符串
    /// - Parameters:
    ///   - string: 字符串数据
    ///   - key: 对应的键值
    public static func store(string: String?, key: String?) {
        if string == nil || key == nil { return }
        UserDefaults.standard.set(string!, forKey: key!)
    }
    public static func string(key: String?) -> String? {
        if key == nil { return nil }
        return UserDefaults.standard.string(forKey: key!)
    }
    
    /// 存储对象
    /// - Parameters:
    ///   - objc: 对象数据
    ///   - key: 对应的键值
    public static func store(objc: AnyObject?, key: String?) {
        if objc == nil || key == nil { return }
        UserDefaults.standard.set(objc!, forKey: key!)
    }
    public static func objc(key: String?) -> Any? {
        if key == nil { return nil }
        return UserDefaults.standard.object(forKey: key!)
    }
    
    /// 存储数组
    /// - Parameters:
    ///   - array: 数组数据
    ///   - key: 对应的键值
    public static func store(array: [Any?]?, key: String?) {
        if array == nil || key == nil { return }
        UserDefaults.standard.set(array!, forKey: key!)
    }
    public static func array(key: String?) -> [Any?]? {
        if key == nil { return nil }
        return UserDefaults.standard.array(forKey: key!)
    }
    
    /// 存储bool值
    /// - Parameters:
    ///   - boolValue: 布尔值
    ///   - key: 对应的键值
    public static func store(boolValue: Bool?, key: String?) {
        if boolValue == nil || key == nil { return }
        UserDefaults.standard.set(boolValue!, forKey: key!)
    }
    public static func bool(key: String?) -> Bool {
        if key == nil { return false }
        return UserDefaults.standard.bool(forKey: key!)
    }
    
    /// 存储字典
    /// - Parameters:
    ///   - dictionary: 字典数据
    ///   - key: 对应的键值
    public static func store(dictionary: Dictionary<String, Any>?, key: String?) {
        if dictionary == nil || key == nil { return }
        UserDefaults.standard.set(dictionary!, forKey: key!)
    }
    public static func dictionary(key: String?) -> Dictionary<String, Any>? {
        if key == nil { return nil }
        return UserDefaults.standard.dictionary(forKey: key!)
    }
    
    /// 存储data
    /// - Parameters:
    ///   - data: data数据
    ///   - key: 对应的键值
    public static func store(data: Data?, key: String?) {
        if data == nil || key == nil { return }
        UserDefaults.standard.set(data!, forKey: key!)
    }
    public static func data(key: String?) -> Data? {
        if key == nil { return nil }
        return UserDefaults.standard.data(forKey: key!)
    }
}
