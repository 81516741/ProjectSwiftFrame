//
//  LDLogindiator+Mine.swift
//  RxSwiftStudy
//
//  Created by lingda on 2018/12/1.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit
let kLogindiatorTargetLogin = "Login";
let kLogindiatorActionNativeFetchLoginVC = "nativeFetchLoginVC";

extension Mediator {
  @objc func login_getLoginController()->UINavigationController? {
        let vc = performTarget(kLogindiatorTargetLogin,
                      action: kLogindiatorActionNativeFetchLoginVC,
                      params: nil,
                      shouldCacheTarget: false)
            as? UIViewController
    
        if let vc = vc {
            if vc.isKind(of: UIViewController.classForCoder()) {
                return UINavigationController.init(rootViewController: vc)
            }
        }
        return nil
    }
}
