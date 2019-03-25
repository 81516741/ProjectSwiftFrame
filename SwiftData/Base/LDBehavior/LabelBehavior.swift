//
//  LabelBehavior.swift
//  RxSwiftStudy
//
//  Created by lingda on 2018/12/1.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit

class LabelBehavior: LDBehavior {
    @IBOutlet var behaviors:[LDBehavior]!
    @IBOutlet var label:UILabel!
    @IBInspectable var color:UIColor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.observer()
            self.label.textColor = self.color ?? UIColor.red
        }
    }
    
    func observer() {
        for behavior in behaviors {
            if behavior.isKind(of: TextFieldBehavior.classForCoder()) {
                let behavior1 = behavior as! TextFieldBehavior
                _ = behavior1.textField.rx.text.orEmpty.takeUntil(self.rx.deallocated).subscribe(onNext: { [weak self](text) in
                    _ = self?.check()
                })
                
                _ = behavior1.textField.rx.observe(String.self, #keyPath(UITextField.text)).takeUntil(self.rx.deallocated).subscribe(onNext: { [weak self](text) in
                    _ = self?.check()
                })
            }
            if behavior.isKind(of: ImageViewBehavior.classForCoder()) {
                let behavior1 = behavior as! ImageViewBehavior
                _ = behavior1.imageView.rx.observe(UIImage.self, #keyPath(UIImageView.image)).takeUntil(self.rx.deallocated).subscribe(onNext: { [weak self](image) in
                    _ = self?.check()
                })
            }
        }
    }
    
    override func check() -> Bool{
        var allOK = true
        for behavior in behaviors {
            allOK = behavior.check()
            if !allOK { break }
        }
        label.isHidden = allOK
        return allOK
    }
}
