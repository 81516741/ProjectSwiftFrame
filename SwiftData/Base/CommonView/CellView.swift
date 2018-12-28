//
//  CellView.swift
//  TclIntelliCom
//
//  Created by TCL-MAC on 2018/8/7.
//  Copyright © 2018年 tcl. All rights reserved.
//

import UIKit
import Masonry

enum  CellViewType{
    case CellViewArrowImageView
    case CellViewArrowLabel
    case CellViewSwich
    case CellViewDeleteAndAdd
    case CellViewLeftImageWordRightCheckBox
    case CellViewLeftWordRightImage
}

class CellView: UIView {
    
    var clickSwichHandle : ((_ isOn : Bool)->Void)?
    var clickDeleteBtnHandle : ((_ isSelected : Bool)->Void)?
    var clickAddBtnHandle : (()->Void)?
    var clickCellHandle : ((CellView)->Void)?
    var type:CellViewType
    var isSelected : Bool {
        didSet {
            checkBoxImageView.isHidden = !isSelected
        }
    }
    
    
    init(type:CellViewType,frame: CGRect) {
        self.type = type
        self.isSelected = false
        super.init(frame: frame)
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func defaultArrowImageViewCell() -> CellView{
        
        return CellView(type: .CellViewArrowImageView, frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: TransSizeTool.transWidthSize(pxValue:88)))
    }
    
