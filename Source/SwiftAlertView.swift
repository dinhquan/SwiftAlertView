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
    
    public enum Style {
        case auto
        case light
        case dark
    }

    public enum TransitionType {
        case `default`
        case fade
        case vertical
    }

    
    // MARK: Public Properties
    
    public weak var delegate: SwiftAlertViewDelegate?
    
    public var style: Style = .auto { // default is based on system color
        didSet {
            updateAlertStyle()
        }
    }

    public var titleLabel: UILabel! // access titleLabel to customize the title font, color
    public var messageLabel: UILabel! // access messageLabel to customize the message font, color
    
    public var backgroundImage: UIImage?
    // public var backgroundColor: UIColor? // inherits from UIView
    
    public var cancelButtonIndex = 0 { // default is 0, set this property if you want to change the position of cancel button
        didSet {
            updateCancelButtonIndex()
        }
    }
    public var buttonTitleColor = UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1) // to change the title color of all buttons
    public var buttonHeight: CGFloat = 44.0
    
    public var separatorColor = UIColor(red: 196.0/255, green: 196.0/255, blue: 201.0/255, alpha: 1.0) // to change the separator color
    public var isHideSeparator = false
    public var cornerRadius: CGFloat = 12.0

    public var isDismissOnActionButtonClicked = true // default is true, if you want the alert view will not be dismissed when clicking on action buttons, set this property to false
    public var isHighlightOnButtonClicked = true
    public var isDimBackgroundWhenShowing = true
    public var isDismissOnOutsideTapped = false
    public var dimAlpha: CGFloat = 0.4
    public var dimBackgroundColor: UIColor? = .init(white: 0, alpha: 0.4)

    public var appearTime = 0.2
    public var disappearTime = 0.1

    public var transitionType: TransitionType = .default
    
    // customize the margin & spacing of title & message
    public var titleSideMargin: CGFloat = 20.0
    public var messageSideMargin: CGFloat = 20.0
    public var titleTopMargin: CGFloat = 20.0
    public var messageBottomMargin: CGFloat = 20.0
    public var titleToMessageSpacing: CGFloat = 20.0
    
    // customize text fields
    public var textFieldHeight: CGFloat = 34.0
    public var textFieldSideMargin: CGFloat = 15.0
    public var textFieldBottomMargin: CGFloat = 15.0
    public var textFieldSpacing: CGFloat = 10.0
    public var isFocusTextFieldWhenShowing = true
    public var isEnabledValidationLabel = false
    public var validationLabel: UILabel! // access to validation label to customize font, color
    public var validationLabelTopMargin: CGFloat = 8.0
    public var validationLabelSideMargin: CGFloat = 15.0

    
    // MARK: Constants
    
    private let kSeparatorWidth: CGFloat = 0.5
    private let kDefaultWidth: CGFloat = 270.0
    private let kDefaultHeight: CGFloat = 144.0
    private let kDefaultTitleSizeMargin: CGFloat = 20.0
    private let kDefaultMessageSizeMargin: CGFloat = 20.0
    private let kDefaultButtonHeight: CGFloat = 44.0
    private let kDefaultCornerRadius: CGFloat = 12.0
    private let kDefaultTitleTopMargin: CGFloat = 20.0
    private let kDefaultTitleToMessageSpacing: CGFloat = 10.0
    private let kDefaultMessageBottomMargin: CGFloat = 20.0
    private let kDefaultDimAlpha: CGFloat = 0.2
    private let kDefaultAppearTime = 0.2
    private let kDefaultDisappearTime = 0.1
    private var kMoveUpWithKeyboardDistance: CGFloat = 150.0

    // MARK: Private Properties

    private var contentView: UIView?
    private var buttons: [UIButton] = []
    private var textFields: [UITextField] = []
    private var backgroundImageView: UIImageView?
    private var dimView: UIView?
    private var title: String?
    private var message: String?
    private var buttonTitles: [String] = []
    private var viewWidth: CGFloat = 0
    private var viewHeight: CGFloat = 0
    private var isMoveUpWithKeyboard = false
    
    private var onButtonClicked: ((_ buttonIndex: Int) -> Void)?
    private var onCancelClicked: (() -> Void)?
    private var onActionButtonClicked: ((_ buttonIndex: Int) -> (Void))?
    private var onTextChanged: ((_ text: String?, _ textFieldIndex: Int) -> Void)?

    // MARK: Initialization

    public init(title: String? = nil, message: String? = nil, buttonTitles: [String]) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))
        setUp(title: title, message: message, buttonTitles: buttonTitles)
    }

    public init(title: String? = nil, message: String? = nil, buttonTitles: String...) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))
        setUp(title: title, message: message, buttonTitles: buttonTitles)
    }

    public init(contentView: UIView, buttonTitles: [String]) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))
        setUp(contentView: contentView, buttonTitles: buttonTitles)
    }

    public init(contentView: UIView, buttonTitles: String...) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))
        setUp(contentView: contentView, buttonTitles: buttonTitles)
    }
    
    public init(nibName: String, buttonTitles: [String]) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))
        guard let contentView = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as? UIView else {
            fatalError("Could not load nib file")
        }
        setUp(contentView: contentView, buttonTitles: buttonTitles)
    }

    public init(nibName: String,
                buttonTitles: String...) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))
        guard let contentView = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as? UIView else {
            fatalError("Could not load nib file")
        }
        setUp(contentView: contentView, buttonTitles: buttonTitles)
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
    
    // access the text fields to customize their font & color
    public func textField(at index: Int) -> UITextField? {
        if index >= 0 && index < textFields.count {
            return textFields[index]
        }
        
        return nil
    }
    
    public func addTextField(configurationHandler: ((UITextField) -> Void)? = nil) {
        let textField = UITextField(frame: CGRect(x: textFieldSideMargin, y: 0, width: viewWidth - textFieldSideMargin * 2, height: textFieldHeight))
        textField.font = .systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.tag = textFields.count
        textField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        configurationHandler?(textField)
        textFields.append(textField)
        addSubview(textField)
    }
    
    // show the alert view at center of screen
    public func show() {
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            show(in: window)
        }
    }
    
    // show the alert view at center of a view
    public func show(in view: UIView) {
        layoutElementBeforeShowing()
        
        let isFocusTextField = isFocusTextFieldWhenShowing && !textFields.isEmpty
        var showY = (view.frame.size.height - viewHeight)/2
        if isFocusTextField {
            showY -= kMoveUpWithKeyboardDistance
            isMoveUpWithKeyboard = true
        }
        
        frame = CGRect(x: (view.frame.size.width - viewWidth)/2, y: showY, width: viewWidth, height: viewHeight)

        if isDimBackgroundWhenShowing {
            dimView = UIView(frame: view.bounds)
            if let color = dimBackgroundColor {
                dimView!.backgroundColor = color
            } else {
                dimView!.backgroundColor = UIColor(white: 0, alpha: CGFloat(dimAlpha))
            }
            view.addSubview(dimView!)
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(outsideTapped(_:)))
            dimView!.addGestureRecognizer(recognizer)
        }
        
        if isFocusTextField {
            textFields[0].becomeFirstResponder()
        }
        
        delegate?.willPresentAlertView?(self)

        view.addSubview(self)
        view.bringSubviewToFront(self)
        
        switch transitionType {
        case .default:
            if isFocusTextField {
                alpha = 0
                transform = CGAffineTransform(translationX: 0, y: 60)
                    .concatenating(CGAffineTransform(scaleX: 1.1, y: 1.1))
                UIView.animate(withDuration: appearTime, delay: 0, options: .curveEaseInOut) {
                    self.transform = CGAffineTransform.identity
                    self.alpha = 1
                } completion: { _ in
                    self.delegate?.didPresentAlertView?(self)
                }
            } else {
                transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                alpha = 0.6

                UIView.animate(withDuration: appearTime) {
                    self.transform = CGAffineTransform.identity
                    self.alpha = 1
                } completion: { _ in
                    self.delegate?.didPresentAlertView?(self)
                }
            }
        case .fade:
            alpha = 0

            UIView.animate(withDuration: appearTime, delay: 0, options: .curveEaseInOut) {
                self.alpha = 1
            } completion: { _ in
                self.delegate?.didPresentAlertView?(self)
            }
        case .vertical:
            let tempFrame = frame
            frame = CGRect(x: frame.origin.x, y: superview!.frame.size.height + 10, width: frame.size.width, height: frame.size.height)

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

        for textField in textFields {
            textField.resignFirstResponder()
        }
        
        if dimView != nil {
            UIView.animate(withDuration: disappearTime) {
                self.dimView?.alpha = 0
            } completion: { _ in
                self.dimView?.removeFromSuperview()
                self.dimView = nil
            }
        }

        switch transitionType {
        case .default:
            transform = CGAffineTransform.identity

            UIView.animate(withDuration: disappearTime, delay: 0.02, options: .curveEaseOut) {
                self.alpha = 0
            } completion: { _ in
                self.removeFromSuperview()
                self.delegate?.didDismissAlertView?(self)
            }
        case .fade:
            self.alpha = 1

            UIView.animate(withDuration: disappearTime, delay: 0.02, options: .curveEaseOut) {
                self.alpha = 0
            } completion: { _ in
                self.removeFromSuperview()
                self.delegate?.didDismissAlertView?(self)
            }
        case .vertical:
            UIView.animate(withDuration: disappearTime, delay: 0.02, options: .curveEaseOut) {
                self.frame = CGRect(x: self.frame.origin.x, y: self.superview!.frame.size.height + 10, width: self.frame.size.width, height: self.frame.size.height)
            } completion: { _ in
                self.removeFromSuperview()
                self.delegate?.didDismissAlertView?(self)
            }
        }
    }
    
    // handle events
    @discardableResult
    public func onButtonClicked(_ handler: @escaping (_ alertView: SwiftAlertView, _ buttonIndex: Int) -> Void) -> SwiftAlertView {
        self.onButtonClicked = { index in
            handler(self, index)
        }
        return self
    }
    
    @discardableResult
    public func onActionButtonClicked(_ handler: @escaping (_ alertView: SwiftAlertView, _ buttonIndex: Int) -> Void) -> SwiftAlertView {
        self.onActionButtonClicked = { index in
            handler(self, index)
        }
        return self
    }
    
    @discardableResult
    public func onTextChanged(_ handler: @escaping (_ alertView: SwiftAlertView, _ text: String?, _ textFieldIndex: Int) -> Void) -> SwiftAlertView {
        self.onTextChanged = { text, index in
            handler(self, text, index)
        }
        return self
    }
}


