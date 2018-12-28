
class TransSizeTool:NSObject {
    class func transFormHanYuToPingYin(str:NSString)->NSString {
        let pinyin = str.mutableCopy() as! CFMutableString
        CFStringTransform(pinyin, nil, kCFStringTransformToLatin, false)
        print("被转的汉字是:\(str),转换后是:\(pinyin)")
        return pinyin
    }

    class func transFontSize(fontSize:CGFloat) -> UIFont{
        let size = self.transWidthSize(pxValue: fontSize)
        return UIFont.systemFont(ofSize: size)
    }

    class func transWidthSize(pxValue:CGFloat) -> CGFloat{
        let size = (pxValue * UIScreen.main.bounds.width / referenceWidthSize)
        return size;
    }

    class func transHeightSize(pxValue:CGFloat) -> CGFloat{
        let size = (pxValue * UIScreen.main.bounds.height / referenceHeightSize)
        return size;
    }
}
