//
//  ImageViewBehavior.swift
//  RxSwiftStudy
//
//  Created by lingda on 2018/12/1.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit

class ImageViewBehavior: LDBehavior {

    @IBOutlet var imageView:UIImageView!
    
    override func check() -> Bool {
        if imageView.image == nil {
            return false
        } else {
            return true
        }
    }

}