    /// 【文字】        -R【文字】 【箭头图片】
    ///
    /// - Returns: cell
    class func defaultArrowLabelCell() -> CellView{
        return CellView(type: .CellViewArrowLabel, frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: TransSizeTool.transWidthSize(pxValue:88)))
    }
    
    
    /// 【文字】         -R【switch】
    ///
    /// - Returns: cell
    class func defaultSwichCell() -> CellView{
        return CellView(type: .CellViewSwich, frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: TransSizeTool.transWidthSize(pxValue:88)))
    }
    
    /// 【文字】         -R【含有+ - 的btn】
    ///
    /// - Returns: cell
    class func defaultDeleteAndAddCell() -> CellView{
        return CellView(type: .CellViewDeleteAndAdd, frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: TransSizeTool.transWidthSize(pxValue:88)))
    }
    
    
    /// 【图片】 【文字】  -R【图片（默认是个隐藏的checkBox图片）】
    ///
    /// - Returns: cell
    class func defaultLeftImageWordRightCheckBoxCell() -> CellView{
        return CellView(type: .CellViewLeftImageWordRightCheckBox, frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: TransSizeTool.transWidthSize(pxValue:88)))
    }
    /// 【文字】             -R【图片】
    ///
    /// - Returns: cell
    class func defaultLeftWordRightImage() -> CellView{
        return CellView(type: .CellViewLeftWordRightImage, frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: TransSizeTool.transWidthSize(pxValue:88)))
    }
    
    
    fileprivate func config() {
        backgroundColor = UIColor.white
        configEvent()
        configSubView()
        configCons()
    }
    
    fileprivate func configSubView() {
        addSubview(titleLable)
        addSubview(subtitleLable)
        addSubview(separateLine)
        switch type {
            case .CellViewArrowImageView:
                addSubview(rightIconImageView)
                addSubview(arrowImageView)
            case .CellViewArrowLabel:
                addSubview(arrowImageView)
                addSubview(rightLable)
            case .CellViewSwich:
                addSubview(swichUI)
            case .CellViewDeleteAndAdd:
                addSubview(deleteAndAddBtn)
            case .CellViewLeftImageWordRightCheckBox:
                addSubview(checkBoxImageView)
                addSubview(titleLable)
                addSubview(leftImageView)
            case .CellViewLeftWordRightImage:
                addSubview(checkBoxImageView)
                addSubview(titleLable)
        }
        
        
    }
    
    fileprivate func configCons() {
        separateLine.mas_makeConstraints({
            $0?.left.equalTo()(0)
            $0?.right.equalTo()(0)
            $0?.bottom.equalTo()(self.mas_bottom)?.offset()(-1)
            $0?.height.equalTo()(0.5);
        })
        if type == .CellViewLeftImageWordRightCheckBox {
            titleLable.mas_makeConstraints({
                $0?.left.equalTo()(leftImageView.mas_right)?.with().offset()(TransSizeTool.transWidthSize(pxValue:20))
                $0?.centerY.equalTo()(self)
            })
        } else {
            titleLable.mas_makeConstraints({
                $0?.centerY.equalTo()(self)
                $0?.left.mas_equalTo()(TransSizeTool.transWidthSize(pxValue:30))
            })
        }
        subtitleLable.mas_makeConstraints({
            $0?.left.equalTo()(titleLable.mas_right)?.offset()(TransSizeTool.transWidthSize(pxValue: 20))
            $0?.centerY.equalTo()(self)
        })
        switch type {
        case .CellViewArrowImageView:
            arrowImageView.mas_makeConstraints({
                $0?.centerY.equalTo()(self)
                $0?.right.mas_equalTo()(TransSizeTool.transWidthSize(pxValue:-30))
                $0?.size.mas_equalTo()(CGSize(width: TransSizeTool.transWidthSize(pxValue:46), height: TransSizeTool.transWidthSize(pxValue:46)))
            })
            rightIconImageView.mas_makeConstraints({
                $0?.centerY.equalTo()(self)
                $0?.right.equalTo()(arrowImageView.mas_left)
                $0?.size.mas_equalTo()(CGSize(width: TransSizeTool.transWidthSize(pxValue:46), height: TransSizeTool.transWidthSize(pxValue:46)))
            })
        case .CellViewArrowLabel:
            arrowImageView.mas_makeConstraints({
                $0?.centerY.equalTo()(self)
                $0?.right.mas_equalTo()(TransSizeTool.transWidthSize(pxValue:-30))
                $0?.size.mas_equalTo()(CGSize(width: TransSizeTool.transWidthSize(pxValue:46), height: TransSizeTool.transWidthSize(pxValue:46)))
            })
            rightLable.mas_makeConstraints({
                $0?.centerY.equalTo()(self)
                $0?.right.equalTo()(arrowImageView.mas_left)
            })
        case .CellViewSwich:
            swichUI.mas_makeConstraints({
                $0?.centerY.equalTo()(self)
                $0?.right.mas_equalTo()(TransSizeTool.transWidthSize(pxValue:-30))
            })
        case .CellViewDeleteAndAdd:
            deleteAndAddBtn.mas_makeConstraints({
                $0?.centerY.equalTo()(self)
                $0?.right.mas_equalTo()(TransSizeTool.transWidthSize(pxValue:-30))
                $0?.size.mas_equalTo()(CGSize(width: TransSizeTool.transWidthSize(pxValue:180), height: TransSizeTool.transHeightSize(pxValue:50)))
            })
            
        case .CellViewLeftImageWordRightCheckBox:
            leftImageView.mas_makeConstraints({
                $0?.centerY.equalTo()(self)
                $0?.left.mas_equalTo()(TransSizeTool.transWidthSize(pxValue:30))
                $0?.size.mas_equalTo()(CGSize(width: TransSizeTool.transWidthSize(pxValue:40), height: TransSizeTool.transWidthSize(pxValue:40)))
            })
            checkBoxImageView.mas_makeConstraints({
                $0?.right.equalTo()(TransSizeTool.transWidthSize(pxValue:-30))
                $0?.centerY.equalTo()(self)
                $0?.size.equalTo()(CGSize(width: TransSizeTool.transWidthSize(pxValue:30), height: TransSizeTool.transWidthSize(pxValue:30)))
            })
            
        case .CellViewLeftWordRightImage:
            checkBoxImageView.mas_makeConstraints({
                $0?.right.equalTo()(TransSizeTool.transWidthSize(pxValue:-30))
                $0?.centerY.equalTo()(self)
                $0?.size.equalTo()(CGSize(width: TransSizeTool.transWidthSize(pxValue:30), height: TransSizeTool.transWidthSize(pxValue:30)))
            })
        }
    }
    
    func updateLeftImageSize(size:CGSize) {
        leftImageView.mas_updateConstraints({
            $0?.size.equalTo()(CGSize(width: TransSizeTool.transWidthSize(pxValue: size.width), height: TransSizeTool.transWidthSize(pxValue: size.height)))
        })
    }
    func updateLeftImageLeftMargin(margin:CGFloat) {
        leftImageView.mas_updateConstraints({
            $0?.left.equalTo()(TransSizeTool.transWidthSize(pxValue: margin))
        })
    }
    
    //MARK: public method
    func hideDeleteAndAddBtn(isHidden:Bool) {
        deleteAndAddBtn.isHidden = isHidden
    }
    
    //MARK: Event
    fileprivate func configEvent() {
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(clickCell))
        addGestureRecognizer(gesture)
        
        if type == .CellViewSwich {
            swichUI.addTarget(self, action: #selector(clickSwich(swich:)), for: .valueChanged)
        } else if type == .CellViewDeleteAndAdd {
            deleteAndAddBtn.clickHandle = { [weak self] btn in
                if btn.tag == 10 {
                    self?.clickDeleteBtnHandle?(btn.isSelected)
                } else if btn.tag == 20 {
                    self?.clickAddBtnHandle?()
                }
            }
        }
    }
    
    @objc func clickCell() {
        clickCellHandle?(self)
    }
    
    @objc func clickSwich(swich:UISwitch) {
        clickSwichHandle?(swich.isOn)
    }
    
    //MARK: 懒加载
    lazy var titleLable    : UILabel = {
        let titleLable = UILabel()
        titleLable.font = TransSizeTool.transFontSize(fontSize: 30)
        titleLable.textColor = UIColor.lightGray
        return titleLable
    }()
    lazy var subtitleLable    : UILabel = {
        let titleLable = UILabel()
        titleLable.font = TransSizeTool.transFontSize(fontSize: 28)
        titleLable.textColor = UIColor.lightGray
        return titleLable
    }()
    
    lazy var separateLine  : UIView = {
       let line = UIView()
        line.backgroundColor = UIColor.lightGray
        line.isHidden = true
        return line
    }()
    
    lazy var arrowImageView    : UIImageView = {
        let arrowImageView = UIImageView()
        arrowImageView.image = UIImage.init(named: "general_btn_next")
        return arrowImageView
    }()
    
    lazy var rightIconImageView    : UIImageView = {
        let rightIconImageView = UIImageView()
        return rightIconImageView
    }()
    
    lazy var rightLable    : UILabel = {
        let rightLable = UILabel()
        rightLable.font = TransSizeTool.transFontSize(fontSize: 30)
        rightLable.textColor = UIColor.lightGray
        return rightLable
    }()
    
    lazy var swichUI  : UISwitch = {
        let swichUI = UISwitch()
        return swichUI
    }()
    
    lazy var deleteAndAddBtn = DeleteAndAddBtn()
    
    lazy var checkBoxImageView  : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "checkBox")
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var leftImageView  : UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
}

