//
//  Data+TP.swift
//  TPFoundation-Swift
//
//  Created by Topredator on 2021/8/26.
//

import Foundation
import CommonCrypto

fileprivate extension Array {
    init(reserveCapacity: Int) {
        self = Array<Element>()
        self.reserveCapacity(reserveCapacity)
    }
    var slice: ArraySlice<Element> {
        return self[self.startIndex ..< self.endIndex]
    }
}

fileprivate extension Array where Element == UInt8 {
    init(hex: String) {
        self.init(reserveCapacity: hex.unicodeScalars.lazy.underestimatedCount)
        var buffer: UInt8?
        var skip = hex.hasPrefix("0x") ? 2 : 0
        for char in hex.unicodeScalars.lazy {
            guard skip == 0 else {
                skip -= 1
                continue
            }
            guard char.value >= 48 && char.value <= 102 else {
                removeAll()
                return
            }
            let v: UInt8
            let c: UInt8 = UInt8(char.value)
            switch c {
            case let c where c <= 57:
                v = c - 48
            case let c where c >= 65 && c <= 70:
                v = c - 55
            case let c where c >= 97:
                v = c - 87
            default:
                removeAll()
                return
            }
            if let b = buffer {
                append(b << 4 | v)
                buffer = nil
            } else {
                buffer = v
            }
        }
        if let b = buffer {
            append(b)
        }
    }
    
    func toHexString() -> String {
        return `lazy`.reduce("") {
            var s = String($1, radix: 16)
            if s.count == 1 {
                s = "0" + s
            }
            return $0 + s
        }
    }
}


extension Data: NameSpaceWrappable {}
public extension NameSpace where Base == Data {
    var bytes: [UInt8] {
        Array(base)
    }
    /// AES / ECB 加密
    /// - Parameter key: 加密秘钥
    func AESEncrypt(key: String) -> Data? {
        return _AES(key: key, operation: CCOperation(kCCEncrypt))
    }

    /// AES / ECB 解密
    /// - Parameter key: 解密秘钥
    func AESDecrypt(key: String) -> Data? {
        return _AES(key: key, operation: CCOperation(kCCDecrypt))
    }
    
    private func _AES(key: String, operation: CCOperation) -> Data? {
        guard key.count == kCCKeySizeAES128 || key.count == kCCKeySizeAES256, let keyData = key.data(using: .utf8) else {
            debugPrint("Error: Failed to set a key")
            return nil
        }
        let options = CCOptions(kCCOptionPKCS7Padding | kCCOptionECBMode)
        // key
        let keyBytes = keyData.tp.bytes
        let keyLength = [UInt8](repeating: 0, count: key.count).count
        // data
        let dataBytes = base.tp.bytes
        let dataLength = base.count
        //data(output) 加密后的数据（指针）
        var cryptData = Data(count: dataLength + Int(kCCBlockSizeAES128))
        let cryptLength = cryptData.count
        var bytesDecrypted: size_t = 0
        
        let status = cryptData.withUnsafeMutableBytes { (cryptBytes) -> Int32 in
            let cryptBytesBuffterPointer = cryptBytes.bindMemory(to: UInt8.self)
            guard let cryptBytesAddress = cryptBytesBuffterPointer.baseAddress else {
                return Int32(kCCParamError)
            }
            return CCCrypt(operation, CCAlgorithm(kCCAlgorithmAES), options, keyBytes, keyLength, nil, dataBytes, dataLength, cryptBytesAddress, cryptLength, &bytesDecrypted)
        }
        guard Int32(status) == Int32(kCCSuccess) else {
            debugPrint("Error: Failed to crypt data")
            return nil
        }
        cryptData.removeSubrange(bytesDecrypted..<cryptData.count)
        return cryptData
    }
}
