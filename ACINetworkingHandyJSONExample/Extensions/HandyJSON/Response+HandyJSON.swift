//
//  Response+HandyJSON.swift
//
//  Created by zevwings on 2019/9/10.
//  Copyright © 2019 zevwings. All rights reserved.
//

import Foundation
import HandyJSON
import ACINetworking

public extension Response {

    func mapObject<T: HandyJSON>(
        _ type: T.Type,
        atKeyPath keyPath: String? = nil
    ) throws -> T {

        guard let json = try value(for: keyPath) as? [String: Any] else {
            let context = HTTPError.Context(request: request, response: response)
            let error = HTTPError.typeMismatch(
                value: try? mapJSON(logSwitch: false),
                targetType: String.self,
                context: context
            )
            HTTPLogger.logFailure(.transform, error: error)
            throw error
        }

        guard let result = T.deserialize(from: json) else {
            let context = HTTPError.Context(request: request, response: response)
            let error = HTTPError.typeMismatch(
                value: try? mapJSON(logSwitch: false),
                targetType: String.self,
                context: context
            )
            HTTPLogger.logFailure(.transform, error: error)
            throw error
        }
        
        HTTPLogger.logSuccess(.transform, urlRequest: request, data: result)

        return result
    }

    func mapArray<T: HandyJSON>(
        _ type: T.Type,
        atKeyPath keyPath: String? = nil
    ) throws -> [T] {

        guard let array = try value(for: keyPath) as? [[String: Any]] else {
            let context = HTTPError.Context(request: request, response: response)
            let error = HTTPError.typeMismatch(
                value: try? mapJSON(logSwitch: false),
                targetType: String.self,
                context: context
            )
            HTTPLogger.logFailure(.transform, error: error)
            throw error
        }

        guard let result = [T].deserialize(from: array) as? [T] else {
            let context = HTTPError.Context(request: request, response: response)
            let error = HTTPError.typeMismatch(
                value: try? mapJSON(logSwitch: false),
                targetType: String.self,
                context: context
            )
            HTTPLogger.logFailure(.transform, error: error)
            throw error
        }
        
        HTTPLogger.logSuccess(.transform, urlRequest: request, data: result)
        
        return result
    }

    func value(for keyPath: String?) throws -> Any? {
        if let keyPath = keyPath {
            return (try mapJSON() as? NSDictionary)?.value(forKeyPath: keyPath)
        } else {
            return try mapJSON()
        }
    }
}
