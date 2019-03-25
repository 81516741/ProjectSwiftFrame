//
//  TopImageBottomWordView.swift
//  TclIntelliCom
//
//  Created by TCL-MAC on 2018/8/8.
//  Copyright © 2018年 tcl. All rights reserved.
//

import Foundation
import Masonry

class TopImageBottomWordView:UIView {
    var circleImageView = false
    var clickHandle:((_ index:NSInteger,_ item:TopImageBottomWordView)->())?
    
    class func topImageBottomWordView()-> TopImageBottomWordView{
        let view = TopImageBottomWordView()
        view.config()
        return view
    }
    
    func updateImageViewSize(size:CGSize) {
        imageView.mas_updateConstraints({
            $0?.width.equalTo()(Adapter.adaptSize(pxValue:size.width))
            $0?.height.equalTo()(Adapter.adaptSize(pxValue:size.height))
        })
    }
    func updateImageViewOffsetCenter(offset:CGFloat) {
        imageView.mas_updateConstraints({
            $0?.centerY.equalTo()(self)?.offset()(Adapter.adaptSize(pxValue:offset))
        })
    }
    
    func updateWordMarginToImageView(offset:CGFloat) {
        bottomLabel.mas_updateConstraints({
             $0?.top.equalTo()(imageView.mas_bottom)?.offset()(Adapter.adaptSize(pxValue: offset))
        })
    }
    fileprivate func config() {
        let ges = UITapGestureRecognizer.init(target: self, action: #selector(itemClick(gesture:)))
        addGestureRecognizer(ges)
        configSubView()
        configCons()
    }
    
    fileprivate func configSubView() {
        addSubview(imageView)
        addSubview(bottomLabel)
        addSubview(closeImageView)
        addSubview(topRightImageView)
    }
    
    fileprivate func configCons() {
        imageView.mas_makeConstraints({
            $0?.centerX.equalTo()(self)
            $0?.centerY.equalTo()(self)?.offset()(Adapter.adaptSize(pxValue:-20))
            $0?.width.equalTo()(Adapter.adaptSize(pxValue:112))
            $0?.height.equalTo()(Adapter.adaptSize(pxValue:112))
        })
        
        bottomLabel.mas_makeConstraints({
            $0?.top.equalTo()(imageView.mas_bottom)
            $0?.centerX.equalTo()(self)
            $0?.left.equalTo()(self.mas_left)
            $0?.right.equalTo()(self.mas_right)
        })
        
        closeImageView.mas_makeConstraints({
            $0?.right.equalTo()(imageView.mas_right)
            $0?.top.equalTo()(imageView.mas_top)
            $0?.size.equalTo()(CGSize(width: Adapter.adaptSize(pxValue:38), height: Adapter.adaptSize(pxValue:38)))
        })
        
        topRightImageView.mas_makeConstraints({
            $0?.right.equalTo()(imageView.mas_right)
            $0?.top.equalTo()(imageView.mas_top)
            $0?.size.equalTo()(CGSize(width: Adapter.adaptSize(pxValue:38), height: Adapter.adaptSize(pxValue:38)))
        })
    }
    
    @objc func itemClick(gesture:UITapGestureRecognizer){
        if let view = gesture.view {
           clickHandle?(view.tag,self)
        }
        
    }
    
    override func layoutSubviews() {
        if circleImageView {
            imageView.layer.cornerRadius = Adapter.adaptSize(pxValue:113) * 0.5
            imageView.clipsToBounds = true
        }
        super.layoutSubviews()
    }
    
    //MARK:懒加载
    lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var bottomLabel : UILabel = {
        let bottomLabel = UILabel()
        bottomLabel.textColor = UIColor.lightGray
        bottomLabel.font = Adapter.adaptFontSize(fontSize: 26)
        bottomLabel.textAlignment = NSTextAlignment.center
        return bottomLabel
    }()
    
    lazy var closeImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "device_connecting_failure_icon")
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var topRightImageView : UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    
}
