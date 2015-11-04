//
//  BaseUserInputViewController.swift
//  Crypt
//
//  Created by Mac Owner on 04/11/2015.
//  Copyright © 2015 Crypt transfer. All rights reserved.
//

import UIKit


class BaseUserInputViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    // override to set the maximum length of a text field
    func maximumLengthForTextField(textField: UITextField) -> Int{
        return Int.max
    }
    
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
