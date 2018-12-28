//
//  UdpSocketManager.swift
//  SwiftData
//
//  Created by lingda on 2018/12/24.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit
import CocoaAsyncSocket
import RxSwift

class UdpSocketManager: NSObject {
    static let `default` = UdpSocketManager()
    let udpSocketQueue = DispatchQueue(label: "udp队列")
    let messageSubject = PublishSubject<String>()
    let errorSubject = PublishSubject<String>()
    var host = "255.255.255.255"
    var port : UInt16 = 10075
    var bindPort : UInt16 = 10074
    var udpSocket : GCDAsyncUdpSocket?
    func send(_ msg:String) {
        if udpSocket == nil { configUdpSocket() }
        Log("发送udp消息：\(msg)")
        if let data = msg.data(using: .utf8) {
            udpSocket!.send(data, toHost: host, port: port, withTimeout: -1, tag: 0)
            try? udpSocket?.beginReceiving()
        }
    }
    func closeUdpSocket() {
        if let udpSocket = udpSocket {
            udpSocket.close()
            self.udpSocket = nil
        }
    }
    
    func configUdpSocket(_ host:String = "255.255.255.255",_ port:UInt16 = 10075,_ bindPort:UInt16 = 10074) {
        udpSocket = GCDAsyncUdpSocket.init(delegate: self, delegateQueue: udpSocketQueue)
        try? udpSocket?.enableBroadcast(true)
        try? udpSocket?.bind(toPort: bindPort)
    }
}

extension UdpSocketManager:GCDAsyncUdpSocketDelegate {
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        if let msg = String(bytes: data, encoding: .utf8) {
            messageSubject.onNext(msg)
        }
    }
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?) {
        if let err = error?.localizedDescription {
            errorSubject.onNext(err)
        }
    }
}
