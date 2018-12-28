//
//  HTTPExtension.swift
//  RxMoya
//
//  Created by lingda on 2018/12/4.
//  Copyright © 2018年 ZhaoHeng. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import MJExtension
import SwiftyJSON
import Alamofire

let myMrg = getManager()
fileprivate func getManager() -> Alamofire.SessionManager {
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
    configuration.timeoutIntervalForRequest = 15
    let manager = Manager(configuration: configuration)
    manager.startRequestsImmediately = false
    return manager
}
func loginProvider() -> MoyaProvider<HTTPLoginServices> {
    return MoyaProvider<HTTPLoginServices>(manager:myMrg)
}

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    func map<T:NSObject>(_ type: T.Type) -> Single<T?> {
        return flatMap { response -> Single<T?> in
            let xmlStr = String(data: response.data, encoding: String.Encoding.utf8)
            guard let xmlDic = XMLUtil.dic(fromXML: xmlStr) as? [String:Any] else {
                return Single<T?>.create { single in
                    single(.error(HTTPError.httpError("服务器数据错误")))
                    return Disposables.create()
                }
            }
            var dataJson = JSON(xmlDic)
            dataJson["replys"] = [["errorcode":"ddd","ip":"fadsfa","port":"fasdf"],["errorcode":"ddd2312","ip":"fa321sdfdfddsfa","port":"fasddddddf"]]
            let model = T.mj_object(withKeyValues: dataJson.rawValue)
            if let model = model {
                return Single<T?>.create { single in
                    single(.success(model))
                    return Disposables.create()
                }
            } else {
                return Single<T?>.create { single in
                    single(.error(HTTPError.httpError("服务器数据错误")))
                    return Disposables.create()
                }
            }
        }
    }
    
    func map() -> Single<JSON?> {
        return flatMap { response -> Single<JSON?> in
            let xmlStr = String(data: response.data, encoding: String.Encoding.utf8)
            guard let xmlDic = XMLUtil.dic(fromXML: xmlStr) as? [String:Any] else {
                return Single<JSON?>.create { single in
                    single(.error(HTTPError.httpError("服务器数据错误")))
                    return Disposables.create()
                }
            }
            var dataJson = JSON(xmlDic)
            dataJson["replys"] = [["errorcode":"ddd","ip":"fadsfa","port":"fasdf"],["errorcode":"ddd2312","ip":"fa321sdfdfddsfa","port":"fasddddddf"]]
            return Single<JSON?>.create { single in
                single(.success(dataJson))
                return Disposables.create()
            }
        }
    }
}

extension URL {
    static func url(string: String) -> URL {
        if string.count > 0, let url = URL(string: string) {
            return url
        }
        assert(string.count <= 0, "check the url (string = \(string)")
        return URL(string: string)!
    }
}
