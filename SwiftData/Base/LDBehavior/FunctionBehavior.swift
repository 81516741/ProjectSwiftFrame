//
//  FunctionBehavior.swift
//  RxSwiftStudy
//
//  Created by lingda on 2018/12/1.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit

class FunctionBehavior: LDBehavior {
    @IBOutlet var imagePickButton : UIButton? {
        didSet {
            _ = imagePickButton?.rx.tap.takeUntil(self.rx.deallocated).subscribe(onNext:{
                print("打开相册")
            })
        }
    }

}
