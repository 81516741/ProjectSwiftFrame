//
//  HTTPError.swift
//  SwiftData
//
//  Created by lingda on 2018/12/19.
//  Copyright © 2018年 lingda. All rights reserved.
//

enum HTTPError : Swift.Error {
    case httpError(String)
}
extension HTTPError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .httpError(let str):
                return str
            }
    }
}
