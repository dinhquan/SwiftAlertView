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

    public enum AppearType {
        case `default`
        case fadeIn
        case flyFromTop
        case flyFromLeft
    }

    public enum DisappearType {
        case `default`
        case fadeOut
        case flyToBottom
        case flyToRight
    }

    
    // MARK: Public Properties
    
    public weak var delegate: SwiftAlertViewDelegate? // delegate

    public var titleLabel: UILabel! // access titleLabel to customize the title font, color
    public var messageLabel: UILabel! // access messageLabel to customize the message font, color
    
    public var cancelButtonIndex = 0 // default is 0, set this property if you want to change the position of cancel button

    public var backgroundImage: UIImage?
    // public var backgroundColor: UIColor? // inherits from UIView
    
    public var buttonTitleColor = UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1) // to change the title color of all buttons
    public var buttonHeight: CGFloat = 44.0 // default is 44
    
    public var separatorColor = UIColor(red: 196.0/255, green: 196.0/255, blue: 201.0/255, alpha: 1.0) // to change the separator color
    public var isHideSeparator = false // to hide the separater color
    public var cornerRadius: CGFloat = 8.0 // default is 8 px

    public var isDismissOnActionButtonClicked = true // default is true, if you want the alert view will not be dismissed when clicking on action buttons, set this property to false
    public var isHighlightOnButtonClicked = true // default is true
    public var isDimBackgroundWhenShowing = true // default is true
    public var isDismissOnOutsideTapped = false // default is false
    public var dimAlpha: CGFloat = 0.2 // default is 0.2

    public var appearTime = 0.2 // default is 0.2 second
    public var disappearTime = 0.1 // default is 0.1 second

    public var appearType: AppearType = .default // to change the appear type
    public var disappearType: DisappearType = .default // to change the disappear type
    
    // customize the margin & spacing of title & message
    public var titleSideMargin: CGFloat = 20.0  // default is 20 px
    public var messageSideMargin: CGFloat = 20.0  // default is 20 px
    public var titleTopMargin: CGFloat = 20.0  // default is 20 px
    public var messageBottomMargin: CGFloat = 20.0// default is 20 px
    public var titleToMessageSpacing: CGFloat = 20.0 // default is 10 px

    // closures for handling button clicked action
    public var onButtonClicked: ((_ buttonIndex: Int) -> Void)? // all buttons
    public var onCancelClicked: (() -> Void)? // for cancel button
    public var onActionButtonClicked: ((_ buttonIndex: Int) -> (Void))? // sometimes you want to handle the action button clicked event but don't want to write if/else in onButtonClicked closure, use this property


    // MARK: Constants
    
    private let kSeparatorWidth: CGFloat = 0.5
    private let kDefaultWidth: CGFloat = 270.0
    private let kDefaultHeight: CGFloat = 144.0
    private let kDefaultTitleSizeMargin: CGFloat = 20.0
    private let kDefaultMessageSizeMargin: CGFloat = 20.0
    private let kDefaultButtonHeight: CGFloat = 44.0
    private let kDefaultCornerRadius: CGFloat = 8.0
    private let kDefaultTitleTopMargin: CGFloat = 20.0
    private let kDefaultTitleToMessageSpacing: CGFloat = 10.0
    private let kDefaultMessageBottomMargin: CGFloat = 20.0
    private let kDefaultDimAlpha: CGFloat = 0.4
    private let kDefaultAppearTime = 0.2
    private let kDefaultDisappearTime = 0.1


    // MARK: Private Properties

    private var contentView: UIView?
    private var buttons: [UIButton] = []
    private var backgroundImageView: UIImageView?
    private var dimView: UIView?
    private var title: String?
    private var message: String?
    private var buttonTitles: [String] = []
    private var viewWidth: CGFloat = 0
    private var viewHeight: CGFloat = 0
    
    
    // MARK: Initialization

    public init(title: String? = nil,
                message: String? = nil,
                buttonTitles: [String] = [],
                cancelButtonIndex: Int = 0) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))
        setUp(title: title, message: message, buttonTitles: buttonTitles, cancelButtonIndex: cancelButtonIndex)
    }

    public init(contentView: UIView,
                buttonTitles: [String] = [],
                cancelButtonIndex: Int = 0) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))
        setUp(contentView: contentView, buttonTitles: buttonTitles, cancelButtonIndex: cancelButtonIndex)
    }
    
    public init(nibName: String,
                buttonTitles: [String] = [],
                cancelButtonIndex: Int = 0) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))
        guard let contentView = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as? UIView else {
            fatalError("Could not load nib file")
        }
        setUp(contentView: contentView, buttonTitles: buttonTitles, cancelButtonIndex: cancelButtonIndex)
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    
    // access the buttons to customize their font & color
    public func button(at index: Int) -> UIButton? {
        if index >= 0 && index < buttons.count {
            return buttons[index]
        }
        
        return nil
    }
    
    // show the alert view at center of screen
    public func show() {
        if let window: UIWindow = UIApplication.shared.keyWindow {
            show(in: window)
        }
    }
    
    // show the alert view at center of a view
    public func show(in view: UIView) {
        layoutElementBeforeShowing()
        
        frame = CGRect(x: (view.frame.size.width - viewWidth)/2, y: (view.frame.size.height - viewHeight)/2, width: viewWidth, height: viewHeight)

        if isDimBackgroundWhenShowing {
            dimView = UIView(frame: view.bounds)
            dimView!.backgroundColor = UIColor(white: 0, alpha: CGFloat(dimAlpha))
            view.addSubview(dimView!)
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(outsideTapped(_:)))
            dimView!.addGestureRecognizer(recognizer)
        }
        
        delegate?.willPresentAlertView?(self)

        view.addSubview(self)
        view.bringSubviewToFront(self)
        
        switch appearType {
        case .default:
            transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            alpha = 0.6

            UIView.animate(withDuration: appearTime) {
                self.transform = CGAffineTransform.identity
                self.alpha = 1
            } completion: { _ in
                self.delegate?.didPresentAlertView?(self)
            }
        case .fadeIn:
            alpha = 0

            UIView.animate(withDuration: appearTime, delay: 0, options: .curveEaseInOut) {
                self.alpha = 1
            } completion: { _ in
                self.delegate?.didPresentAlertView?(self)
            }
        case .flyFromTop:
            let tempFrame = frame
            frame = CGRect(x: frame.origin.x, y: 0 - frame.size.height - 10, width: frame.size.width, height: frame.size.height)

            UIView.animate(withDuration: appearTime, delay: 0, options: .curveEaseInOut) {
                self.frame = tempFrame
            } completion: { _ in
                self.delegate?.didPresentAlertView?(self)
            }
        case .flyFromLeft:
            let tempFrame = frame
            frame = CGRect(x: 0 - frame.size.width - 10, y: frame.origin.y, width: frame.size.width, height: frame.size.height)

            UIView.animate(withDuration: appearTime, delay: 0, options: .curveEaseInOut) {
                self.frame = tempFrame
            } completion: { _ in
                self.delegate?.didPresentAlertView?(self)
            }
        }
    }
    
    // dismiss the alert view programmatically
    public func dismiss() {
        self.delegate?.willDismissAlertView?(self)

        if dimView != nil {
            UIView.animate(withDuration: disappearTime) {
                self.dimView?.alpha = 0
            } completion: { _ in
                self.dimView?.removeFromSuperview()
                self.dimView = nil
            }
        }

        switch disappearType {
        case .default:
            transform = CGAffineTransform.identity

            UIView.animate(withDuration: disappearTime, delay: 0.02, options: .curveEaseOut) {
                self.alpha = 0
            } completion: { _ in
                self.removeFromSuperview()
                self.delegate?.didDismissAlertView?(self)
            }
        case .fadeOut:
            self.alpha = 1

            UIView.animate(withDuration: disappearTime, delay: 0.02, options: .curveEaseOut) {
                self.alpha = 0
            } completion: { _ in
                self.removeFromSuperview()
                self.delegate?.didDismissAlertView?(self)
            }
        case .flyToBottom:
            UIView.animate(withDuration: disappearTime, delay: 0.02, options: .curveEaseOut) {
                self.frame = CGRect(x: self.frame.origin.x, y: self.superview!.frame.size.height + 10, width: self.frame.size.width, height: self.frame.size.height)
            } completion: { _ in
                self.removeFromSuperview()
                self.delegate?.didDismissAlertView?(self)
            }
        case .flyToRight:
            UIView.animate(withDuration: disappearTime, delay: 0.02, options: .curveEaseOut) {
                self.frame = CGRect(x: self.superview!.frame.size.width + 10, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
            } completion: { _ in
                self.removeFromSuperview()
                self.delegate?.didDismissAlertView?(self)
            }
        }
    }
    
    // handle button click events
    public func handleButtonClicked(_ handler: @escaping (_ buttonIndex: Int) -> Void) {
        onButtonClicked = handler
    }
}


