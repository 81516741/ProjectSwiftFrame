//
//  ConnectSocketTool.swift
//  SwiftData
//
//  Created by lingda on 2018/12/18.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class ConnectSocketTool: NSObject {
    static let hostPortOB: Observable<[String]> = Observable.create { observer -> Disposable in
        let disposable = HTTPTool.getIP(count: "2004050", success: { (model:Model) in
            if let host = model.reply?.myIP,let port = model.reply?.port {
                observer.onNext([host,port])
                observer.onCompleted()
            }
        }, failure: { (err) in
            Log(err)
        })
        return disposable
    }
    static let heartIT : TimeInterval = 28
    static let requestIT : TimeInterval = 15
    static var posables = [Disposable]()
    static var timerHeart:DispatchSourceTimer?
    static var timerAddress:DispatchSourceTimer?
    
    class func connectState(_ result:((Bool)->())?) {
        _ = SocketTool.openStreamBehavior.subscribe({
            if let openStreanStep = $0.element {
                if openStreanStep == .ok {
                    result?(true)
                } else if openStreanStep == .none {
                    result?(false)
                }
            }
        })
    }
    class func connectSocket() {
        //监听开流状态
        _ = SocketTool.openStreamBehavior.bind(to: openStreamHandle())
        //监听连接状态
        _ = SocketManager.default.connectRelay.bind(to: connectStateHandle())
        //监听网络网络
        _ = NetCheckTool.netState.bind(to: netStateHandle())
        SocketTool.prepareSocket()
        NetCheckTool.checkNet()
    }
    fileprivate class func openStreamHandle() -> AnyObserver<OpenStreamStep> {
        return AnyObserver { event in
            if let openStreanStep = event.element {
                if openStreanStep == .ok {
                    SocketLoginTool.autoLogin()
                    startHeart()
                }
            }
        }
    }
    fileprivate class func connectStateHandle() -> AnyObserver<ConnectState> {
        return AnyObserver { event in
            if let state = event.element {
                if state == .connected {//连接成功
                    SocketTool.openStream()
                } else if state == .disConnect {
                    /*因为SocketTool的send方法会根据openStreamBehavior的值
                    判断是否可以发送消息，具体请看对应方法*/
                    SocketTool.openStreamBehavior.accept(.none)
                    stopHeart()
                    //有网络才去重连，如果连接成功了，那么host和port是一定存在的
                    if NetCheckTool.netState.value == .netHas {
                        SocketTool.buildConnect(toHost: SocketManager.default.host, toPort: SocketManager.default.port)
                    }
                }
            }
        }
    }
    fileprivate class func netStateHandle() -> AnyObserver<NetState> {
        return AnyObserver { event in
            if let netState = event.element {
                if netState == .netHas {
                    //已经获取了port 和 host(port 和 host 必是同时有值的)
                    if SocketManager.default.host.count != 0 {
                        SocketTool.buildConnect(toHost: SocketManager.default.host, toPort: SocketManager.default.port)
                    } else {
                        stopTimeAddress()
                        timerAddress = startTimer(timeInterval: requestIT) {
                            if NetCheckTool.netState.value == .netHas {
                                posables.append(hostPortOB.bind(to: connect()))
                            }
                        }
                    }
                }
            }
        }
    }
    fileprivate class func connect() -> AnyObserver<[String]> {
        return AnyObserver { event in
            if let host = event.element?.first,let port = event.element?.last {
                stopTimeAddress()
                //已经连接过 取消所有请求(port 和 host 必是同时有值的)
                if SocketManager.default.host.count > 0 {
                    cancelAllIPRequest()
                } else {
                    SocketTool.buildConnect(toHost: host, toPort: port)
                }
            }
        }
    }
    fileprivate class func stopTimeAddress() {
        if let timer = timerAddress {
            timer.cancel()
            self.timerAddress = nil
        }
    }
    fileprivate class func cancelAllIPRequest() {
        for ob in posables { ob.dispose() }
    }
    fileprivate class func startHeart() {
        Log("-------开启心跳-------")
        stopHeart()
        timerHeart = startTimer(timeInterval: heartIT){SocketTool.sendHeart()}
    }
    fileprivate class func stopHeart() {
        if let timer = timerHeart {
            timer.cancel()
            self.timerHeart = nil
        }
    }
}
