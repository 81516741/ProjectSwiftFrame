//
//  UdpSocketTool.swift
//  SwiftData
//
//  Created by lingda on 2018/12/24.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON

class LocalDeviceUdpTool: NSObject {
    static var localDeviceList = [JSON]()
    class func startSearchDevice() {
        UdpSocketManager.default.send("<searchDevice></searchDevice>")
        _ = UdpSocketManager.default.messageSubject.bind(to: msgHandle())
        _ = UdpSocketManager.default.errorSubject.bind(to: errHandle())
    }
    class func stopSearchDevice() {
        UdpSocketManager.default.closeUdpSocket()
    }
    class func msgHandle()->AnyObserver<String> {
        return AnyObserver { event in
            if let value = event.element {
                let json = JSON(XMLUtil.dic(fromXML: value))
                guard let deviceID = json["deviceInfo"]["tid"].rawValue as? String else {
                    return
                }
                for deviceJson in localDeviceList {
                    let localDeviceID = deviceJson["deviceInfo"]["tid"].rawValue as? String
                    if deviceID == localDeviceID {
                        return
                    }
                }
                Log("udp搜到新设备：\(json.rawValue)")
                localDeviceList.append(json)
            }
        }
    }
    class func errHandle()->AnyObserver<String> {
        return AnyObserver { event in
            if let value = event.element {
                Log("udp设备搜索出错：\(value)")
            }
        }
    }
}
