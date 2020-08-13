SwiftAlertView
===========

A powerful customizable Alert View library written in Swift.

Feeling painful when working with UIAlertController, SwiftAlertView is the best alternative for UIKit's UIAlertView and UIAlertController.
With SwiftAlertView, you can easily make your desired Alert View in some lines of code.

![](https://dl.dropboxusercontent.com/u/61390634/SwiftAlertViewPhoto/d1.png)      ..![](https://dl.dropboxusercontent.com/u/61390634/SwiftAlertViewPhoto/d2.png)
..![](https://dl.dropboxusercontent.com/u/61390634/SwiftAlertViewPhoto/d3.png)

## Getting started

#### Using CocoaPods
Just add the following line in to your pod file:
```
pod 'SwiftAlertView', '~> 1.3.0'
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
let alertView = SwiftAlertView(title: "Sample Title", message: "Sample Message", cancelButtonTitle: "Cancel", otherButtonTitles: "Button 1", "Button 2", "Button 3")

// Initialize with a custom view
let alertView = SwiftAlertView(contentView: customView, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")

// Initialize with nib name
let alertView = SwiftAlertView(nibName: "CustomView", delegate: self, cancelButtonTitle: "I love this feature")

```

#### Show and dismiss

```objective-c
// Show at center of screen
alertView.show()

// Show at center of a view
alertView.show(in: view)

// Programmatically dismiss the alert view
alertView.dismiss()

```

#### Use static method to show alert

```swift
SwiftAlertView.show(title: "Lorem ipsum", message: "Lorem ipsum dolor sit amet", cancelButtonTitle: "Cancel", otherButtonTitles: ["OK"], configureAppearance: { (alertView: SwiftAlertView) -> (Void) in
    
    // customize alert view appearance here
    alertView.backgroundColor = UIColor ( red: 0.8733, green: 0.5841, blue: 0.909, alpha: 1.0 )
    
    }, clickedButtonAction: { [weak self] buttonINdex in
        print("Button Clicked At Index \(buttonIndex)")
})

```

#### Button touching event handler

```swift

alertView.clickedButtonAction = { [weak self] buttonIndex in
  println("Button Clicked At Index \(buttonIndex)")
}
alertView.clickedCancelButtonAction = { [weak self]
  println("Cancel Button Clicked")
}
alertView.clickedOtherButtonAction = { [weak self] buttonIndex in
  println("Other Button Clicked At Index \(buttonIndex)")
}

```

If you don't want to use closures, make your view controller conform ```SwiftAlertViewDelegate``` and use delegate methods:

```swift

func alertView(_ alertView: SwiftAlertView, clickedButtonAtIndex buttonIndex: Int) {
  println("Button Clicked At Index \(buttonIndex)")
}

func didPresentAlertView(_ alertView: SwiftAlertView) {
  println("Did Present Alert View")
}

func didDismissAlertView(_ alertView: SwiftAlertView) {
  println("Did Dismiss Alert View")
}

```
#### Customization

SwiftAlertView can be customized with the following properties:

```swift

public var titleLabel: UILabel! // access titleLabel to customize the title font, color
public var messageLabel: UILabel! // access messageLabel to customize the message font, color

public var cancelButtonIndex = 0 // default is 0, set this property if you want to change the position of cancel button

public var backgroundImage: UIImage?
// public var backgroundColor: UIColor? // inherits from UIView

public var buttonTitleColor = UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1) // to change the title color of all buttons
public var buttonHeight: CGFloat = 44.0 // default is 44

public var separatorColor: UIColor! // to change the separator color
public var hideSeparator = false // to hide the separater color
public var cornerRadius: CGFloat = 8.0 // default is 8 px

public var dismissOnOtherButtonClicked = true // default is true, if you want the alert view will not be dismissed when clicking on other buttons, set this property to false
public var highlightOnButtonClicked = true // default is true
public var dimBackgroundWhenShowing = true // default is true
public var dimAlpha: CGFloat = 0.2 // default is 0.2
public var dismissOnOutsideClicked = false // default is false

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

// closure for handling button clicked action
public var clickedButtonAction: ((_ buttonIndex: Int) -> (Void))? // all buttons
public var clickedCancelButtonAction: (() -> Void)? // for cancel button
public var clickedOtherButtonAction: ((_ buttonIndex: Int) -> (Void))? // sometimes you want to handle the other button click event but don't want to write if/else in clickedButtonAction closure, use this property

```

## Contributing
Contributions for bug fixing or improvements are welcomed. Feel free to submit a pull request.
If you have any questions, feature suggestions or bug reports, please send me an email to dinhquan191@gmail.com.

