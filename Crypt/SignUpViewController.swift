//
//  SignUpViewController.swift
//  Crypt
//
//  Created by Mac Owner on 04/11/2015.
//  Copyright © 2015 Crypt transfer. All rights reserved.
//

import UIKit
import Lock
import MBProgressHUD
import SwiftValidator

class SignUpViewController: BaseUserInputViewController  {

    private struct Constants{
        static let email = NSLocalizedString("email", comment: "")
        static let password = NSLocalizedString("password", comment: "")
    }
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        validator.registerField(emailTextField, rules: [RequiredRule(),EmailRule()])
        validator.registerField(passwordTextField, rules: [RequiredRule(),PasswordRule()])
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func maximumLengthForTextField(textField: UITextField) -> Int {
        return 64
    }
    
    @IBAction func signUp() {
        validator.validate(self)
    }
    
    override func validationSuccessful() {
        // It is always good to add two layers of protection! Just in case one messed up with one  layer, the other layer should work!
        guard let email = emailTextField.text where email.isNotBlank else{
            self.showCannotBeEmptyAlert(Constants.email)
            return
        }
        guard email.isEmail else{
            self.showInvalidInputAlett(Constants.email)
            return
        }
        guard let password = passwordTextField.text where password.isNotBlank else{
            self.showCannotBeEmptyAlert(Constants.password)
            return
        }
        let client = GlobalState.sharedInstance.lock.apiClient()
        let parameters = A0AuthParameters(dictionary: [A0ParameterConnection : "Username-Password-Authentication"])
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        client.signUpWithEmail(email, password: password, loginOnSuccess: true, parameters: parameters, success: successCallback(hud), failure: errorCallback(hud))
    }
    
    private func errorCallback(hud: MBProgressHUD) -> NSError -> () {
        return { error in
            let alert = UIAlertController(title: "Sign up failed", message: "Please check you application logs for more info", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            print("Failed with error \(error)")
            hud.hide(true)
        }
    }
    
    private func successCallback(hud: MBProgressHUD) -> (A0UserProfile?, A0Token?) -> () {
        return { (profile, token) -> Void in
            let alert = UIAlertController(title: "Signed Up!", message: "User with name \(profile?.name) signed up!", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            print("Signed up user \(profile?.name)")
            print("Tokens: \(token)")
            hud.hide(true)
        }
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
