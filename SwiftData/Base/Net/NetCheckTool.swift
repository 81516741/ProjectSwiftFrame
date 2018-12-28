//
//  NetCheckTool.swift
//  SwiftData
//
//  Created by lingda on 2018/12/18.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa

enum NetState {
    case none
    case netNone
    case netHas
}
class NetCheckTool {
    static let netState : BehaviorRelay<NetState> = BehaviorRelay(value: .none)
    static let manager = NetworkReachabilityManager(host: "www.baidu.com")
    class func checkNet() {
        manager?.listener = { status in
            switch status {
            case .unknown,.notReachable:
                netState.accept(.netNone)
                break
            case .reachable:
                netState.accept(.netHas)
                break
            }
        }
        manager?.startListening()
    }
}
