
let ignoreTag : Int = 666
let referenceSize : CGFloat = 375.0
class Adapter:NSObject {
    class func transToHanYuToPingYin(str:NSString)->NSString {
        let pinyin = str.mutableCopy() as! CFMutableString
        CFStringTransform(pinyin, nil, kCFStringTransformToLatin, false)
        print("被转的汉字是:\(str),转换后是:\(pinyin)")
        return pinyin
    }

    class func adaptFontSize(fontSize:CGFloat) -> UIFont{
        let size = self.adaptSize(pxValue: fontSize)
        return UIFont.systemFont(ofSize: size)
    }

    class func adaptSize(pxValue:CGFloat) -> CGFloat{
        let size = (pxValue * UIScreen.main.bounds.width / referenceSize)
        return size;
    }
}

extension NSLayoutConstraint {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if identifier == "\(ignoreTag)" {return}
        self.constant = self.constant * UIScreen.main.bounds.width / referenceSize
    }
}

extension UILabel {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if tag == ignoreTag {return}
        font = UIFont.systemFont(ofSize: font.pointSize * UIScreen.main.bounds.width / referenceSize)
    }
}
extension UIButton {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if tag == ignoreTag {return}
        guard titleLabel != nil else {return}
        titleLabel!.font = UIFont.systemFont(ofSize: titleLabel!.font.pointSize * UIScreen.main.bounds.width / referenceSize)
    }
}
extension UITextField {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if tag == ignoreTag {return}
        guard font != nil else {return}
        font = UIFont.systemFont(ofSize: (font?.pointSize)! * UIScreen.main.bounds.width / referenceSize)
    }
}
