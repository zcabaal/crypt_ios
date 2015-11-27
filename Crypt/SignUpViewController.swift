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
        static let passwordDoNotMatch = NSLocalizedString("Passwords Do not Match", comment: "")
    }
    
    
    @IBOutlet weak var emailErrorLable: UILabel!{
        didSet{
            emailErrorLable.text = ""
        }
    }
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailExclamation: UILabel!{
        didSet{
            emailExclamation.hidden = true
        }
    }
    @IBOutlet weak var passwordErrorLable: UILabel!{
        didSet{
            passwordErrorLable.text = ""
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordExclamation: UILabel!{
        didSet{
            passwordExclamation.hidden = true
        }
    }
    @IBOutlet weak var confirmPasswordErrorLable: UILabel!{
        didSet{
            confirmPasswordErrorLable.text = ""
        }
    }
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordExclamation: UILabel!{
        didSet{
            confirmPasswordExclamation.hidden = true
        }
    }
    @IBOutlet weak var firstNameErrorLable: UILabel!{
        didSet{
            firstNameErrorLable.text = ""
        }
    }
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var firstNameExclamation: UILabel!{
        didSet{
            firstNameExclamation.hidden = true
        }
    }
    @IBOutlet weak var lastNameErrorLable: UILabel!{
        didSet{
            lastNameErrorLable.text = ""
        }
    }
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var lastNameExclamation: UILabel!{
        didSet{
            lastNameExclamation.hidden = true
        }
    }
    
    override func getExclamationLable(textField:UITextField) -> UILabel?{
        switch textField{
        case emailTextField:
            return emailExclamation
        case passwordTextField:
            return passwordExclamation
        case confirmPasswordTextField:
            return confirmPasswordExclamation
        case firstNameTextField:
            return firstNameExclamation
        case lastNameTextField:
            return lastNameExclamation
        default:
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        validator.registerField(emailTextField, errorLabel: emailErrorLable, rules: [RequiredRule(),EmailRule()])
        validator.registerField(passwordTextField, errorLabel: passwordErrorLable, rules: [RequiredRule(),PasswordRule()])
        validator.registerField(confirmPasswordTextField, errorLabel: confirmPasswordErrorLable, rules: [RequiredRule(),ConfirmationRule(confirmField: passwordTextField, message: Constants.passwordDoNotMatch)])
        validator.registerField(firstNameTextField, errorLabel: firstNameErrorLable, rules: [RequiredRule()])
        validator.registerField(lastNameTextField, errorLabel: lastNameErrorLable, rules: [RequiredRule()])
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            let errorMessage = error.userInfo["A0JSONResponseSerializerErrorDataKey"]?["description"] as? String ?? error.userInfo["NSLocalizedFailureReason"] as? String ?? "Oooops! an error have occured"
            self.showBasicAlert("Sign up Failed",message: errorMessage)
            print("Failed with error \(error)")
            hud.hide(true)
        }
    }
    
    private func successCallback(hud: MBProgressHUD) -> (A0UserProfile?, A0Token?) -> () {
        return { (profile, token) -> Void in
            self.showBasicAlert("Signed Up!", message: "User with name \(profile?.name) signed up!")
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