// MARK: Private Functions

extension SwiftAlertView {

    private func setUp(title: String? = nil,
                       message: String? = nil,
                       contentView: UIView? = nil,
                       buttonTitles: [String] = [],
                       cancelButtonIndex: Int = 0) {
        self.title = title
        self.message = message
        self.buttonTitles = buttonTitles
        self.cancelButtonIndex = cancelButtonIndex

        if let contentView = contentView {
            self.contentView = contentView
        }

        setUpDefaultValue()
        setUpElements()
        setUpDefaultAppearance()

        if let contentView = contentView {
            viewWidth = contentView.frame.size.width
        }
        
        if title == nil || message == nil {
            titleToMessageSpacing = 0
        }

        NotificationCenter.default.addObserver(self, selector: #selector(deviceDidRotate(_:)), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
    }
    
    @objc private func deviceDidRotate(_ aNotifitation: NSNotification) -> Void {
        dimView?.removeFromSuperview()
        dimView = nil
        show()
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
        isDimBackgroundWhenShowing = true
        isDismissOnActionButtonClicked = true
        isHighlightOnButtonClicked = true
        isDismissOnOutsideTapped = false
        isHideSeparator = false
        cornerRadius = kDefaultCornerRadius
        appearTime = kDefaultAppearTime
        disappearTime = kDefaultDisappearTime
        appearType = .default
        disappearType = .default
        buttonTitleColor = UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)
        layer.cornerRadius = CGFloat(cornerRadius)
    }
    
