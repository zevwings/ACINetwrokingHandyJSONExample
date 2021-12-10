//
//  XCStringIDTransform.swift
//  XCNetworking
//
//  Created by 张伟 on 2021/9/28.
//

import Foundation
import HandyJSON
import ACINetworking

open class XCStringIDTransform: TransformType {

    public typealias Object = String
    public typealias JSON = Int64

    private lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        return formatter
    }()
    
    public init() { }

    public func transformFromJSON(_ value: Any?) -> String? {
        
        if let value = value as? String {
            return value
        }
        
        if let value = value as? Int64 {
            let number = NSNumber(value: value)
            return formatter.string(from: number)
        }

        if let value = value as? Int32 {
            let number = NSNumber(value: value)
            return formatter.string(from: number)
        }
        
        if let value = value as? Int {
            let number = NSNumber(value: value)
            return formatter.string(from: number)
        }
        
        if let value = value as? Int16 {
            let number = NSNumber(value: value)
            return formatter.string(from: number)
        }
        
        return nil
    }
    
    public func transformToJSON(_ value: String?) -> Int64? {
        guard let value = value else { return nil }
        return formatter.number(from: value)?.int64Value
    }
    
}
