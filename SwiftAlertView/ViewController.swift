//
//  ViewController.swift
//  SwiftAlertViewDemo
//
//  Created by Dinh Quan on 8/28/15.
//  Copyright (c) 2015 Dinh Quan. All rights reserved.
//

import UIKit

final class ViewController: UITableViewController {

    let demoTitles: [String] = ["Dark Mode",
                                "Alert with Text Field",
                                "More Text Fields & Validation Label",
                                "Customize Font & Color",
                                "Custom Content View",
                                "Init From Nib File",
                                "Custom Background Image",
                                "Customize Transition Type"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: TableView Delegate & Datasource

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: false)

        switch indexPath.row {
        case 0:
            SwiftAlertView.show(title: "Lorem ipsum",
                                message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ",
                                buttonTitles: "Cancel", "Ok") {
                $0.style = .dark
            }
            .onButtonClicked { _, buttonIndex in
                print("Button Clicked At Index \(buttonIndex)")
            }
            
        case 1:
            SwiftAlertView.show(title: "Title",
                                message: "Message",
                                buttonTitles: "Button 1", "Button 2", "Button 3", "Cancel") { alertView in
                alertView.cancelButtonIndex = 3
                alertView.buttonTitleColor = UIColor(red: 0.8764, green: 0.5, blue: 0.3352, alpha: 1)
                alertView.addTextField { textField in
                    textField.placeholder = "Placeholder"
                }
            }
            .onActionButtonClicked { alert, buttonIndex in
                let text = alert.textField(at: 0)?.text ?? ""
                print("Text: ", text)
            }
            
        case 2:
            SwiftAlertView.show(title: "Sign in", buttonTitles: "Cancel", "Sign In") { alertView in
                alertView.addTextField { textField in
                    textField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [.foregroundColor: UIColor.gray])
                }
                alertView.addTextField { textField in
                    textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [.foregroundColor: UIColor.gray])
                }
                alertView.isEnabledValidationLabel = true
                alertView.isDismissOnActionButtonClicked = false
                alertView.style = .dark
            }
            .onActionButtonClicked { alert, buttonIndex in
                let username = alert.textField(at: 0)?.text ?? ""
                if username.isEmpty {
                    alert.validationLabel.text = "Username is incorrect"
                } else {
                    alert.dismiss()
                }
            }
            .onTextChanged { _, text, index in
                if index == 0 {
                    print("Username text changed: ", text ?? "")
                }
            }
            
        case 3:
            let alertView = SwiftAlertView(title: "Lorem ipsum",
                                           message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ",
                                           buttonTitles: ["Cancel", "OK"])

            alertView.backgroundColor = UIColor(red: 0.9852, green: 0.9827, blue: 0.92, alpha: 1)
            alertView.titleLabel.textColor = UIColor(red: 0.0, green: 0.7253, blue: 0.6017, alpha: 1)
            alertView.messageLabel.textColor = UIColor.orange
            alertView.titleLabel.font = UIFont(name: "Marker Felt", size: 30)
            alertView.messageLabel.font = UIFont(name: "Marker Felt", size: 20)
            alertView.button(at: 0)?.setTitleColor(.purple, for: .normal)
            alertView.button(at: 1)?.setTitleColor(.purple, for: .normal)
            alertView.button(at: 0)?.titleLabel?.font = UIFont(name: "Marker Felt", size: 20)
            alertView.button(at: 1)?.titleLabel?.font = UIFont(name: "Marker Felt", size: 20)
            alertView.delegate = self
            alertView.show()

        case 4:
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            let label = UILabel(frame: CGRect(x: 20, y: 0, width: 160, height: 200))
            label.text = "This is the custom content view"
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.textAlignment = .center
            view.addSubview(label)
            view.backgroundColor = .yellow

            let alertView = SwiftAlertView(contentView: view, buttonTitles: ["Cancel", "OK"])
            alertView.show()

        case 5:
            let alertView = SwiftAlertView(nibName: "CustomView", buttonTitles: ["I love this feature"])
            alertView.show()

        case 6:
            let alertView = SwiftAlertView(title: "Custom Background Image",
                                           message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ",
                                           buttonTitles: ["Cancel", "Button 1", "Button 2", "Button 3"])
            alertView.backgroundImage = #imageLiteral(resourceName: "alert-box")
            alertView.show()

        case 7:
            let alertView = SwiftAlertView(title: "Lorem ipsum",
                                           message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ",
                                           buttonTitles: ["Cancel", "Button 1", "Button 2", "Button 3"])
            alertView.transitionType = .vertical
            alertView.appearTime = 0.2
            alertView.disappearTime = 0.2
            alertView.show()
        default:
            ()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DemoCell", for: indexPath as IndexPath) as UITableViewCell
        cell.textLabel?.text = demoTitles[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoTitles.count
    }
}

// MARK: SwiftAlertViewDelegate

extension ViewController: SwiftAlertViewDelegate {
    func alertView(_ alertView: SwiftAlertView, clickedButtonAtIndex buttonIndex: Int) {
        print("Button Clicked At Index \(buttonIndex)")
    }

    func didPresentAlertView(alertView: SwiftAlertView) {
        print("Did Present Alert View\n")
    }

    func didDismissAlertView(alertView: SwiftAlertView) {
        print("Did Dismiss Alert View\n")
    }
}
