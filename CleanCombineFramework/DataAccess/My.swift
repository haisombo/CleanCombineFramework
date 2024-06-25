//
//  My.swift
//  CleanCombineFramework
//
//  Created by Hai Sombo on 6/25/24.
//

import Foundation
struct MyJSON {
    
    enum JSONError: Error {
        case serializedJSONError // dic -> JSON
        case deserializedJSONError
    }
    
    enum DataError: Error {
        case invalidEncodingData
    }
    
    static func prettyPrint(value: AnyObject) -> String {
        if JSONSerialization.isValidJSONObject(value) {
            if let data = try? JSONSerialization.data(withJSONObject: value, options: JSONSerialization.WritingOptions.prettyPrinted) {
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }
        }
        return ""
    }
    
    static func dataToDic(_ data: Data) -> NSDictionary? {
        guard let dic: NSDictionary = (try? JSONSerialization.jsonObject(with: data, options: [])) as? NSDictionary else {
            return nil
        }
        
        return dic
    }
    
    static func jsonToDic(_ data: Data) throws -> NSDictionary {
        guard let dic: NSDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
            throw JSONError.deserializedJSONError
        }
        
        return dic
    }
    
    static func dicToJSONString(_ dic: [String:Any]) throws -> String {
        let data: Data = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions(rawValue: 0))
        
        guard let jsonString: String = String(data: data, encoding: String.Encoding.utf8) else {
            throw DataError.invalidEncodingData
        }
        
        return jsonString
    }
    
    static func jsonStringToDic(_ jsonString : String) -> [String: Any]? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
        } catch {
            #if DEBUG
            Log.e(error.localizedDescription)
            #endif
            return nil
        }
    }
}

struct MyDefaults {
    
    static func set(key: UserDefaultKey, value: Any?) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func get(key: UserDefaultKey) -> Any? {
        return UserDefaults.standard.object(forKey: key.rawValue)
    }
    
    static func bool(key: UserDefaultKey) -> Bool {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }
    
    static func int(key: UserDefaultKey) -> Int {
        return UserDefaults.standard.integer(forKey: key.rawValue)
    }
    
    static func float(key: UserDefaultKey) -> Float {
        return UserDefaults.standard.float(forKey: key.rawValue)
    }
    
    static func double(key: UserDefaultKey) -> Double {
        return UserDefaults.standard.double(forKey: key.rawValue)
    }
    
    static func string(key: UserDefaultKey) -> String {
        return UserDefaults.standard.string(forKey: key.rawValue) ?? ""
    }
    
    static func dic(key: UserDefaultKey) -> [String: Any] {
        return UserDefaults.standard.dictionary(forKey: key.rawValue) ?? [:]
    }
    
    static func data(key: UserDefaultKey) -> Data {
        return UserDefaults.standard.data(forKey: key.rawValue) ?? Data()
    }
    
    static func array(key: UserDefaultKey) -> [Any] {
        return UserDefaults.standard.array(forKey: key.rawValue) ?? []
    }
    
    static func url(key: UserDefaultKey) -> URL? {
        return UserDefaults.standard.url(forKey: key.rawValue)
    }
}
struct UTF8 {
    
    static func encode(_ string:String) -> String! {
        let allowedCharacterSets = (NSCharacterSet.urlQueryAllowed as NSCharacterSet).mutableCopy() as! NSMutableCharacterSet
        allowedCharacterSets.removeCharacters(in: "!@#$%^&*()-_+=~`:;\"'<,>.?/")
        
        guard let encodeString = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSets as CharacterSet) else{
            return nil
        }
        
        return encodeString
    }
    
    static func decode(_ string:String) -> String! {
        guard let encodeString = string.removingPercentEncoding else{
            return nil
        }
        
        return encodeString
    }
    
    static func decodeForData(_ data: Data) -> Data! {
        guard let decode = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else{
            return nil
        }
        
        if let percentageDecode = decode.removingPercentEncoding {
            return percentageDecode.data(using: String.Encoding.utf8)
        }
        return decode.data(using: String.Encoding.utf8.rawValue)
    }
}
