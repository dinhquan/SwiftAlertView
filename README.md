SwiftAlertView
===========

A powerful customizable Alert View library written in Swift.

SwiftAlertView is the best alternative for UIKit's UIAlertView and UIAlertController.
With SwiftAlertView, you can easily make your desired Alert View in some lines of code.

![](https://dl.dropboxusercontent.com/u/61390634/SwiftAlertViewPhoto/d1.png)      ..![](https://dl.dropboxusercontent.com/u/61390634/SwiftAlertViewPhoto/d2.png)
..![](https://dl.dropboxusercontent.com/u/61390634/SwiftAlertViewPhoto/d3.png)

## Getting started

#### Using CocoaPods
Just add the following line in to your pod file:
```
pod 'SwiftAlertView', '~> 1.0.2'
```
#### Manually
Drag and drop the file named ```SwiftAlertView``` in your project and you are done.

## Highlight Features

- Initialize the alert view with a custom view.
- Initialize the alert view with a xib file.
- Closure and callbacks for handling button touched events.
- Change the alert appearance: background color or background image, border radius.
- Change the title appearance: font, color, margin, spacing, visibility.
- Change the message appearance: font, color, margin, spacing, visibility.
- Change the button appearance: font, color.
- Change the separator appearance: color, visibility.
- Change the alert appear behaviour and disappear behaviour.
- APIs are exactly same as UIAlertView.
- And many more ...

## Usage

#### Initilization

```swift
// Initialize with title and message
let alertView = SwiftAlertView(title: "Sample Title", message: "Sample Message", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Button 1", "Button 2", "Button 3")

// Initialize with a custom view
let alertView = SwiftAlertView(contentView: customView, delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")

// Initialize with nib name
let alertView = SwiftAlertView(nibName: "CustomView", delegate: self, cancelButtonTitle: "I love this feature")

```

#### Show and dismiss

```objective-c
// Show at center of screen
alertView.show()

// Show at center of a view
alertView.show(view)

// Programmatically dismiss the alert view
alertView.dismiss()

```

#### Button touching event handler

```swift

alertView.clickedButtonAction = {(buttonIndex) -> Void in
  println("Button Clicked At Index \(buttonIndex)")
}
alertView.clickedCancelButtonAction = {
  println("Cancel Button Clicked")
}
alertView.clickedOtherButtonAction = {(buttonIndex) -> Void in
  println("Other Button Clicked At Index \(buttonIndex)")
}

```

If you don't want to use closures, make your view controller conform ```SwiftAlertViewDelegate``` and use delegate methods:

```swift

func alertView(alertView: SwiftAlertView, clickedButtonAtIndex buttonIndex: Int) {
  println("Button Clicked At Index \(buttonIndex)")
}

func didPresentAlertView(alertView: SwiftAlertView) {
  println("Did Present Alert View")
}

func didDismissAlertView(alertView: SwiftAlertView) {
  println("Did Dismiss Alert View")
}

```
#### Customization

SwiftAlertView can be customized with the following properties:

```swift

var titleLabel: UILabel! // access titleLabel to customize the title font, color
var messageLabel: UILabel! // access messageLabel to customize the message font, color

var cancelButtonIndex: Int! // default is 0, set this property if you want to change the position of cancel button

var backgroundImage: UIImage?
// var backgroundColor: UIColor? // inherits from UIView

var buttonTitleColor: UIColor! // to change the title color of all buttons
var buttonHeight: Double! // default is 44

var separatorColor: UIColor! // to change the separator color
var hideSeparator: Bool! // to hide the separater color
var cornerRadius: Double! // default is 8 px

var dismissOnOtherButtonClicked: Bool! // default is true, if you want the alert view will not be dismissed when clicking on other buttons, set this property to false
var highlightOnButtonClicked: Bool! // default is true
var dimBackgroundWhenShowing: Bool! // default is true
var dimAlpha: Double! // default is 0.2
var dismissOnOutsideClicked: Bool! // default is true

var appearTime: Double! // default is 0.2 second
var disappearTime: Double! // default is 0.1 second

var appearType: SwiftAlertViewAppearType! // to change the appear type
var disappearType: SwiftAlertViewDisappearType! // to change the disappear type

// customize the margin & spacing of title & message
var titleSideMargin: Double!
var messageSideMargin: Double!
var titleTopMargin: Double!
var titleToMessageSpacing: Double!
var messageBottomMargin: Double!

// closure for handling button clicked action
var clickedButtonAction:((buttonIndex: Int) -> (Void))? // all buttons
var clickedCancelButtonAction:((Void) -> (Void))? // for cancel button
var clickedOtherButtonAction:((buttonIndex: Int) -> (Void))? // sometimes you want to handle the other button click event but don't want to write if/else in clickedButtonAction closure, use this property

// access the buttons to customize their font & color
func buttonAtIndex(index: Int) -> UIButton?

```

## Contributing
Contributions for bug fixing or improvements are welcomed. Feel free to submit a pull request.
If you have any questions, feature suggestions or bug reports, please send me an email to dinhquan191@gmail.com.

