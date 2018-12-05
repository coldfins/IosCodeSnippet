//
//  ViewPagerIndicator.swift
//  ViewPagerIndicator
//
//  Created by Sai on 15/4/28.
//  Copyright (c) 2015年 Sai. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

//@IBDesignable
open class ViewPagerIndicator: UIControl {
    public enum IndicatorDirection{
        case top,bottom
    }
    open var indicatorDirection: IndicatorDirection = .bottom
    @IBInspectable open var indicatorHeight: CGFloat = 4.0
    var indicatorIndex = -1
    @IBInspectable open var animationDuration: CGFloat = 0.2
    @IBInspectable open var autoAdjustSelectionIndicatorWidth: Bool = false//下横线是否适应文字大小
    var isTransitioning = false//是否在移动
    open var bouncySelectionIndicator = true//选择器动画是否支持bouncy效果
    open var colors = Dictionary<String,UIColor>()
    open var titleFont :UIFont = UIFont(name: "Roboto-Medium", size:12.0)!{
        didSet{
          //  self.layoutIfNeeded()
        }
    }
    open var titles = NSMutableArray(){
        willSet(newTitles){
            //先移除后添加
            removeButtons()
            titles.addObjects(from: newTitles as [AnyObject])
        }
        didSet{
            addButtons()
        }
    }
    var buttons = NSMutableArray()

    
    var selectionIndicator: UIView!//选中标识
    var bottomLine: UIView!//底部横线
    @IBInspectable open var showBottomLine: Bool = true{
        didSet{
            bottomLine.isHidden = !showBottomLine
        }
    }
    open var delegate: ViewPagerIndicatorDelegate?
    open var count:Int {
        get{
            return titles.count
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    func commonInit(){
        selectionIndicator = UIView()
        bottomLine = UIView()
        self.addSubview(selectionIndicator)
        self.addSubview(bottomLine)
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        //设置默认选择哪个item
        if buttons.count == 0{
            indicatorIndex = -1
        }
        else if indicatorIndex < 0{
            indicatorIndex = 0
        }
        //button位置调整
        for index in 0 ..< buttons.count{
            let left = roundf((Float(self.bounds.size.width)/Float(self.buttons.count)) * Float(index))
            let width = roundf(Float(self.bounds.size.width)/Float(self.buttons.count))
            let button = buttons[index] as! UIButton
            button.frame = CGRect(x: CGFloat(left), y: 0, width: CGFloat(width),height: self.bounds.size.height)
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -4, 0)
            button.titleLabel?.font = titleFont
            
          
            button.titleLabel
            button.setTitleColor(titleColorForState(UIControlState()),for: UIControlState())
            button.setTitleColor(titleColorForState(UIControlState.selected),for: UIControlState.selected)

            if (index == indicatorIndex){
                button.isSelected = true
            }
        }
        selectionIndicator.frame = selectionIndicatorRect()
        bottomLine.frame = bottomLineRect()
        selectionIndicator.backgroundColor = UIColor.colorLikeNavigationBackground() //self.tintColor
        bottomLine.backgroundColor = UIColor.colorLikeNavigationBackground() //self.tintColor

        self.sendSubview(toBack: selectionIndicator)
    }
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.layoutIfNeeded()
    }
    
    //底线Rect
    func bottomLineRect() ->CGRect{
        //控件底部横线
        var frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 0.5)
        if(indicatorDirection == .top){
            frame.origin.y = 0
        }
        else{
            frame.origin.y = self.frame.size.height
        }
        