class DeleteAndAddBtn: UIView {
    
    var clickHandle : ((_ btn:UIButton) -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configView() {
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 3
        layer.borderWidth = 1
        layer.masksToBounds = true
        addSubview(delebtn)
        addSubview(addBtn)
        configEvent()
        configCons()
    }
    
    fileprivate func configEvent() {
        delebtn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        addBtn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
    }
    
    fileprivate func configCons() {
        delebtn.mas_makeConstraints({
            $0?.left.equalTo()(self)
            $0?.top.equalTo()(self)
            $0?.bottom.equalTo()(self.mas_bottom)
            $0?.right.equalTo()(addBtn.mas_left)
            $0?.width.equalTo()(addBtn.mas_width)
        })
        
        addBtn.mas_makeConstraints({
            $0?.right.equalTo()(self.mas_right)
            $0?.top.equalTo()(self)
            $0?.bottom.equalTo()(self.mas_bottom)
        })
    }
    
    //MARK: Event
    @objc func btnClick(btn:UIButton) {
        if btn.tag == 10 {//删除按钮
            btn.isSelected = !btn.isSelected
            if btn.isSelected {
                btn.backgroundColor = UIColor.lightGray
            } else {
                btn.backgroundColor = UIColor.white
            }
            clickHandle?(btn)
        } else if btn.tag == 20 {
            clickHandle?(btn)
        }
    }
    
    //MARK: 懒加载
    lazy var delebtn : UIButton = {
        let delebtn = UIButton(type:.custom)
        delebtn.tag = 10
        delebtn.titleLabel?.font = TransSizeTool.transFontSize(fontSize: 28)
        delebtn.setTitle(NSLocalizedString("delete_btn", comment: ""), for: .normal)
        delebtn.setTitle(NSLocalizedString("delete_btn", comment: ""), for: .selected)
        delebtn.setTitleColor(UIColor.lightGray, for: .normal)
        delebtn.setTitleColor(UIColor.white, for: .selected)
        return delebtn
    }()
    lazy var addBtn : UIButton = {
        let addBtn = UIButton(type:.custom)
        addBtn.tag = 20
        addBtn.titleLabel?.font = TransSizeTool.transFontSize(fontSize: 28)
        addBtn.setTitle(NSLocalizedString("add_tcl_text", comment: ""), for: .normal)
        addBtn.setTitle(NSLocalizedString("add_tcl_text", comment: ""), for: .selected)
        addBtn.setTitleColor(UIColor.lightGray, for: .normal)
        addBtn.setTitleColor(UIColor.white, for: .selected)
        return addBtn
    }()
    
    
    
    
}
