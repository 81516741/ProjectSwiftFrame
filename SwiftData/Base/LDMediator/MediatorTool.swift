//
//  MediatorTool.swift
//  SwiftData
//
//  Created by lingda on 2018/12/28.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit

class MediatorTool: NSObject {
    class func mainVCParams(_ title:String,_ image:String,_ imageSel:String) -> [String:String]{
        return ["title":title,"image":image,"imageSel":imageSel]
    }
    
    class func setMainVC(_ vc:UIViewController,_ params:[String:String]) {
        vc.tabBarItem.title = params["title"]
        vc.tabBarItem.selectedImage = UIImage(named: params["imageSel"]!)
        vc.tabBarItem.image = UIImage(named: params["image"]!)
        vc.tabBarItem.setTitleTextAttributes([.foregroundColor:UIColor.red], for: .selected)
        vc.tabBarItem.setTitleTextAttributes([.foregroundColor:UIColor.purple], for: .normal)
    }
}
