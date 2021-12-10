//
//  XCDateTransform.swift
//  XCNetworking
//
//  Created by 张伟 on 2021/2/3.
//

import Foundation
import HandyJSON
import ACINetworking

open class XCDateTransform: TransformType {

    public typealias Object = Date
    public typealias JSON = String

    public init() { }

    open func transformFromJSON(_ value: Any?) -> Date? {
        
        if let timeInterval = value as? Double {
            return Date(timeIntervalSince1970: timeInterval / 1000)
        }
        
        if let timeInterval = value as? Float {
            return Date(timeIntervalSince1970: Double(timeInterval) / 1000)
        }
        
        if let timeInterval = value as? Int {
            return Date(timeIntervalSince1970: Double(timeInterval) / 1000)
        }

        if let dateString = value as? String {
            if let timeInterval = Double(dateString) {
                return Date(timeIntervalSince1970: Double(timeInterval) / 1000)
            } else {
                return transformFromDateString(dateString)
            }
        }

        return nil
    }

    open func transformToJSON(_ value: Date?) -> String? {
        if let date = value {
            let dateFormatter = DateFormatter()
            // 传给服务器统一使用 yyyy-MM-dd
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    private func transformFromDateString(_ dateString: String) -> Date? {
        
        let dateFomarts: [String] = [
            "yyyy-MM-dd",
            "yyyy-MM-dd HH:mm:ss",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd HH:mm:ss.SSSZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
            "yyyy/MM/dd",
            "yyyy/MM/dd HH:mm:ss",
            "yyyy/MM/dd'T'HH:mm:ss",
            "yyyy/MM/dd HH:mm:ss.SSSZ",
            "yyyy/MM/dd'T'HH:mm:ss.SSSZ"
        ]
        
        let dateFormatter = DateFormatter()
        var transformedDate: Date?
        for dateFomart in dateFomarts {
            dateFormatter.dateFormat = dateFomart
            if let date = dateFormatter.date(from: dateString) {
                transformedDate = date
                break
            }
        }
        
        return transformedDate
    }
}
