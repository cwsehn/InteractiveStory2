//
//  ViewController.swift
//  InteractiveStory2
//
//  Created by Chris William Sehnert on 7/3/17.
//  Copyright © 2017 InSehnDesigns. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    enum Error: ErrorType {
        case NoName
    }
    

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* NotificationCenters exist on every app...they serve to notify of impending system behaviors...
            in this case the app is listening for a notification that the "keyboardView" is coming so 
            that it can adjust the placement of the UITextField accordingly...
        */
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyBoardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyBoardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startAdventure" {
            /*
             do/catch block...allows for error handling...
                ...in this case a modally presented AlertView...
            */
            do {
                if let name = nameTextField.text {
                    if name == "" {
                        throw Error.NoName
                    }
                    if let pageController = segue.destinationViewController as? PageController {
                        pageController.page = Adventure.trip(name)
                    }
                }
            } catch Error.NoName {
                let alertController = UIAlertController(title: "Name Not Provided", message: "Provide a name to start your adventure!", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(action)
                
                presentViewController(alertController, animated: true, completion: nil)
             
            // final catch guarantees "do" block is exhaustive....
            } catch let error { fatalError("\(error)") }
        }
    }
    
    func keyBoardWillShow(notification: NSNotification) {
        if let userInfoDict = notification.userInfo, keyboardFrameValue = userInfoDict[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardFrameValue.CGRectValue()
            
            UIView.animateWithDuration(0.8) {
                self.textFieldBottomConstraint.constant = keyboardFrame.size.height + 10
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func keyBoardWillHide() {
        UIView.animateWithDuration(1.0) {
            self.textFieldBottomConstraint.constant = 40
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

