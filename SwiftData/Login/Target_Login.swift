//
//  Target_Mine.swift
//  RxSwiftStudy
//
//  Created by lingda on 2018/12/1.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit

class Target_Login: NSObject {
    @objc func Action_nativeFetchLoginVC(params:[String:String]) -> UIViewController{
        let vc = LoginVC()
        return vc
    }
    @objc func noLoginthod(params:NSDictionary)  {
        print("没有找到对应方法")
    }
}


