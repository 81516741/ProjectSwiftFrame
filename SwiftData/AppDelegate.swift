//
//  AppDelegate.swift
//  SwiftData
//
//  Created by lingda on 2018/12/3.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        LDConfigVCUtil.config(true)
        ConnectSocketTool.connectSocket()
        ConnectSocketTool.connectState {
            if $0 {
                MBProgressHUD.showTipMessage(inWindow: "连接成功")
            } else {
                MBProgressHUD.showTipMessage(inWindow: "断开连接")
            }
        }
        return true
    }
}




