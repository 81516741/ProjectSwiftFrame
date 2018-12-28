//
//  LDMediator+Mine.swift
//  RxSwiftStudy
//
//  Created by lingda on 2018/12/1.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit
let kMediatorTargetMe = "Me";
let kMediatorActionNativeFetchMeVC = "nativeFetchMeVC";

extension Mediator {
  @objc func me_getMeController()->UINavigationController? {
        let vc = performTarget(kMediatorTargetMe,
                      action: kMediatorActionNativeFetchMeVC,
                      params: MediatorTool.mainVCParams("首页", "me","meSel"),
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