// MARK: Private Functions

extension SwiftAlertView {

    private func setUp(title: String? = nil,
                       message: String? = nil,
                       contentView: UIView? = nil,
                       buttonTitles: [String]) {
        self.title = title
        self.message = message
        self.buttonTitles = buttonTitles

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
        transitionType = .default
        buttonTitleColor = UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)
        layer.cornerRadius = CGFloat(cornerRadius)
    }
    
    private func setUpElements() {
        titleLabel = UILabel(frame: .zero)
        messageLabel = UILabel(frame: .zero)
        validationLabel = UILabel(frame: .zero)

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
            let button = _HighlightButton(type: .custom)
            button.setTitle(buttonTitle, for: .normal)
            buttons.append(button)
            addSubview(button)
        }
    }
    
    private func setUpDefaultAppearance() {
        self.backgroundColor = UIColor(red: 245.0/255, green: 245.0/255, blue: 245.0/255, alpha: 1)
        
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
        
        validationLabel.text = " "
        validationLabel.numberOfLines = 0
        validationLabel.lineBreakMode = .byWordWrapping
        validationLabel.textColor = .red
        validationLabel.font = .systemFont(ofSize: 13)
        validationLabel.textAlignment = .left
        
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
        if let backgroundImage = backgroundImage {
            backgroundImageView = UIImageView(frame: self.bounds)
            backgroundImageView?.image = backgroundImage
            addSubview(backgroundImageView!)
            sendSubviewToBack(backgroundImageView!)
        }

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
        
        let titleMessageHeight = titleTopMargin + titleLabel.frame.size.height + titleToMessageSpacing + messageLabel.frame.size.height + messageBottomMargin
        for i in 0..<textFields.count {
            let textField = textFields[i]
            textField.frame = CGRect(x: textField.frame.minX, y: titleMessageHeight + CGFloat(i) * (textField.frame.height + textFieldSpacing), width: textField.frame.width, height: textField.frame.height)
        }
        
        let textFieldPartHeight = textFields.isEmpty ? 0 : (textFields[0].frame.height + textFieldSpacing) * CGFloat(textFields.count) + textFieldBottomMargin - textFieldSpacing
        var topPartHeight = (contentView == nil) ? (titleMessageHeight + textFieldPartHeight) : contentView!.frame.size.height
        
        if isEnabledValidationLabel {
            addSubview(validationLabel)
            validationLabel.frame = CGRect(x: validationLabelSideMargin, y: topPartHeight + validationLabelTopMargin - textFieldBottomMargin, width: viewWidth - validationLabelSideMargin * 2, height: 0)
            labelHeightToFit(validationLabel)
            topPartHeight += validationLabel.frame.height + validationLabelTopMargin
        }
        
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
    
    private func updateCancelButtonIndex() {
        for i in 0..<buttons.count {
            let button = buttons[i]
            if i == cancelButtonIndex {
                button.titleLabel?.font = .boldSystemFont(ofSize: button.titleLabel?.font.pointSize ?? 17)
            } else {
                button.titleLabel?.font = .systemFont(ofSize: button.titleLabel?.font.pointSize ?? 17)
            }
        }
    }
    
    private func updateAlertStyle() {
        titleLabel.textColor = color(light: .black, dark: .white)
        messageLabel.textColor = color(light: .black, dark: .white)
        backgroundColor = color(light: UIColor(white: 0.96, alpha: 1), dark: UIColor(white: 0.16, alpha: 1))
        separatorColor = color(light: UIColor(red: 196.0/255, green: 196.0/255, blue: 201.0/255, alpha: 1.0), dark: UIColor(white: 0.4, alpha: 1))
        
        for button in buttons {
            (button as? _HighlightButton)?.highlightColor = color(light: UIColor(white: 0.2, alpha: 0.1), dark: UIColor(white: 0.5, alpha: 0.1))
        }
        for textField in textFields {
            textField.backgroundColor = color(light: .white, dark: UIColor(white: 0.1, alpha: 1))
            textField.textColor = color(light: .black, dark: .white)
        }
        
        if style == .dark {
            dimAlpha = 0.4
            for textField in textFields {
                textField.layer.borderColor = UIColor(white: 0.4, alpha: 1).cgColor
                textField.layer.borderWidth = 0.5
                textField.layer.cornerRadius = 6
            }
        }
    }
    
    
    // MARK: Actions
    
    @objc private func buttonClicked(_ button: UIButton) {
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
    
    @objc private func textChanged(_ textField: UITextField) {
        let index = textField.tag
        onTextChanged?(textField.text, index)
    }
    
    
    // MARK: Utils
    
    private func labelHeightToFit(_ label: UILabel) {
        let maxWidth = label.frame.size.width
        let maxHeight : CGFloat = 10000
        let rect = label.attributedText?.boundingRect(with: CGSize(width: maxWidth, height: maxHeight),
                                                      options: .usesLineFragmentOrigin, context: nil)
        var frame = label.frame
        frame.size.height = rect?.size.height ?? .zero
        label.frame = frame
    }
}


extension SwiftAlertView {

    @discardableResult
    public static func show(title: String? = nil,
                            message: String? = nil,
                            buttonTitles: [String],
                            configure: ((_ alertView: SwiftAlertView) -> Void)? = nil) -> SwiftAlertView {
        let alertView = SwiftAlertView(title: title, message: message, buttonTitles: buttonTitles)
        configure?(alertView)
        alertView.show()
        return alertView
    }

    @discardableResult
    public static func show(title: String? = nil,
                            message: String? = nil,
                            buttonTitles: String...,
                            configure: ((_ alertView: SwiftAlertView) -> Void)? = nil) -> SwiftAlertView {
        return show(title: title, message: message, buttonTitles: buttonTitles, configure: configure)
    }

    @discardableResult
    public static func show(contentView: UIView,
                            buttonTitles: [String],
                            configure: ((_ alertView: SwiftAlertView) -> Void)? = nil) -> SwiftAlertView {
        let alertView = SwiftAlertView(contentView: contentView, buttonTitles: buttonTitles)
        configure?(alertView)
        alertView.show()
        return alertView
    }

    @discardableResult
    public static func show(contentView: UIView,
                            buttonTitles: String...,
                            configure: ((_ alertView: SwiftAlertView) -> Void)? = nil) -> SwiftAlertView {
        return show(contentView: contentView, buttonTitles: buttonTitles, configure: configure)
    }

    @discardableResult
    public static func show(nibName: String,
                            buttonTitles: [String],
                            configure: ((_ alertView: SwiftAlertView) -> Void)? = nil) -> SwiftAlertView {
        let alertView = SwiftAlertView(nibName: nibName, buttonTitles: buttonTitles)
        configure?(alertView)
        alertView.show()
        return alertView
    }

    @discardableResult
    public static func show(nibName: String,
                            buttonTitles: String...,
                            configure: ((_ alertView: SwiftAlertView) -> Void)? = nil) -> SwiftAlertView {
        return show(nibName: nibName, buttonTitles: buttonTitles, configure: configure)
    }
}


@objc public protocol SwiftAlertViewDelegate : NSObjectProtocol {

    @objc optional func alertView(_ alertView: SwiftAlertView, clickedButtonAtIndex buttonIndex: Int)
    
    @objc optional func willPresentAlertView(_ alertView: SwiftAlertView) // before animation and showing view
    @objc optional func didPresentAlertView(_ alertView: SwiftAlertView) // after animation
    
    @objc optional func willDismissAlertView(_ alertView: SwiftAlertView) // before animation and showing view
    @objc optional func didDismissAlertView(_ alertView: SwiftAlertView) // after animation
}

extension SwiftAlertView: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if isMoveUpWithKeyboard { return }
        self.isMoveUpWithKeyboard = true
        UIView.animate(withDuration: 0.2) {
            self.frame = self.frame.offsetBy(dx: 0, dy: -self.kMoveUpWithKeyboardDistance)
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if !isMoveUpWithKeyboard { return }
        self.isMoveUpWithKeyboard = false
        UIView.animate(withDuration: 0.2) {
            self.frame = self.frame.offsetBy(dx: 0, dy: self.kMoveUpWithKeyboardDistance)
        }
    }
}

final class _HighlightButton: UIButton {
    var highlightColor = UIColor(white: 0.2, alpha: 0.1)
    private var bgColor: UIColor = .clear
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgColor = backgroundColor ?? .clear
    }
    
    override public var isHighlighted: Bool {
        didSet {
            let highlightedColor = bgColor == .clear ? highlightColor : bgColor.withAlphaComponent(0.66)
            backgroundColor = isHighlighted ? highlightedColor : bgColor
        }
    }
}

extension SwiftAlertView {
    func color(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13, *), style == .auto {
            return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
        } else if style == .dark {
            return dark
        } else {
            return light
        }
    }
}


