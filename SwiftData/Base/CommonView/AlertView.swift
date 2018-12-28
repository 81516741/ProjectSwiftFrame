//
//  TCLAlertView.swift
//  TclIntelliCom
//
//  Created by TCL-MAC on 2018/9/12.
//  Copyright © 2018年 tcl. All rights reserved.
//

import Foundation
typealias block = (()->())
class AlertView : NSObject {
    class func showConfirmAndCancelAlert(inVC:UIViewController,title:String?,message:String?,confirm: block?,cancel: block?) {
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let action0 = UIAlertAction.init(title: "确认", style: .default) { (vc) in
            confirm?()
        }
        let action1 = UIAlertAction.init(title: "取消", style: .default) { (vc) in
            cancel?()
        }
        alertVC.addAction(action1)
        alertVC.addAction(action0)
        inVC.present(alertVC, animated: true, completion: nil)
    }
    
    
    class func showConfirmAlert(inVC:UIViewController,title:String?,message:String?,confirm: block?) {
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let action0 = UIAlertAction.init(title: "确认", style: .default) { (vc) in
            confirm?()
        }
        alertVC.addAction(action0)
        inVC.present(alertVC, animated: true, completion: nil)
    }
    
    class func showConfirmSheet(inVC:UIViewController,title:String?,message:String?,confirm: block?) {
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
        let action0 = UIAlertAction.init(title: "确认", style: .default) { (vc) in
            confirm?()
        }
        alertVC.addAction(action0)
        inVC.present(alertVC, animated: true, completion: nil)
    }
    
    class func showConfirmAndCancelSheet(inVC:UIViewController,title:String?,message:String?,confirm: block?,cencel: block?) {
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
        let action0 = UIAlertAction.init(title: "确认", style: .default) { (vc) in
            confirm?()
        }
        let action1 = UIAlertAction.init(title: "取消", style: .default) { (vc) in
            cencel?()
        }
        alertVC.addAction(action0)
        alertVC.addAction(action1)
        inVC.present(alertVC, animated: true, completion: nil)
    }
}
