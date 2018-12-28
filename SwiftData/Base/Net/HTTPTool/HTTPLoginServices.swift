//
//  HTTPServices.swift
//  RxMoya
//
//  Created by lingda on 2018/12/4.
//  Copyright © 2018年 ZhaoHeng. All rights reserved.
//

import Foundation
import Moya

enum HTTPLoginServices {
    case getIP(String)
    case hello
}

extension HTTPLoginServices: TargetType {
    var baseURL: URL {
        if isTest {
            return URL.url(string: "http://ds.zx.test.tcljd.net:8500")
        } else {
            return URL.url(string: "https://www.baidu.com")
        }
    }
    var path: String {
        switch self {
            case .getIP(_):
                return "/distribute-server/get_as_addr"
            default : return "hello"
        }
    }
    var method: Moya.Method {
        switch self {
            case .getIP(_):
                return .get
            default:
                return .post
        }
    }
    var task: Task {
        switch self {
            case .getIP(let userID):
                var params: [String: Any] = [:]
                params["method"] = "get_as"
                params["clienttype"] = "4"
                params["userid"] = userID
                params["replyproto"] = "xml"
                return .requestParameters(parameters: params,
                                          encoding: URLEncoding.default)
            default:
                return .requestPlain
        }
    }
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    var validationType: ValidationType {
        return .none
    }
    var headers: [String: String]? {
        return nil
    }
}


