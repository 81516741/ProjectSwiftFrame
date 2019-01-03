//
//  LoginVC.swift
//  SwiftData
//
//  Created by lingda on 2018/12/28.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    let queue = DispatchQueue(label: "dd")
    let queue1 = DispatchQueue(label: "233", attributes: .concurrent)
    override func viewDidLoad() {
        super.viewDidLoad()
        ld_hideNavigationBar = true
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (time) in
                
            }
        } else {
            // Fallback on earlier versions
        }
    }
    @IBAction func clickLoginBtn(_ sender: UIButton) {
        LDConfigVCUtil.configTabCToRootVC()
    }
    //测试不同线程的串行队列，依旧是串行的
    func test1() {
        queue.async {
            print(Thread.current)
            for index in 1...10 {
                print("任务1====\(index)")
                sleep(1)
            }
        }
        
        queue.sync {
            print(Thread.current)
            for index in 1...10 {
                print("任务2====\(index)")
            }
        }
    }
    func example() {
        //多读单写
        queue1.async(flags:.barrier,execute:{
            
        })
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        test1()
    }
}
