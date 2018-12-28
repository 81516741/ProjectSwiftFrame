//
//  LDMediator+Mine.swift
//  RxSwiftStudy
//
//  Created by lingda on 2018/12/1.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit
let kMediatorTargetHome = "Home";
let kMediatorActionNativeFetchHomeVC = "nativeFetchHomeVC";

extension Mediator {
  @objc func home_getHomeController()->UINavigationController? {
        let vc = performTarget(kMediatorTargetHome,
                      action: kMediatorActionNativeFetchHomeVC,
                      params: MediatorTool.mainVCParams("首页", "home","homeSel"),
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