    private func setUpElements() {
        titleLabel = UILabel(frame: .zero)
        messageLabel = UILabel(frame: .zero)
        
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

        for buttonTitle in buttonTitles {
            let button = UIButton(type: .custom)
            button.setTitle(buttonTitle, for: .normal)
            buttons.append(button)
            addSubview(button)
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
            titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
            titleLabel.textColor = UIColor.black
            titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
            titleLabel.textAlignment = NSTextAlignment.center
            titleLabel.backgroundColor = .clear
        }
        
        if message != nil {
            messageLabel.numberOfLines = 0
            messageLabel.lineBreakMode = .byWordWrapping
            messageLabel.textColor = .black
            messageLabel.font = UIFont.systemFont(ofSize: 13)
            if title == nil {
                messageLabel.font = UIFont.boldSystemFont(ofSize: 17)
            }
            messageLabel.textAlignment = .center
            messageLabel.backgroundColor = .clear
        }
        
        var i = 0
        for button in buttons {
            button.tag = i
            i += 1
            button.backgroundColor = .clear
            button.setTitleColor(buttonTitleColor, for: .normal)
            if button.tag == cancelButtonIndex {
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            } else {
                button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            }
        }
    }
    
    private func layoutElementBeforeShowing() {
        var i = 0
        for button in buttons {
            button.tag = i
            i += 1
            
            if !buttonTitleColor.isEqual(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)) {
                button.setTitleColor(buttonTitleColor, for: .normal)
            }
            
            button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
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
            titleLabel.center = CGPoint(x: viewWidth/2, y: titleTopMargin + titleLabel.frame.size.height/2)
        }
        if message != nil {
            messageLabel.center = CGPoint(x: viewWidth/2, y: titleTopMargin + titleLabel.frame.size.height + titleToMessageSpacing + messageLabel.frame.size.height/2)
        }
        
        let topPartHeight = (contentView == nil) ? (titleTopMargin + titleLabel.frame.size.height + titleToMessageSpacing + messageLabel.frame.size.height + messageBottomMargin) : contentView!.frame.size.height
        
