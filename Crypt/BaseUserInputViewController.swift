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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - text field delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
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
