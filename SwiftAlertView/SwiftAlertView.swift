//
//  SwiftAlertView.swift
//  SwiftAlertView
//
//  Created by Dinh Quan on 8/26/15.
//  Copyright (c) 2015 Dinh Quan. All rights reserved.
//
// This code is distributed under the terms and conditions of the MIT license.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import UIKit

public class SwiftAlertView: UIView {
    
    
    // MARK: Public Properties
    
    public weak var delegate: SwiftAlertViewDelegate? // delegate

    public var titleLabel: UILabel! // access titleLabel to customize the title font, color
    public var messageLabel: UILabel! // access messageLabel to customize the message font, color
    
    public var cancelButtonIndex: Int! // default is 0, set this property if you want to change the position of cancel button

    public var backgroundImage: UIImage?
    // public var backgroundColor: UIColor? // inherits from UIView
    
    public var buttonTitleColor: UIColor! // to change the title color of all buttons
    public var buttonHeight: Double! // default is 44
    
    public var separatorColor: UIColor! // to change the separator color
    public var hideSeparator: Bool! // to hide the separater color
    public var cornerRadius: Double! // default is 8 px

    public var dismissOnOtherButtonClicked: Bool! // default is true, if you want the alert view will not be dismissed when clicking on other buttons, set this property to false
    public var highlightOnButtonClicked: Bool! // default is true
    public var dimBackgroundWhenShowing: Bool! // default is true
    public var dimAlpha: Double! // default is 0.2
    public var dismissOnOutsideClicked: Bool! // default is false

    public var appearTime: Double! // default is 0.2 second
    public var disappearTime: Double! // default is 0.1 second

    public var appearType: SwiftAlertViewAppearType! // to change the appear type
    public var disappearType: SwiftAlertViewDisappearType! // to change the disappear type
    
    // customize the margin & spacing of title & message
    public var titleSideMargin: Double!  // default is 20 px
    public var messageSideMargin: Double!  // default is 20 px
    public var titleTopMargin: Double!  // default is 20 px
    public var messageBottomMargin: Double! // default is 20 px
    public var titleToMessageSpacing: Double! // default is 10 px

    // closure for handling button clicked action
    public var clickedButtonAction:((buttonIndex: Int) -> (Void))? // all buttons
    public var clickedCancelButtonAction:((Void) -> (Void))? // for cancel button
    public var clickedOtherButtonAction:((buttonIndex: Int) -> (Void))? // sometimes you want to handle the other button click event but don't want to write if/else in clickedButtonAction closure, use this property

    /** Example of using these closures
    alertView.clickedButtonAction = {(buttonIndex) -> Void in
        println("Button Clicked At Index \(buttonIndex)")
    }
    alertView.clickedCancelButtonAction = {
        println("Cancel Button Clicked")
    }
    alertView.clickedOtherButtonAction = {(buttonIndex) -> Void in
        println("Other Button Clicked At Index \(buttonIndex)")
    }
    */
    
    // MARK: Constants
    
    private let kSeparatorWidth = 0.5
    private let kDefaultWidth = 270.0
    private let kDefaultHeight = 144.0
    private let kDefaultTitleSizeMargin = 20.0
    private let kDefaultMessageSizeMargin = 20.0
    private let kDefaultButtonHeight = 44.0
    private let kDefaultCornerRadius = 8.0
    private let kDefaultTitleTopMargin = 20.0
    private let kDefaultTitleToMessageSpacing = 10.0
    private let kDefaultMessageBottomMargin = 20.0
    private let kDefaultDimAlpha = 0.4
    
    
    // MARK: Private Properties
    private var contentView: UIView?
    private var buttons = [UIButton]()
    private var backgroundImageView: UIImageView?
    private var dimView: UIView?
    private var title: String?
    private var message: String?
    private var cancelButtonTitle: String?
    private var otherButtonTitles = [String]()
    private var viewWidth: Double!
    private var viewHeight: Double!
    
    
    // MARK: Init
    