        if buttons.count == 2 {
            viewHeight = topPartHeight + buttonHeight
            let leftButton = buttons[0]
            let rightButton = buttons[1]
            leftButton.frame = CGRect(x: 0, y: viewHeight-buttonHeight, width: viewWidth/2, height: buttonHeight)
            rightButton.frame = CGRect(x: viewWidth/2, y: viewHeight-buttonHeight, width: viewWidth/2, height: buttonHeight)
            
            if !isHideSeparator {
                let horLine = UIView(frame: CGRect(x: 0, y: leftButton.frame.origin.y, width: viewWidth, height: kSeparatorWidth))
                horLine.backgroundColor = separatorColor
                addSubview(horLine)
                
                let verLine = UIView(frame: CGRect(x: viewWidth/2, y: leftButton.frame.origin.y, width: kSeparatorWidth, height: leftButton.frame.size.height))
                verLine.backgroundColor = separatorColor
                addSubview(verLine)
            }

        } else {
            viewHeight = topPartHeight + buttonHeight * CGFloat(buttons.count)
            var j = 1
            
            for button in buttons.reversed() {
                button.frame = CGRect(x: 0, y: viewHeight-buttonHeight*CGFloat(j), width: viewWidth, height: buttonHeight)
                j += 1
                if !isHideSeparator {
                    let lineView = UIView(frame: CGRect(x: 0, y: button.frame.origin.y, width: viewWidth, height: kSeparatorWidth))
                    lineView.backgroundColor = separatorColor
                    addSubview(lineView)
                }
            }
        }
    }
    
    
    // MARK: Actions
    
    @objc private func buttonClicked(_ button: UIButton) {
        if (isHighlightOnButtonClicked) {
            let originColor = button.backgroundColor?.withAlphaComponent(0)
            button.backgroundColor = button.backgroundColor?.withAlphaComponent(0.1)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                button.backgroundColor = originColor
            })
        }
        
        let buttonIndex = button.tag
        
        delegate?.alertView?(self, clickedButtonAtIndex: buttonIndex)

        onButtonClicked?(buttonIndex)

        if buttonIndex == cancelButtonIndex {
            onCancelClicked?()
        } else {
            onActionButtonClicked?(buttonIndex)
        }
        
        if isDismissOnActionButtonClicked {
            dismiss()
        } else if buttonIndex == cancelButtonIndex {
            dismiss()
        }
    }
    
    @objc func outsideTapped(_ recognizer: UITapGestureRecognizer) {
        if isDismissOnOutsideTapped {
            dismiss()
        }
    }
    
    
    // MARK: Utils
    
    private func labelHeightToFit(_ label: UILabel) {
        let maxWidth = label.frame.size.width
        let maxHeight : CGFloat = 10000
        let rect = label.attributedText?.boundingRect(with: CGSize(width: maxWidth, height: maxHeight),
                                                      options: .usesLineFragmentOrigin, context: nil)
        var frame = label.frame
        frame.size.height = rect!.size.height
        label.frame = frame
    }
}


extension SwiftAlertView {

    @discardableResult
    public static func show(title: String? = nil,
                            message: String? = nil,
                            buttonTitles: [String] = [],
                            cancelButtonIndex: Int = 0,
                            configure: ((_ alertView: SwiftAlertView) -> Void)? = nil) -> SwiftAlertView {
        let alertView = SwiftAlertView(title: title,
                                       message: message,
                                       buttonTitles: buttonTitles.isEmpty ? ["OK"] : buttonTitles,
                                       cancelButtonIndex: cancelButtonIndex)
        configure?(alertView)
        alertView.show()
        return alertView
    }
}


@objc public protocol SwiftAlertViewDelegate : NSObjectProtocol {

    @objc optional func alertView(_ alertView: SwiftAlertView, clickedButtonAtIndex buttonIndex: Int)
    
    @objc optional func willPresentAlertView(_ alertView: SwiftAlertView) // before animation and showing view
    @objc optional func didPresentAlertView(_ alertView: SwiftAlertView) // after animation
    
    @objc optional func willDismissAlertView(_ alertView: SwiftAlertView) // before animation and showing view
    @objc optional func didDismissAlertView(_ alertView: SwiftAlertView) // after animation
}
