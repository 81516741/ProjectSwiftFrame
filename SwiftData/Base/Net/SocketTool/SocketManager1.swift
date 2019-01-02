//
//  SocketManager1.swift
//  SwiftData
//
//  Created by lingda on 2018/12/17.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit
import CocoaAsyncSocket
import RxSwift
import RxCocoa


class SocketManager1: NSObject {
    static let `default` = SocketManager1()
    static let sendMsgSuccess = "sendMsgSuccess"
    let messageSubject = PublishSubject<String>()
    let sendMsdSubject = PublishSubject<String>()
    let connectRelay = BehaviorRelay<ConnectState>(value: .none)
    let queue = DispatchQueue(label: "ddd")
    fileprivate var socket:GCDAsyncSocket!
    fileprivate var hostStr:String = ""
    fileprivate var portStr:String = ""
    
    func connect(toHost host:String?,toPort port:String?) {
        guard let host0 = host else {
            Log("host为nil")
            return
        }
        guard let port0 = port else {
            Log("port为nil")
            return
        }
        guard let portUInt16 = UInt16(port0) else {
            Log("port:" + port0 + "不是UInt16格式")
            return
        }
        self.hostStr = host0
        self.portStr = port0
        if socket == nil {
            socket = GCDAsyncSocket(delegate: self, delegateQueue: queue)
        }
        try? self.socket.connect(toHost: host!, onPort: portUInt16)
    }
    
    func close() {
        socket.disconnect()
    }
    
    func send(message msg:String) {
        if connectRelay.value != .connected {
            Log("socket没有连接服务器")
            self.sendMsdSubject.onNext(msg)
            return;
        }
        if let data = msg.data(using: .utf8) {
            Log("发送消息：\(msg)")
            self.socket.write(data, withTimeout: -1, tag: 0)
            self.socket.readData(withTimeout: -1, tag: 0)
        } else {
            Log(msg + "无法转成data")
            self.sendMsdSubject.onNext(msg)
        }
    }
    func startTLS() {
        Log("开启TLS")
        Socket.startTSL(socket, address: SocketManager1.default.host())
        self.socket.readData(withTimeout: -1, tag: 0)
    }
    
    func host()->String {
        return hostStr
    }
    func port()->String {
        return portStr
    }
}

extension SocketManager1:GCDAsyncSocketDelegate {
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        self.connectRelay.accept(.connected)
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        self.connectRelay.accept(.disConnect)
    }
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        self.sendMsdSubject.onNext(SocketManager1.sendMsgSuccess)
    }
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        self.messageSubject.onNext(String(data: data, encoding: .utf8)!)
        sock.readData(withTimeout: -1, tag: 0)
    }
    func socket(_ sock: GCDAsyncSocket, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        
    }
}
