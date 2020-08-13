//
//  ViewController.swift
//  SwiftAlertViewDemo
//
//  Created by Dinh Quan on 8/28/15.
//  Copyright (c) 2015 Dinh Quan. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, SwiftAlertViewDelegate {

    var demoTitles: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()

        demoTitles = ["No Title", "More Than Two Buttons", "Customize Font & Color", "Custom Content View", "Init From Nib File", "Customize Appearance Type", "Static Method"]
        tableView.reloadData()
    }

    
    // MARK: SwiftAlertViewDelegate
    
    func alertView(_ alertView: SwiftAlertView, clickedButtonAtIndex buttonIndex: Int) {
        print("Button Clicked At Index \(buttonIndex)")
    }
    
    func didPresentAlertView(alertView: SwiftAlertView) {
        print("Did Present Alert View\n")
    }
    
    func didDismissAlertView(alertView: SwiftAlertView) {
        print("Did Dismiss Alert View\n")
    }
    

    // MARK: TableView Delegate & Datasource

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: false)
        
        switch indexPath.row {
        case 0:
            let alertView = SwiftAlertView(title: nil, message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
            alertView.clickedButtonAction = {(buttonIndex) -> Void in
                print("Button Clicked At Index \(buttonIndex)")
            }
            alertView.clickedCancelButtonAction = {
                print("Cancel Button Clicked")
            }
            alertView.clickedOtherButtonAction = {(buttonIndex) -> Void in
                print("Other Button Clicked At Index \(buttonIndex)")
            }
            alertView.show()
            
            break
        case 1:
            let alertView = SwiftAlertView(title: "Lorem ipsum ", message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Button 1", "Button 2", "Button 3")
            alertView.cancelButtonIndex = 3
            alertView.buttonTitleColor = UIColor ( red: 0.8764, green: 0.5, blue: 0.3352, alpha: 1.0 )
            alertView.show()
            
            break
        case 2:
            let alertView = SwiftAlertView(title: "Lorem ipsum ", message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
            
            alertView.backgroundColor = UIColor ( red: 0.9852, green: 0.9827, blue: 0.92, alpha: 1.0 )
            
            alertView.titleLabel.textColor = UIColor ( red: 0.0, green: 0.7253, blue: 0.6017, alpha: 1.0 )
            alertView.messageLabel.textColor = UIColor.orange
            alertView.titleLabel.font = UIFont(name: "Marker Felt", size: 30)
            alertView.messageLabel.font = UIFont(name: "Marker Felt", size: 20)
            alertView.buttonAtIndex(index: 0)?.setTitleColor(.purple, for: .normal)
            alertView.buttonAtIndex(index: 1)?.setTitleColor(.purple, for: .normal)
            alertView.buttonAtIndex(index: 0)?.titleLabel?.font = UIFont(name: "Marker Felt", size: 20)
            alertView.buttonAtIndex(index: 1)?.titleLabel?.font = UIFont(name: "Marker Felt", size: 20)
            
            alertView.show()
            
            break
        case 3:
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            let label = UILabel(frame: CGRect(x: 20, y: 0, width: 160, height: 200))
            label.text = "This is the custom content view"
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.textAlignment = .center
            view.addSubview(label)
            view.backgroundColor = .yellow
            
            let alertView = SwiftAlertView(contentView: view, delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
            alertView.show()
            
            break
        case 4:
            let alertView = SwiftAlertView(nibName: "CustomView", delegate: self, cancelButtonTitle: "I love this feature")
            alertView.show()
            
            break
        case 5:
            let alertView = SwiftAlertView(title: "Lorem ipsum ", message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Button 1", "Button 2", "Button 3")
            alertView.appearType = SwiftAlertViewAppearType.FlyFromTop
            alertView.disappearType = SwiftAlertViewDisappearType.FlyToRight
            alertView.appearTime = 1
            alertView.disappearTime = 1
            
            alertView.show()
            break
        case 6:
            SwiftAlertView.show(title: "Lorem ipsum", message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: ["OK"], configureAppearance: { (alertView: SwiftAlertView) -> (Void) in
                
                // customize alert view appearance here
                alertView.backgroundColor = UIColor ( red: 0.8733, green: 0.5841, blue: 0.909, alpha: 1.0 )
                
                }, clickedButtonAction: { (buttonIndex) -> (Void) in
                    print("Button Clicked At Index \(buttonIndex)")
            })
            break
        default:
            break
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

