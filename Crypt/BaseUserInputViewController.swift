//
//  BaseUserInputViewController.swift
//  Crypt
//
//  Created by Mac Owner on 04/11/2015.
//  Copyright © 2015 Crypt transfer. All rights reserved.
//

import UIKit
import SwiftValidator


class BaseUserInputViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate, ValidationDelegate {

    let validator = Validator()
    var activeTextField : UITextField?
    var addedKbOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BaseUserInputViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BaseUserInputViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // override to set the maximum length of a text field
    func maximumLengthForTextField(textField: UITextField) -> Int{
        return 64
    }
    
    func getExclamationLable(textField:UITextField) -> UILabel?{
        return nil
    }
    
    // MARK: - show alerts
    func showCannotBeEmptyAlert(fieldName: String){
        showBasicAlert(NSLocalizedString("\(fieldName) cannot be empty", comment: "This is an alert message when user leaves a required text field empty"))
    }
    
    func showInvalidInputAlett(fieldName: String){
        showBasicAlert(NSLocalizedString("Please enter a valid \(fieldName)", comment: "This is an alert message when user does not enter a valid input"))
    }
    func showBasicAlert(message: String){
        showBasicAlert(nil,message: message)
    }
    
    func showBasicAlert(title: String?, message: String){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - text field delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeTextField = nil
        let validation = validator.validations[textField]
        let errorLable = validation?.errorLabel
        let exclamationLable = self.getExclamationLable(textField)
        let error = validation?.validateField()
        if (error != nil) {
            errorLable?.text = error?.errorMessage
            exclamationLable?.hidden = false
        }
        else{
            errorLable?.text = ""
            exclamationLable?.hidden = true
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        //src: http://stackoverflow.com/questions/433337/set-the-maximum-character-length-of-a-uitextfield
        let oldLength = textField.text?.characters.count ?? 0
        if (range.length + range.location > oldLength )
        {
            return false;
        }
        
        let newLength = oldLength + string.characters.count - range.length
        return newLength <= maximumLengthForTextField(textField)
    }
    
    // MARK: - Validation delegate
    func validationSuccessful() {
        
    }
    
    func validationFailed(errors: [UITextField : ValidationError]) {
        var message = "You have \(errors.count) error(s):\n"
        for error in errors{
            message += "- "
            message += error.0.placeholder ?? ""
            message += " : "
            message += error.1.errorMessage
            message += "\n"
        }
        showBasicAlert(message)
    }
    
    // MARK: - Keyboard
    
    func keyboardWillShow(sender: NSNotification){
        if let kbSize = sender.userInfo?[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.size, activeField = activeTextField{
            var aRect = self.view.frame;
            aRect.size.height -= kbSize.height + activeField.frame.size.height;
            if (!CGRectContainsPoint(aRect, activeField.frame.origin ) && addedKbOffset==0) {
                self.view.frame.origin.y -= kbSize.height
                addedKbOffset = kbSize.height
            }
            
        }
    }
    
    func keyboardWillHide(sender: NSNotification){
        self.view.frame.origin.y += addedKbOffset
        addedKbOffset = 0
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension String{
    //To check text field or String is blank or not
    //src:http://stackoverflow.com/questions/27998409/email-phone-validation-in-swift
    var isNotBlank: Bool {
        get {
            return !stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty
        }
    }
    
    //Validate Email
    //src:http://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
    var isEmail: Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self)
    }
    
}