    // init with title and message, set title to nil to make alert be no title, same with message
    public init(title: String?, message: String?, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles: String...) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))
        setUp(title, message: message, contentView: nil, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: otherButtonTitles)
    }
    
    // init with title and message, use this constructor in case of only one button
    public init(title: String?, message: String?, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))
        setUp(title, message: message, contentView: nil, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: nil)
    }
    
    public init(title: String?, message: String?, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles: [String]?) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))
        setUp(title, message: message, contentView: nil, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: otherButtonTitles)
    }
    
    // init with custom content view
    public init(contentView: UIView!, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles: String...) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))

        setUp(nil, message: nil, contentView: contentView, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: otherButtonTitles)
    }
    
    public init(contentView: UIView!, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))
        
        setUp(nil, message: nil, contentView: contentView, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: nil)
    }
    
    public init(contentView: UIView!, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles: [String]?) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))
        
        setUp(nil, message: nil, contentView: contentView, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: otherButtonTitles)
    }
    
    // init with custom nib file from main bundle, make sure this file exists
    public init(nibName: String!, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles: String...) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))
    
        let contentView = NSBundle.mainBundle().loadNibNamed(nibName, owner: nil, options: nil).first as? UIView
        setUp(nil, message: nil, contentView: contentView, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: otherButtonTitles)
    }
    
    public init(nibName: String!, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))
        
        let contentView = NSBundle.mainBundle().loadNibNamed(nibName, owner: nil, options: nil).first as? UIView

        setUp(nil, message: nil, contentView: contentView, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: nil)
    }
    
    public init(nibName: String!, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles: [String]?) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))
        
        let contentView = NSBundle.mainBundle().loadNibNamed(nibName, owner: nil, options: nil).first as? UIView
        setUp(nil, message: nil, contentView: contentView, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: otherButtonTitles)
    }
    
    
    // MARK: Public Functions
    
    // access the buttons to customize their font & color
    public func buttonAtIndex(index: Int) -> UIButton? {
        if index >= 0 && index < buttons.count {
            return buttons[index]
        }
        
        return nil
    }
    
    // show the alert view at center of screen
    public func show() {
        if let window: UIWindow = UIApplication.sharedApplication().keyWindow {
            show(window)
        }
    }
    
    // show the alert view at center of a view
    public func show(view: UIView) {
        layoutElementBeforeShowing()
        
        self.frame = CGRect(x: (Double(view.frame.size.width) - viewWidth)/2, y: (Double(view.frame.size.height) - viewHeight)/2, width: viewWidth, height: viewHeight)

        if dimBackgroundWhenShowing == true {
            dimView = UIView(frame: view.bounds)
            dimView!.backgroundColor = UIColor(white: 0, alpha: CGFloat(dimAlpha))
            view.addSubview(dimView!)
            let recognizer = UITapGestureRecognizer(target: self, action: Selector("outsideClicked:"))
            dimView!.addGestureRecognizer(recognizer)
        }
        
        if delegate?.respondsToSelector(Selector("willPresentAlertView:")) == true {
            delegate?.willPresentAlertView!(self)
        }
        
        view.addSubview(self)
        view.bringSubviewToFront(self)
        
        if appearType == SwiftAlertViewAppearType.Default {
            self.transform = CGAffineTransformMakeScale(1.1, 1.1)
            self.alpha = 0.6
            UIView.animateWithDuration(appearTime, animations: { () -> Void in
                self.transform = CGAffineTransformIdentity
                self.alpha = 1
                }) { (finished) -> Void in
                    if self.delegate?.respondsToSelector(Selector("didPresentAlertView:")) == true {
                        self.delegate?.didPresentAlertView!(self)
                    }
            };
        } else if appearType == SwiftAlertViewAppearType.FadeIn {
            self.alpha = 0
            UIView.animateWithDuration(appearTime, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.alpha = 1
            }, completion: { (finished) -> Void in
                if self.delegate?.respondsToSelector(Selector("didPresentAlertView:")) == true {
                    self.delegate?.didPresentAlertView!(self)
                }
            })
        } else if appearType == SwiftAlertViewAppearType.FlyFromTop {
            let tempFrame = self.frame
            self.frame = CGRectMake(self.frame.origin.x, 0 - self.frame.size.height - 10, self.frame.size.width, self.frame.size.height)
            UIView.animateWithDuration(appearTime, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.frame = tempFrame
                }, completion: { (finished) -> Void in
                    if self.delegate?.respondsToSelector(Selector("didPresentAlertView:")) == true {
                        self.delegate?.didPresentAlertView!(self)
                    }
            })
        } else if appearType == SwiftAlertViewAppearType.FlyFromLeft {
            let tempFrame = self.frame
            self.frame = CGRectMake(0 - self.frame.size.width - 10, self.frame.origin.y, self.frame.size.width, self.frame.size.height)
            UIView.animateWithDuration(appearTime, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.frame = tempFrame
                }, completion: { (finished) -> Void in
                    if self.delegate?.respondsToSelector(Selector("didPresentAlertView:")) == true {
                        self.delegate?.didPresentAlertView!(self)
                    }
            })
        }
    }
    
    // programmatically dismiss the alert view
    public func dismiss() {
        if self.delegate?.respondsToSelector(Selector("willDismissAlertView:")) == true {
            self.delegate?.willDismissAlertView!(self)
        }
        
        if dimView != nil {
            UIView.animateWithDuration(disappearTime, animations: { () -> Void in
                self.dimView?.alpha = 0
                }, completion: { (finished) -> Void in
                    self.dimView?.removeFromSuperview()
            })
        }
        
        if disappearType == SwiftAlertViewDisappearType.Default {
            self.transform = CGAffineTransformIdentity
            UIView.animateWithDuration(disappearTime, delay: 0.02, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.alpha = 0
                }) { (finished) -> Void in
                    self.removeFromSuperview()
                    if self.delegate?.respondsToSelector(Selector("didDismissAlertView:")) == true {
                        self.delegate?.didDismissAlertView!(self)
                    }
            }
        } else if disappearType == SwiftAlertViewDisappearType.FadeOut {
            self.alpha = 1
            UIView.animateWithDuration(disappearTime, delay: 0.02, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.alpha = 0
                }) { (finished) -> Void in
                    self.removeFromSuperview()
                    if self.delegate?.respondsToSelector(Selector("didDismissAlertView:")) == true {
                        self.delegate?.didDismissAlertView!(self)
                    }
            }
        } else if disappearType == SwiftAlertViewDisappearType.FlyToBottom {
            UIView.animateWithDuration(disappearTime, delay: 0.02, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.frame = CGRectMake(self.frame.origin.x, self.superview!.frame.size.height + 10, self.frame.size.width, self.frame.size.height)
                }) { (finished) -> Void in
                    self.removeFromSuperview()
                    if self.delegate?.respondsToSelector(Selector("didDismissAlertView:")) == true {
                        self.delegate?.didDismissAlertView!(self)
                    }
            }
        } else if disappearType == SwiftAlertViewDisappearType.FlyToRight {
            UIView.animateWithDuration(disappearTime, delay: 0.02, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.frame = CGRectMake(self.superview!.frame.size.width + 10, self.frame.origin.y, self.frame.size.width, self.frame.size.height)
                }) { (finished) -> Void in
                    self.removeFromSuperview()
                    if self.delegate?.respondsToSelector(Selector("didDismissAlertView:")) == true {
                        self.delegate?.didDismissAlertView!(self)
                    }
            }
        }



    }
    
    // declare the closure to handle clicked button event
    public func handleClickedButtonAction(action: (buttonIndex: Int) -> (Void)) {
        clickedButtonAction = action
    }
    

    // MARK: Private Functions

    private func setUp(title: String?, message: String?, contentView: UIView?, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles: [String]?) {
        self.delegate = delegate
        self.title = title
        self.message = message
        self.cancelButtonTitle = cancelButtonTitle
        if otherButtonTitles != nil {
            self.otherButtonTitles = otherButtonTitles!
        }
        if contentView != nil {
            self.contentView = contentView
        }
        setUpDefaultValue()
        setUpElements()
        setUpDefaultAppearance()
        if contentView != nil {
            viewWidth = Double(self.contentView!.frame.size.width)
        }
        
        if title == nil || message == nil {
            titleToMessageSpacing = 0
        }
    }

    private func setUpDefaultValue() {
        clipsToBounds = true
        viewWidth = kDefaultWidth
        viewHeight = kDefaultHeight
        titleSideMargin = kDefaultTitleSizeMargin
        messageSideMargin = kDefaultMessageSizeMargin
        buttonHeight = kDefaultButtonHeight
        titleTopMargin = kDefaultTitleTopMargin
        titleToMessageSpacing = kDefaultTitleToMessageSpacing
        messageBottomMargin = kDefaultMessageBottomMargin
        dimAlpha = kDefaultDimAlpha
        dimBackgroundWhenShowing = true
        dismissOnOtherButtonClicked = true
        highlightOnButtonClicked = true
        dismissOnOutsideClicked = false
        hideSeparator = false
        cornerRadius = kDefaultCornerRadius
        cancelButtonIndex = 0
        appearTime = 0.2
        disappearTime = 0.1
        appearType = SwiftAlertViewAppearType.Default
        disappearType = SwiftAlertViewDisappearType.Default
        separatorColor = UIColor(red: 196.0/255, green: 196.0/255, blue: 201.0/255, alpha: 1.0)
        buttonTitleColor = UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)
        layer.cornerRadius = CGFloat(cornerRadius)
    }
    
    private func setUpElements() {
        titleLabel = UILabel(frame: CGRectZero)
        messageLabel = UILabel(frame: CGRectZero)
        
        if title != nil {
            titleLabel.text = title
            addSubview(titleLabel)
        }
        if message != nil {
            messageLabel.text = message
            addSubview(messageLabel)
        }
        
        if let contentView = contentView {
            contentView.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)
            
            addSubview(contentView)
        }
        
        if let cancelTitle = cancelButtonTitle {
            let cancelButton = UIButton(type: UIButtonType.Custom)
            cancelButton.setTitle(cancelTitle, forState: UIControlState.Normal)
            buttons.append(cancelButton)
            addSubview(cancelButton)
        }
        
        for otherTitle in otherButtonTitles {
            let otherButton = UIButton(type: UIButtonType.Custom)
            
            otherButton.setTitle(otherTitle, forState: UIControlState.Normal)
            buttons.append(otherButton)
            addSubview(otherButton)
        }
    }
    
    private func setUpDefaultAppearance() {
        self.backgroundColor = UIColor(red: 245.0/255, green: 245.0/255, blue: 245.0/255, alpha: 1)
        if let backgroundImage = backgroundImage {
            backgroundImageView = UIImageView(frame: self.bounds)
            backgroundImageView?.image = backgroundImage
            addSubview(backgroundImageView!)
            sendSubviewToBack(backgroundImageView!)
        }
        
        if title != nil {
            titleLabel.numberOfLines = 0
            titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            titleLabel.textColor = UIColor.blackColor()
            titleLabel.font = UIFont.boldSystemFontOfSize(17)
            titleLabel.textAlignment = NSTextAlignment.Center
            titleLabel.backgroundColor = UIColor.clearColor()
        }
        
        if message != nil {
            messageLabel.numberOfLines = 0
            messageLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            messageLabel.textColor = UIColor.blackColor()
            messageLabel.font = UIFont.systemFontOfSize(13)
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.backgroundColor = UIColor.clearColor()
        }
        
        var i = 0
        for button in buttons {
            button.tag = i
            i++
            button.backgroundColor = UIColor.clearColor()
            button.setTitleColor(buttonTitleColor, forState: UIControlState.Normal)
            if button.tag == cancelButtonIndex {
                button.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
            } else {
                button.titleLabel?.font = UIFont.systemFontOfSize(17)
            }
        }
    }
    
    private func layoutElementBeforeShowing() {
        // Reorder buttons
        if cancelButtonTitle != nil {
            if cancelButtonIndex > 0 && cancelButtonIndex < buttons.count {
                let cancelButton = buttons.removeAtIndex(0)
                buttons.insert(cancelButton, atIndex: cancelButtonIndex)
            }
        }
        
        var i = 0
        for button in buttons {
            button.tag = i
            i++
            
            if !buttonTitleColor.isEqual(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)) {
                button.setTitleColor(buttonTitleColor, forState: UIControlState.Normal)
            }
            
            button.addTarget(self, action: Selector("buttonClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        if title != nil {
            titleLabel.frame = CGRect(x: 0, y: 0, width: viewWidth - titleSideMargin*2, height: 0)
            labelHeightToFit(titleLabel)
        }
        if message != nil {
            messageLabel.frame = CGRect(x: 0, y: 0, width: viewWidth - messageSideMargin*2, height: 0)
            labelHeightToFit(messageLabel)
        }
        if title != nil {
            titleLabel.center = CGPoint(x: viewWidth/2, y: titleTopMargin + Double(titleLabel.frame.size.height)/2)
        }
        if message != nil {
            messageLabel.center = CGPoint(x: viewWidth/2, y: titleTopMargin + Double(titleLabel.frame.size.height) + titleToMessageSpacing + Double(messageLabel.frame.size.height)/2)
        }
        
        let topPartHeight = (contentView == nil) ? (titleTopMargin + Double(titleLabel.frame.size.height) + titleToMessageSpacing + Double(messageLabel.frame.size.height) + messageBottomMargin) : Double(contentView!.frame.size.height)
        
        if buttons.count == 2 {
            viewHeight = topPartHeight + buttonHeight
            let leftButton = buttons[0]
            let rightButton = buttons[1]
            leftButton.frame = CGRect(x: 0, y: viewHeight-buttonHeight, width: viewWidth/2, height: buttonHeight)
            rightButton.frame = CGRect(x: viewWidth/2, y: viewHeight-buttonHeight, width: viewWidth/2, height: buttonHeight)
            
            if hideSeparator == false {
                let horLine = UIView(frame: CGRect(x: 0, y: Double(leftButton.frame.origin.y), width: viewWidth, height: kSeparatorWidth))
                horLine.backgroundColor = separatorColor
                addSubview(horLine)
                
                let verLine = UIView(frame: CGRect(x: viewWidth/2, y: Double(leftButton.frame.origin.y), width: kSeparatorWidth, height: Double(leftButton.frame.size.height)))
                verLine.backgroundColor = separatorColor
                addSubview(verLine)
            }

        } else {
            viewHeight = topPartHeight + buttonHeight * Double(buttons.count)
            var j = 1
            for var i = buttons.count - 1; i >= 0; i = i - 1 {
                let button = buttons[i]
                button.frame = CGRect(x: 0, y: viewHeight-buttonHeight*Double(j), width: viewWidth, height: buttonHeight)
                j++
                if hideSeparator == false {
                    let lineView = UIView(frame: CGRect(x: 0, y: Double(button.frame.origin.y), width: viewWidth, height: kSeparatorWidth))
                    lineView.backgroundColor = separatorColor
                    addSubview(lineView)
                }
            }
        }
    }
    
    
    // MARK: Actions
    
    func buttonClicked(button: UIButton) {
        if (highlightOnButtonClicked == true) {
            let originColor = button.backgroundColor?.colorWithAlphaComponent(0)
            button.backgroundColor = button.backgroundColor?.colorWithAlphaComponent(0.1)
            let delayTime = dispatch_time(DISPATCH_TIME_NOW,
                Int64(0.2 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue(), { () -> Void in
                button.backgroundColor = originColor
            })
        }
        
        let buttonIndex = button.tag
        
        if delegate?.respondsToSelector(Selector("alertView:clickedButtonAtIndex:")) == true {
            delegate?.alertView!(self, clickedButtonAtIndex: buttonIndex)
        }
        
        if clickedButtonAction != nil {
            clickedButtonAction!(buttonIndex: buttonIndex)
        }
        
        if buttonIndex == cancelButtonIndex {
            if clickedCancelButtonAction != nil {
                clickedCancelButtonAction!()
            }
        } else {
            if clickedOtherButtonAction != nil {
                clickedOtherButtonAction!(buttonIndex: buttonIndex)
            }
        }
        
        if dismissOnOtherButtonClicked == true {
            dismiss()
        } else if buttonIndex == cancelButtonIndex {
            dismiss()
        }
    }
    
    func outsideClicked(recognizer: UITapGestureRecognizer) {
        if let v = dismissOnOutsideClicked {
            if v == true {
                dismiss()
            }
        }
        
    }
    
    
    // MARK: Utils
    
    private func labelHeightToFit(label: UILabel) {
        let maxWidth = label.frame.size.width
        let maxHeight : CGFloat = 10000
        let rect = label.attributedText?.boundingRectWithSize(CGSizeMake(maxWidth, maxHeight),
            options: .UsesLineFragmentOrigin, context: nil)
        var frame = label.frame
        frame.size.height = rect!.size.height
        label.frame = frame
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension SwiftAlertView {
    
    public static func show(title title: String?, message: String?, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles: [String]?, configureAppearance:(alertView: SwiftAlertView)->(Void), clickedButtonAction:(buttonIndex: Int)->(Void)){
        let alertView = SwiftAlertView(title: title, message: message, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: otherButtonTitles)
        alertView.handleClickedButtonAction(clickedButtonAction)
        configureAppearance(alertView: alertView)
        alertView.show()
    }
}


public enum SwiftAlertViewAppearType : Int {
    
    case Default
    case FadeIn
    case FlyFromTop
    case FlyFromLeft
}


public enum SwiftAlertViewDisappearType : Int {
    
    case Default
    case FadeOut
    case FlyToBottom
    case FlyToRight
}


@objc public protocol SwiftAlertViewDelegate : NSObjectProtocol{
    
    // Called when a button is clicked.
    optional func alertView(alertView: SwiftAlertView, clickedButtonAtIndex buttonIndex: Int)
    
    optional func willPresentAlertView(alertView: SwiftAlertView) // before animation and showing view
    optional func didPresentAlertView(alertView: SwiftAlertView) // after animation
    
    optional func willDismissAlertView(alertView: SwiftAlertView) // before animation and showing view
    optional func didDismissAlertView(alertView: SwiftAlertView) // after animation
    
}