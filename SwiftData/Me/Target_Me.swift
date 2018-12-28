//
//  Target_Mine.swift
//  RxSwiftStudy
//
//  Created by lingda on 2018/12/1.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit

class Target_Me: NSObject {
    @objc func Action_nativeFetchMeVC(params:[String:String]) -> UIViewController{
        let vc = MeVC()
        MediatorTool.setMainVC(vc, params)
        return vc
    }
    @objc func noMethod(params:NSDictionary)  {
        print("没有找到对应方法")
    }
}