        return frame
    }
    //获取指示器的Rect
    func selectionIndicatorRect() ->CGRect{
        var frame = CGRect()
        let button = selectedButton()
        if indicatorIndex < 0 {return frame}
        let title = titles[indicatorIndex] as? NSString
        if title?.length<=0 || button == nil {return frame}
        
        if(indicatorDirection == .top){
            frame.origin.y = 0
        }
        else{
            frame.origin.y = button!.frame.size.height - indicatorHeight
        }
        
        //底部指示器如果宽度适应内容
        if(autoAdjustSelectionIndicatorWidth){
            var attributes:[AnyHashable: Any]!
            let attributedString = button?.attributedTitle(for: UIControlState.selected)
            attributes = attributedString?.attributes(at: 0, effectiveRange: nil)
           // frame.size = CGSizeMake(title!.sizeWithAttributes(attributes).width, indicatorHeight)
            //计算指示器x坐标
            frame.origin.x = (button!.frame.size.width * CGFloat(indicatorIndex)) + (button!.frame.width - frame.size.width)/2
        }
        else{//如果不是适应内容则宽度平分控件
            frame.size = CGSize(width: button!.frame.size.width, height: indicatorHeight)
            frame.origin.x = button!.frame.size.width * CGFloat(indicatorIndex)
        }
        
        return frame
    }
    //设置选中哪一个
    open func setSelectedIndex(_ index: Int){
        setSelected(true,index: index)
    }
    open func getSelectIndex() ->Int{
        return indicatorIndex
    }
    //设置选中哪一个
    func setSelected(_ selected: Bool, index: Int){
        if(isTransitioning || indicatorIndex == index){return}
        disableAllButtonsSelection()
        enableAllButtonsInteraction(false)
        
        let duration:CGFloat = indicatorIndex < 0 ? 0 : animationDuration
      
        indicatorIndex = index
        isTransitioning = true
        delegate?.indicatorChange(indicatorIndex)//通知代理
        
        let button = buttons[index] as! UIButton
        button.isSelected = true
        let damping: CGFloat = !bouncySelectionIndicator ? 0 : 0.6
        let velocity: CGFloat = !bouncySelectionIndicator ? 0 : 0.5
        //底部滑条的动画效果
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: UIViewAnimationOptions.beginFromCurrentState, animations: { () -> Void in
            self.selectionIndicator.frame = self.selectionIndicatorRect()
        }) { (_) -> Void in
            self.enableAllButtonsInteraction(true)
            button.isUserInteractionEnabled = false
            button.isSelected = true

            self.isTransitioning = false
        }
        sendActions(for: UIControlEvents.valueChanged)
        self.layoutIfNeeded()
    }
    //选中的button
    func selectedButton() ->UIButton?{
        if(indicatorIndex >= 0 && buttons.count > 0){
            return buttons[indicatorIndex] as? UIButton
        }
        return nil
    }
    func addButtons(){
        for i in 0 ..< titles.count  {
            let button = UIButton()
            button.addTarget(self, action: #selector(ViewPagerIndicator.didSelectedButton(_:)), for: .touchUpInside)

            button.isExclusiveTouch = true//禁止多个按钮同时被按下
            button.tag = i
            
            button.setTitle(titles[i] as? String, for: UIControlState())
//            button.setTitle(titles[i] as? String, forState: UIControlState.Highlighted)
//            button.setTitle(titles[i] as? String, forState: UIControlState.Selected)
//            button.setTitle(titles[i] as? String, forState: UIControlState.Disabled)

            
            self.addSubview(button)
            buttons.add(button)
            
        }
        selectionIndicator.frame = selectionIndicatorRect()
        
    }
    func removeButtons(){
        if(isTransitioning){return}
        for button in buttons{
            (button as AnyObject).removeFromSuperview()
        }
        buttons.removeAllObjects()
        titles.removeAllObjects()
    }

    func didSelectedButton(_ sender: UIButton){
        sender.isHighlighted = false
        sender.isSelected = true
        setSelectedIndex(sender.tag)
    }
    
    func titleColorForState(_ state: UIControlState) ->UIColor{
        
        if let color = colors[String(state.rawValue)]{
            return color
        }
        switch(state){
        case UIControlState():
            return UIColor.black
        case UIControlState.highlighted,UIControlState.selected:
            return UIColor.colorLikeNavigationBackground()
        case UIControlState.disabled:
            return UIColor.black
        default:
            return UIColor.black
        }
    }
    open func setTitleColorForState(_ color: UIColor, state: UIControlState){
        colors.updateValue(color, forKey: String(state.rawValue))
    }
    func disableAllButtonsSelection(){
        for button in buttons {
            (button as! UIButton).isSelected = false
        }
    }
    func enableAllButtonsInteraction(_ enable: Bool){
        for button in buttons {
            (button as! UIButton).isUserInteractionEnabled = enable
        }
    }
    
}
@objc
public protocol ViewPagerIndicatorDelegate{
    //返回当前选中第几个
    func indicatorChange(_ indicatorIndex: Int)
}
